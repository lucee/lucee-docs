

```lucee+trycf
<cfloop list="ar_AE,ar_JO,ar_SY,hr_HR,fr_BE,es_PA,mt_MT,es_VE,bg,zh_TW,it,ko,uk,lv,da_DK,es_PR,vi_VN,en_US,sr_ME,sv_SE,es_BO,en_SG,ar_BH,pt,ar_SA,sk,ar_YE,hi_IN,ga,en_MT" index="i" delimiters=",">
	<cfset oldlocale = setLocale(i)>
    <cfoutput><p><b><i>#i#</i></b><br />
		#lsNumberFormat(-1234.5678, "_________")#<br />
		#lsNumberFormat(-1234.5678, "_________.___")#<br />
		#lsNumberFormat(1234.5678, "_________")#<br />
		#lsNumberFormat(1234.5678, "_________.___")#<br />
		#lsNumberFormat(1234.5678, "$_(_________.___)")#<br />
		#lsNumberFormat(-1234.5678, "$_(_________.___)")#<br />
		#lsNumberFormat(1234.5678, "+_________.___")#<br />
		#lsNumberFormat(1234.5678, "-_________.___")#<br />
	</cfoutput>
</cfloop>

```