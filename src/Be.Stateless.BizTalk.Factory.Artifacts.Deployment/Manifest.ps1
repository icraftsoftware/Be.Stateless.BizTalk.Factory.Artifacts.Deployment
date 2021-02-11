#region Copyright & License

# Copyright © 2012 - 2021 François Chabot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.u
# See the License for the specific language governing permissions and
# limitations under the License.

#endregion

[CmdletBinding()]
[OutputType([hashtable])]
param(
   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $BizTalkAdministratorGroup = 'BizTalk Server Administrators',

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $BizTalkApplicationUserGroup = 'BizTalk Application Users',

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $BizTalkIsolatedHostUserGroup = 'BizTalk Isolated Host Users',

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $Domain = $env:COMPUTERNAME,

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $EnvironmentSettingOverridesType,

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $ManagementServer = $env:COMPUTERNAME,

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string]
   $ProcessingServer = $env:COMPUTERNAME,

   [Parameter(Mandatory = $false)]
   [ValidateNotNullOrEmpty()]
   [string[]]
   # TODO this is a global variable ; it should be bound to some resource
   $FileAdapterFolderUsers
)

Set-StrictMode -Version Latest

$SqlDatabaseVariables = @{
   BizTalkApplicationUserGroup     = "$Domain\$BizTalkApplicationUserGroup"
   BizTalkIsolatedHostUserGroup    = "$Domain\$BizTalkIsolatedHostUserGroup"
   BizTalkServerAdministratorGroup = "$Domain\$BizTalkAdministratorGroup"
}

ApplicationManifest -Name BizTalk.Factory -Description 'BizTalk.Factory''s BizTalk Server Artifacts.' -Build {
   Binding -Path (Get-ResourceItem -Name Be.Stateless.BizTalk.Factory.Binding) -EnvironmentSettingOverridesType $EnvironmentSettingOverridesType
   Component -Path (Get-ResourceItem -Name Be.Stateless.BizTalk.Pipeline.Components)
   Pipeline -Path (Get-ResourceItem -Name Be.Stateless.BizTalk.Pipelines)
   Schema -Path (Get-ResourceItem -Name Be.Stateless.BizTalk.Schemas)
   SqlDatabase -Path $PSScriptRoot\sql\scripts -Name BizTalkFactoryMgmtDb -EnlistInBizTalkBackupJob -Server $ManagementServer -Variables $SqlDatabaseVariables
   SqlDatabase -Path $PSScriptRoot\sql\scripts -Name BizTalkFactoryTransientStateDb -EnlistInBizTalkBackupJob -Server $ProcessingServer -Variables $SqlDatabaseVariables
   SsoConfigStore -Path (Get-ResourceItem -Name Be.Stateless.BizTalk.Factory.Binding) `
      -AdministratorGroups $BizTalkAdministratorGroup `
      -UserGroups $BizTalkApplicationUserGroup, $BizTalkIsolatedHostUserGroup `
      -EnvironmentSettingOverridesType $EnvironmentSettingOverridesType
}
