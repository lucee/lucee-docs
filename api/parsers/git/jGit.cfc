component output=false 
	javasettings = '{
		maven = ["org.eclipse.jgit:org.eclipse.jgit:7.3.0.202506031305-r"]
	}'
{
	import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
	import org.eclipse.jgit.revwalk.RevWalk;
	import org.eclipse.jgit.treewalk.filter.PathFilter;
	import org.eclipse.jgit.treewalk.filter.PathFilterGroup;
	import org.eclipse.jgit.treewalk.filter.TreeFilter;
	import org.eclipse.jgit.treewalk.TreeWalk;
	import org.eclipse.jgit.revwalk.RevSort;
	import org.eclipse.jgit.api.Git;
	import org.eclipse.jgit.diff.DiffFormatter;
	import org.eclipse.jgit.util.io.DisabledOutputStream;
	import java.io.File;
	import java.util.Date;
	
	public function openRepository( required string repoPath ) {
		var gitPath = ExpandPath( arguments.repoPath & "/.git" );
		if ( !DirectoryExists( gitPath ) )
			throw( ".git directory not found at [#gitPath#]" );
		return new FileRepositoryBuilder().setGitDir( new File( gitPath ) ).readEnvironment().findGitDir().build();
	}

	public function getFileCommitDates(required string repoPath, required string folder, required struct files, required string mode) {
		try {
			var repository = openRepository( arguments.repoPath );
			var _mode = arguments.mode;
			var _folder = arguments.folder;
			structEach( files, function( name, file ){
				if ( !file.isDirty ) return;
				switch (_mode){
					case "all":
						file[ "commits" ] = getAllDatesforFile( repository, _folder & file.name );
						break;
					default:
						file[ "commits" ] = getCreatedUpdatedForFile( repository, _folder & file.name );
				}
			}, true );

			repository.close();
		} catch ( any e ) {
			throw( message="Failed to enumerate commits: " & e.message, cause=e );
		}
		return files;
	}

	// returns all the dates for commits
	private function getAllDatesforFile( repository, filePath ){
		var Git = new Git( repository );
		var commits = [];
		var logCmd = git.log().addPath( replace( arguments.filePath, "\", "/", "all" ) );
		var commitIter = logCmd.call().iterator();
		while ( commitIter.hasNext() ) {
			var commit = commitIter.next();
			commits.append(
				new Date( javacast( "long", commit.getCommitTime() * 1000 ) )
			); // getName() returns the commit hash
		}
		return commits;
	}

	// single walk: collects all commit dates for all files in a folder in one pass
	public function getAllDatesForFolder( required any repository, required string folder, required struct files ) {
		var git = new Git( arguments.repository );
		var folderPath = replace( arguments.folder, "\", "/", "all" );
		// build a set of filenames we care about
		var fileNames = {};
		structEach( arguments.files, function( name, file ) {
			if ( !file.isDirty ) return;
			fileNames[ folderPath & name ] = name;
			file[ "commits" ] = [];
		});
		if ( structIsEmpty( fileNames ) ) return arguments.files;

		// single git log over the whole folder
		var logCmd = git.log().addPath( folderPath.left( len( folderPath ) - 1 ) ); // strip trailing slash
		var commitIter = logCmd.call().iterator();
		var df = new DiffFormatter( DisabledOutputStream::INSTANCE );
		df.setRepository( arguments.repository );
		df.setPathFilter( PathFilter::create( folderPath.left( len( folderPath ) - 1 ) ) );

		while ( commitIter.hasNext() ) {
			var commit = commitIter.next();
			var commitDate = new Date( javacast( "long", commit.getCommitTime() * 1000 ) );
			var parentCount = commit.getParentCount();

			if ( parentCount == 0 ) {
				// root commit — walk all entries in the tree
				var tw = new TreeWalk( arguments.repository );
				tw.addTree( commit.getTree() );
				tw.setRecursive( true );
				while ( tw.next() ) {
					var p = tw.getPathString();
					if ( structKeyExists( fileNames, p ) )
						arguments.files[ fileNames[ p ] ].commits.append( commitDate );
				}
				tw.close();
			} else if ( parentCount == 1 ) {
				// normal commit — diff against parent
				var diffs = df.scan( commit.getParent( 0 ), commit.getTree() );
				var iter = diffs.iterator();
				while ( iter.hasNext() ) {
					var entry = iter.next();
					var newPath = entry.getNewPath();
					var oldPath = entry.getOldPath();
					if ( structKeyExists( fileNames, newPath ) )
						arguments.files[ fileNames[ newPath ] ].commits.append( commitDate );
					else if ( structKeyExists( fileNames, oldPath ) )
						arguments.files[ fileNames[ oldPath ] ].commits.append( commitDate );
				}
			} else {
				// merge commit — only count a file if it differs from ALL parents
				// (matches git log's history simplification)
				var changedInAll = {};
				for ( var pi = 0; pi < parentCount; pi++ ) {
					var parentDiffs = df.scan( commit.getParent( pi ), commit.getTree() );
					var changedVsParent = {};
					var pIter = parentDiffs.iterator();
					while ( pIter.hasNext() ) {
						var pEntry = pIter.next();
						var pNew = pEntry.getNewPath();
						var pOld = pEntry.getOldPath();
						if ( structKeyExists( fileNames, pNew ) )
							changedVsParent[ pNew ] = true;
						else if ( structKeyExists( fileNames, pOld ) )
							changedVsParent[ pOld ] = true;
					}
					if ( pi == 0 ) {
						changedInAll = changedVsParent;
					} else {
						// intersect: only keep files changed vs every parent
						for ( var key in changedInAll ) {
							if ( !structKeyExists( changedVsParent, key ) )
								structDelete( changedInAll, key );
						}
					}
				}
				for ( var path in changedInAll ) {
					if ( structKeyExists( fileNames, path ) )
						arguments.files[ fileNames[ path ] ].commits.append( commitDate );
				}
			}
		}
		df.close();
		return arguments.files;
	}

	// returns the first and last commit date (slower than getAllDatesforFile)
	private function getCreatedUpdatedForFile( repository, filePath ){
		var commits = [];
		var revWalk = new RevWalk( repository );
		var headCommit = revWalk.parseCommit( repository.resolve( "HEAD" ) );
		revWalk.setTreeFilter( PathFilter::create( replace( arguments.filePath, "\", "/", "all" ) ) );
		revWalk.markStart( headCommit );

		var lastModifiedCommit = revWalk.next();
		if ( !isNull( lastModifiedCommit ) ) {
			commits.append( new Date( javacast( "long", lastModifiedCommit.getCommitTime() * 1000 ) ) );
		}
		revWalk.reset();
		revWalk.markStart( headCommit );
		revWalk.sort( RevSort::REVERSE );

		var createdCommit = revWalk.next();
		if ( !isNull( createdCommit ) ) {
			commits.append( new Date( javacast( "long", createdCommit.getCommitTime() * 1000 ) ) );
		}

		revWalk.dispose();
		return commits;
	}

}
