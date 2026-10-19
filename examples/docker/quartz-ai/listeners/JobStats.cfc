/**
 * Small shared store for per run numbers a job wants to report (here: AI tokens).
 * The job adds to it, JobStatsListener reads and resets it around every run.
 * Kept in the server scope, keyed by job label; good enough for jobs that do not overlap.
 */
component {

	/** adds the tokens used by all answers of an AI session to the job's counter */
	public void function addTokens( required string label, required any aiSession ) {
		var tokens = 0;
		try {
			// the session's conversation history; every response knows its token usage.
			// note: these are Java methods of the AI session, not a documented CFML function, they may change.
			for ( var conversation in arguments.aiSession.getHistory() ) {
				tokens += conversation.getResponse().getTotalTokenUsed();
			}
		}
		catch ( any e ) {
			return; // engine does not report usage, nothing to count
		}
		var stats = store();
		lock name="quartz-ai-job-stats" type="exclusive" timeout=5 {
			stats[ arguments.label ] = ( stats[ arguments.label ] ?: 0 ) + tokens;
		}
	}

	/** returns the counter for a job and resets it */
	public numeric function takeTokens( required string label ) {
		var stats = store();
		lock name="quartz-ai-job-stats" type="exclusive" timeout=5 {
			var tokens = stats[ arguments.label ] ?: 0;
			structDelete( stats, arguments.label );
		}
		return tokens;
	}

	private struct function store() {
		if ( !structKeyExists( server, "quartzAIJobStats" ) ) server.quartzAIJobStats = {};
		return server.quartzAIJobStats;
	}
}
