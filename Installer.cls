Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="Namespace" Value="SC"/>
  <Default Name="database" Value="sc"/>
  <Default Name="app" Value="SC"/>
  
  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">

    <Configuration>
      <Database Name="${Namespace}" Dir="${mgrdir}${database}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"/>
  </Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status
{
  Set tSC=..setupMethod(.pVars)
  #; Let XGL document generate code for this method. 
  do ##class(%Library.EnsembleMgr).EnableNamespace("SC")
  do EnableDeepSee^%SYS.cspServer("/csp/sc/")

  Kill props
  Set webapp="/csp/sc"
  Set tSC = ##Class(Security.Applications).Get(webapp,.props)
  $$$ThrowOnError(tSC)
  Set props("DeepSeeEnabled")=1
  Set tSC = ##Class(Security.Applications).Modify(webapp,.props)
  $$$ThrowOnError(tSC)

  Set $NAMESPACE="SC"
  Do $SYSTEM.OBJ.LoadDir("/opt/irisbuild/src","ck",,1)

  Return $$$OK
}

ClassMethod setupMethod(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Return ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}
}