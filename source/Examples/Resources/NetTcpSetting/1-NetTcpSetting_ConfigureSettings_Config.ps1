<#PSScriptInfo
.VERSION 1.0.0
.GUID 4b5a837e-fa0b-4630-9321-ee8618c974c1
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT Copyright the DSC Community contributors. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/dsccommunity/NetworkingDsc/blob/master/LICENSE
.PROJECTURI https://github.com/dsccommunity/NetworkingDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module NetworkingDsc

<#
    .DESCRIPTION
    Configure only contoso.com for the DNS Suffix.
#>
Configuration NetTcpSetting_ConfigureSettings_Config
{
    Import-DscResource -Module NetworkingDsc

    Node localhost
    {
        NetTcpSettings ConfigureTcpSettings
        {
            IsSingleInstance = 'Yes'
            SettingName = 'Internet'
            MinRtoMs = 300
            InitialCongestionWindowMss
            CongestionProvider
            CwndRestart
            DelayedAckTimeoutMs
            DelayedAckFrequency
            MemoryPressureProtection
        }
    }
}
