<cffunction name="onRequestStart" output="false" returntype="void">
<cfif not isDefined("cookie.[cookiename]") OR #Left(cookie.[cookiename], "3")# EQ "{ts">   
    <!--- no cookie, or ts cookie --->
     <cfif action IS "login"> <!---  but they've submitted the form --->
 
       <cfif ( FindNoCase("dev", #SERVER_NAME#) EQ 0 )  >
 
         <cftry>
         <cf_idbauth ITAS_ID="#FORM.lan_id#" ITAS_PASSWORD="#FORM.pswd#"/>
              <cfcatch type="Any">
                <cfif CFCATCH.Type Is "Any">
                    Error occurred while checking login info!
                  </cfif>
                </cfcatch>
         </cftry>
      <cfelse>  <!--- dev server just log in --->
                  <cfset Variables.IDBAUTH_CODE = 1>
       </cfif>
 
      <cfif  ( (Variables.IDBAUTH_CODE EQ 1) OR (Variables.IDBAUTH_CODE EQ 0) ) >
 
          <cfquery name="GetPerson" datasource="staffadmin">
          SELECT     frst_name, last_name
          FROM  [insertuserdbtablename]
          WHERE [insert where clause as needed]
          </cfquery>
 
           <cfset email = "email=#FORM.lan_id#@[emaildomain]&firstname=#GetPerson.frst_name#&lastname=#GetPerson.last_name#">
 
           <cfset thekey = ToBase64("[insertkey]")>
           <cfset cookiestring = Encrypt(email, thekey, "DES", "Base64")>
        <CFHEADER name="Set-Cookie" value='[cookiename]=#cookiestring#;domain=[examplekey];path=/;expires='>
        <cflocation url="[ideascaledomainurl]" addtoken="false"> 
 
     <cfelse>  <!--- authentication failed, back to index page --->
                <cfset action="badlanid">
          <cfinclude template="index.cfm">               
                    
             <cfabort>
        </cfif>
 
<!--- no cookie, not logging in --->
 
     <cfelse>
        <cfinclude template="index.cfm">
         
          
             <cfabort>
        </cfif>
 
<!--- cookie exists --->
 
<cfelse>
 
  <cfif action IS "login"> <!---  but they've resubmitted the form --->
       <cfif ( FindNoCase("dev", #SERVER_NAME#) EQ 0 ) AND ( FindNoCase("acpt", #SERVER_NAME#) EQ 0 ) >
         <cftry>
              <cf_idbauth ITAS_ID="#FORM.lan_id#" ITAS_PASSWORD="#FORM.pswd#"/>
                 <cfcatch type="Any">
                     <cfif CFCATCH.Type Is "Any">
                         Error occurred while checking login info!
                      </cfif>
                   </cfcatch>
              </cftry>
       <cfelse>  <!--- dev just log in --->
                  <cfset Variables.IDBAUTH_CODE = 1>
       </cfif>
 
    <cfif  ( (Variables.IDBAUTH_CODE EQ 1) OR (Variables.IDBAUTH_CODE EQ 0) ) >
 
          <cfquery name="GetPerson" datasource="staffadmin">
            SELECT     frst_name, last_name
          FROM  [insertuserdbtablename]
          WHERE [insert where clause as needed]
          </cfquery>
 
        <cfset email = "email=#FORM.lan_id#@[domain]&firstname=#GetPerson.frst_name#&lastname=#GetPerson.last_name#">
           <cfset thekey = ToBase64("[insertkey]")>
           <cfset cookiestring = Encrypt(email, thekey, "DES", "Base64")>
        <cfcookie name = "[cookiename]" value = "#Now()#" expires = "NOW">
        <CFHEADER name="Set-Cookie" value='[cookiename]=#cookiestring#;domain=.[cookiename];path=/;expires='>
 
        <cflocation url="[ideascalecommunitydomain]" addtoken="false"> 
 
     <cfelse>  <!--- authentication failed, back to index page --->
 
                <cfset action="badlanid">
     <cfinclude template="index.cfm">
        
          
             <cfabort>
     </cfif>
</cfif>
 
     <cfif action IS "logout">
           <cfset message = "You have logged out">
           <cfset rc = structDelete(SESSION.auth, "isLoggedIn", "True")>
     <cfinclude template="index.cfm">
        
 
          <cfabort>
     </cfif>
 
</cfif>
 
</cffunction>