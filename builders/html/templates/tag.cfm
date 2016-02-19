<cfparam name="args.page" type="page" />

<cfset tag = args.page />

<cfoutput>
	<a class="pull-right" href="#getSourceLink( path=tag.getSourceFile() )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
	#markdownToHtml( tag.getBody() )#

	<h2>Usage</h2>
```lucee
#tag.getUsageSignature()#
```

	#markdownToHtml( Trim( tag.getBodyTypeDescription() ) )#
	#markdownToHtml( Trim( tag.getScriptSupportDescription() ) )#

	<h2>Attributes</h2>
	<cfif !tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<cfscript>
 		// do we have default values?
 		hasDefaultValue=false;
 		loop array=tag.getAttributes() item="attr" {
 			if(!isNull(attr.defaultValue))
 				hasDefaultValue=true;
 		}
 		</cfscript>
		<div class="table-responsive">
			<table class="table" title="Attributes">
				<thead>
					<tr>
						<th>Attribute</th>
						<th>Description</th>
						<cfif hasDefaultValue><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#tag.getAttributes()#" item="attrib" index="i">
						<tr>
							<td>
								#attrib.name#<br>
								<sub>(#attrib.type#, #( attrib.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								<a class="pull-right" href="#getSourceLink( path=tag.getSourceDir() & '_attributes/#attrib.name#.md' )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
								#markdownToHtml( attrib.description ?: "" )#
							</td>
 							<cfif hasDefaultValue>
 								<td>
 									#markdownToHtml( attrib.defaultValue ?: "" )#
 								</td>
 							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfif>

	<h2>Examples</h2>
	<cfif Len( Trim( tag.getExamples() ) )>
		<a class="pull-right" href="#getSourceLink( path=tag.getSourceDir() & '_examples.md' )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
		#markdownToHtml( tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag</em>
	</cfif>
</cfoutput>