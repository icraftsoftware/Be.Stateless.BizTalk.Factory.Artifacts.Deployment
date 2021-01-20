param(
   [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
   [ValidateSet('DEV', 'BLD', 'ACC', 'PRD')]
   $TargetEnvironment
)

$prefix = 'Be.Stateless'

ApplicationManifest -Name 'BizTalk.Factory.Artifacts' -Description 'Artifacts for BizTalk Factory' -Build {
   Component -Path (Get-ResourceItem -Name "$prefix.BizTalk.Pipeline.Components", `
         "$prefix.BizTalk.Pipelines" `
   )
   Schema -Path (Get-ResourceItem -Name "$prefix.BizTalk.Schemas")
}