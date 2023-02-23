If false (default), all supported Application settings, plus any other values defined in the Application.cfc constructor are returned.

			If true
			- Only Application settings for Lucee Core are returned
			- Any settings for Extensions may not be returned (TBD)
			- Any Application.cfc setting which has no effect on Lucee Core will be not returned

			Note
			- When false, settings defined using aliases are also returned under the default setting name (i.e settings may be duplicated)