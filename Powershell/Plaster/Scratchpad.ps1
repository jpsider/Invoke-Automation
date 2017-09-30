$plaster = @{
    TemplatePath = (Split-Path "C:\temp\PlasterStuff\FullModuleTemplate\PlasterManifest.xml")
    DestinationPath = "c:\temp\PlasterStuff\PowerLumber"
}
Invoke-Plaster @plaster -Verbose