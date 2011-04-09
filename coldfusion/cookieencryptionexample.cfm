<cffunction name="onRequestStart" output="false" returntype="void">
<cfif not isDefined("cookie.NSFIDEA") OR #Left(cookie.NSFIDEA, "3")# EQ "{ts">   
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
          FROM  nsfs.pers
          WHERE lan_id = '#FORM.lan_id#'
          </cfquery>
 
           <cfset email = "email=#FORM.lan_id#@nsf.gov&firstname=#GetPerson.frst_name#&lastname=#GetPerson.last_name#">
 
           <cfset thekey = ToBase64("81625091")>
           <cfset cookiestring = Encrypt(email, thekey, "DES", "Base64")>
        <CFHEADER name="Set-Cookie" value='NSFIDEA=#cookiestring#;domain=.nsf.gov;path=/;expires='>
        <cflocation url="http://ideashare.nsf.gov" addtoken="false"> 
 
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
            SELECT   frst_name, last_name
            FROM     nsfs.pers
            WHERE    lan_id = '#FORM.lan_id#'
          </cfquery>
 
        <cfset email = "email=#FORM.lan_id#@nsf.gov&firstname=#GetPerson.frst_name#&lastname=#GetPerson.last_name#">
           <cfset thekey = ToBase64("81625091")>
           <cfset cookiestring = Encrypt(email, thekey, "DES", "Base64")>
        <cfcookie name = "NSFIDEA" value = "#Now()#" expires = "NOW">
        <CFHEADER name="Set-Cookie" value='NSFIDEA=#cookiestring#;domain=.nsf.gov;path=/;expires='>
 
        <cflocation url="http://ideashare.nsf.gov" addtoken="false"> 
 
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