/**
 * Quartz job listener: records every run of every job.
 * Duration, success or error, and the AI tokens the job reported (see JobStats.cfc).
 * Writes one JSON line per run to job-stats.jsonl and warns in the log when a run fails
 * or uses more tokens than "tokenWarning".
 *
 * Configured in the "listeners" section of quartz/config.json; all keys of that entry arrive in init().
 */
component implementsJava="org.quartz.JobListener" {

	public void function init( struct listenerData = {} ) {
		variables.outputDirectory = listenerData.outputDirectory ?: "/opt/lucee/output";
		variables.tokenWarning = val( listenerData.tokenWarning ?: 0 );
	}

	public string function getName() {
		return "JobStatsListener";
	}

	public void function jobToBeExecuted( context ) {
		// start the run with a clean token counter
		new JobStats().takeTokens( getLabel( context ) );
	}

	public void function jobExecutionVetoed( context ) {
	}

	public void function jobWasExecuted( context, jobException ) {
		var label = getLabel( context );
		var run = {
			"job": label,
			"finished": dateTimeFormat( now(), "iso" ),
			"durationMs": context.getJobRunTime(),
			"status": isNull( jobException ) ? "ok" : "error",
			"error": isNull( jobException ) ? "" : jobException.getMessage(),
			"aiTokens": new JobStats().takeTokens( label )
		};

		if ( !directoryExists( variables.outputDirectory ) ) directoryCreate( variables.outputDirectory );
		fileAppend( variables.outputDirectory & "/job-stats.jsonl", serializeJSON( run ) & chr( 10 ) );

		var text = "JobStats: [#label#] #run.status# in #run.durationMs#ms, #run.aiTokens# AI tokens";
		if ( run.status == "error" ) {
			log log="scheduler" type="error" text=text & ": " & run.error;
		}
		else if ( variables.tokenWarning > 0 && run.aiTokens > variables.tokenWarning ) {
			log log="scheduler" type="warn" text=text & " (above tokenWarning #variables.tokenWarning#)";
		}
		else {
			log log="scheduler" type="info" text=text;
		}
	}

	private string function getLabel( context ) {
		var detail = context.getJobDetail();
		return detail.getJobDataMap()[ "label" ] ?: detail.getKey().toString();
	}
}
