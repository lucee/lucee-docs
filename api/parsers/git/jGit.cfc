component output=false 
	javasettings = '{
		maven = ["org.eclipse.jgit:org.eclipse.jgit:7.3.0.202506031305-r"]
	}'
{
	import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
	import org.eclipse.jgit.revwalk.RevWalk;
	import org.eclipse.jgit.treewalk.filter.PathFilter;
	import org.eclipse.jgit.revwalk.RevSort;
	import org.eclipse.jgit.api.Git;
	import java.io.File;
	import java.util.Date;
	
	public function getFileCommitDates(required string repoPath, required string folder, required struct files, required string mode) {
		try {
			var gitPath = ExpandPath( repoPath & "/.git" );
			if ( !DirectoryExists( gitPath ) )	
				throw( ".git directory not found at [#gitPath#]" );
			var repository = new FileRepositoryBuilder().setGitDir(	new File(gitPath ) ).readEnvironment().findGitDir().build();
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
