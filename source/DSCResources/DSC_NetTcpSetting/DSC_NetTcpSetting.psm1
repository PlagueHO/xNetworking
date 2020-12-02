$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'

# Import the Networking Common Modules
Import-Module -Name (Join-Path -Path $modulePath `
        -ChildPath (Join-Path -Path 'NetworkingDsc.Common' `
            -ChildPath 'NetworkingDsc.Common.psm1'))

Import-Module -Name (Join-Path -Path $modulePath -ChildPath 'DscResource.Common')

# Import Localization Strings
$script:localizedData = Get-LocalizedData -DefaultUICulture 'en-US'

<#
    This is an array of all the parameters used by this resource.
#>
$resourceData = Import-LocalizedData `
    -BaseDirectory $PSScriptRoot `
    -FileName 'DSC_NetTcpSetting.data.psd1'

# This must be a script parameter so that it is accessible
$script:parameterList = $resourceData.ParameterList

<#
    .SYNOPSIS
        Returns the current TCP Settings.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.
#>
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance
    )

    Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($script:localizedData.GettingNetTcpSettingMessage)
        ) -join '' )

    # Get the current TCP Settings
    $currentNetTcpSetting = Get-NetTcpSetting `
        -ErrorAction Stop

    # Generate the return object.
    $returnValue = @{
        IsSingleInstance = 'Yes'
    }

    foreach ($parameter in $script:parameterList)
    {
        $returnValue += @{
            $parameter.Name = $currentNetTcpSetting.$($parameter.name)
        }
    } # foreach

    return $returnValue
} # Get-TargetResource

<#
    .SYNOPSIS
        Sets the TCP Settings.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER SettingsName
        Specifies the name of the custom settings to configure.

    .PARAMETER MinRtoMs
        Specifies a value, in milliseconds, for the TCP retransmission to time out.
        The acceptable values for this parameter are: increments of 10, from 20 ms
        through 300 ms.

    .PARAMETER InitialCongestionWindowMss
        Specifies the initial size of the congestion window. Provide a value to multiply
        by the maximum segment size (MSS). The acceptable values for this parameter
        are: even numbers from 2 through 64.

    .PARAMETER CongestionProvider
        Specifies the congestion provider property that TCP uses.

    .PARAMETER CwndRestart
        Specifies whether to enable congestion window restart. Congestion window restart
        can avoid slow start to optimize throughput on low latency networks.

    .PARAMETER DelayedAckTimeoutMs
        Specifies the time to wait, in milliseconds, before the computer sends an ACK
        if the computer receives fewer than delayed acknowledgment frequency of packets.

    .PARAMETER DelayedAckFrequency
        Specifies the number of acknowledgments (ACKs) received before the computer
        sends a response.

    .PARAMETER MemoryPressureProtection
        Specifies whether to use memory pressure protection. TCP memory pressure
        protection helps ensure that a computer continues normal operation when low
        on memory due to denial of service attacks.

    .PARAMETER AutoTuningLevelLocal
        Specifies a TCP auto-tuning level for the host computer. TCP auto-tuning
        can improve throughput on high throughput, high latency networks.

    .PARAMETER EcnCapability
        Specifies whether to enable ECN capability.

    .PARAMETER Timestamps
        Specifies whether to enable timestamps. Timestamps facilitate round trip
        measurement, and can help protect against wrapped sequence numbers on high
        throughput links.

    .PARAMETER InitialRtoMs
        Specifies the period, in milliseconds, before connect, or SYN, retransmit. The
        acceptable values for this parameter are: increments of 10, from 300 ms through
        3000 ms.

    .PARAMETER ScalingHeuristics
        Specifies whether to enable scaling heuristics.

    .PARAMETER DynamicPortRangeStartPort
        Specifies the starting port for the dynamic port range. This parameter sets
        the starting port to send and receive TCP traffic. The acceptable values
        for this parameter are: 1 through 65535.

    .PARAMETER DynamicPortRangeStartPort
        Specifies the number of ports for the dynamic port range that starts from the
        port that you specify for the DynamicPortRangeStartPort parameter.

    .PARAMETER AutomaticUseCustom
        Specifies whether the automatic profile assigns a custom template, either
        Datacenter Custom or Internet Custom, to a connection.

    .PARAMETER NonSackRttResiliency
        Specifies whether to enable round trip time resiliency for clients that do not
        support selective acknowledgment.

    .PARAMETER ForceWS
        Specifies whether to force window scaling for retransmission.

    .PARAMETER MaxSynRetransmissions
        Specifies the maximum number of times the computer sends SYN packets without
        receiving a response.

    .PARAMETER AutoReusePortRangeStartPort
        Specifies the starting port for the auto-reuse port range, which is a port range
        used for local ephemeral port selection by outbound TCP connections for which
        either SO_REUSE_UNICASTPORT has been set on the socket, or for which connect()
        has been called without calling bind() on the socket.

    .PARAMETER AutoReusePortRangeNumberOfPorts
        Specifies the number of ports for the auto-reuse port range, which is a port
        range used for local ephemeral port selection by outbound TCP connections for
        which either SO_REUSE_UNICASTPORT has been set on the socket, or for which
        connect() has been called without calling bind() on the socket.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [ValidateSet('InternetCustom', 'DatacenterCustom')]
        [System.String]
        $SettingsName,

        [Parameter()]
        [System.Uint32]
        $MinRtoMs,

        [Parameter()]
        [System.Uint32]
        $InitialCongestionWindowMss,

        [Parameter()]
        [System.String]
        $CongestionProvider,

        [Parameter()]
        [System.String]
        $CwndRestart,

        [Parameter()]
        [System.Uint32]
        $DelayedAckTimeoutMs,

        [Parameter()]
        [System.Byte]
        $DelayedAckFrequency,

        [Parameter()]
        [System.String]
        $MemoryPressureProtection,

        [Parameter()]
        [System.String]
        $AutoTuningLevelLocal,

        [Parameter()]
        [System.String]
        $EcnCapability,

        [Parameter()]
        [System.String]
        $Timestamps,

        [Parameter()]
        [System.Uint32]
        $InitialRtoMs,

        [Parameter()]
        [System.String]
        $ScalingHeuristics,

        [Parameter()]
        [System.Uint16]
        $DynamicPortRangeStartPort,

        [Parameter()]
        [System.Uint16]
        $DynamicPortRangeNumberOfPorts,

        [Parameter()]
        [System.String]
        $AutomaticUseCustom,

        [Parameter()]
        [System.String]
        $NonSackRttResiliency,

        [Parameter()]
        [System.String]
        $ForceWS,

        [Parameter()]
        [System.Byte]
        $MaxSynRetransmissions,

        [Parameter()]
        [System.Uint16]
        $AutoReusePortRangeStartPort,

        [Parameter()]
        [System.Uint16]
        $AutoReusePortRangeNumberOfPorts
    )

    Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($script:localizedData.SettingNetTcpSettingMessage)
        ) -join '' )

    # Get the current Dns Client Global Settings
    $currentNetTcpSetting = Get-NetTcpSetting `
        -ErrorAction Stop

    # Generate a list of parameters that will need to be changed.
    $changeParameters = @{}

    foreach ($parameter in $script:parameterList)
    {
        $parameterSourceValue = $currentNetTcpSetting.$($parameter.name)
        $parameterNewValue = (Get-Variable -Name ($parameter.name)).Value

        if ($PSBoundParameters.ContainsKey($parameter.Name) `
                -and (Compare-Object -ReferenceObject $parameterSourceValue -DifferenceObject $parameterNewValue -SyncWindow 0))
        {
            $changeParameters += @{
                $($parameter.name) = $parameterNewValue
            }

            Write-Verbose -Message ( @(
                    "$($MyInvocation.MyCommand): "
                    $($script:localizedData.NetTcpSettingUpdateParameterMessage) `
                        -f $parameter.Name,($parameterNewValue -join ',')
                ) -join '' )
        } # if
    } # foreach

    if ($changeParameters.Count -gt 0)
    {
        # Update any parameters that were identified as different
        $null = Set-NetTcpSetting `
            @ChangeParameters `
            -ErrorAction Stop

        Write-Verbose -Message ( @(
                "$($MyInvocation.MyCommand): "
                $($script:localizedData.NetTcpSettingUpdatedMessage)
            ) -join '' )
    } # if
} # Set-TargetResource

<#
    .SYNOPSIS
        Tests the state of TCP Settings.

    .PARAMETER IsSingleInstance
        Specifies the resource is a single instance, the value must be 'Yes'.

    .PARAMETER SettingsName
        Specifies the name of the custom settings to configure.

    .PARAMETER MinRtoMs
        Specifies a value, in milliseconds, for the TCP retransmission to time out.
        The acceptable values for this parameter are: increments of 10, from 20 ms
        through 300 ms.

    .PARAMETER InitialCongestionWindowMss
        Specifies the initial size of the congestion window. Provide a value to multiply
        by the maximum segment size (MSS). The acceptable values for this parameter
        are: even numbers from 2 through 64.

    .PARAMETER CongestionProvider
        Specifies the congestion provider property that TCP uses.

    .PARAMETER CwndRestart
        Specifies whether to enable congestion window restart. Congestion window restart
        can avoid slow start to optimize throughput on low latency networks.

    .PARAMETER DelayedAckTimeoutMs
        Specifies the time to wait, in milliseconds, before the computer sends an ACK
        if the computer receives fewer than delayed acknowledgment frequency of packets.

    .PARAMETER DelayedAckFrequency
        Specifies the number of acknowledgments (ACKs) received before the computer
        sends a response.

    .PARAMETER MemoryPressureProtection
        Specifies whether to use memory pressure protection. TCP memory pressure
        protection helps ensure that a computer continues normal operation when low
        on memory due to denial of service attacks.

    .PARAMETER AutoTuningLevelLocal
        Specifies a TCP auto-tuning level for the host computer. TCP auto-tuning
        can improve throughput on high throughput, high latency networks.

    .PARAMETER EcnCapability
        Specifies whether to enable ECN capability.

    .PARAMETER Timestamps
        Specifies whether to enable timestamps. Timestamps facilitate round trip
        measurement, and can help protect against wrapped sequence numbers on high
        throughput links.

    .PARAMETER InitialRtoMs
        Specifies the period, in milliseconds, before connect, or SYN, retransmit. The
        acceptable values for this parameter are: increments of 10, from 300 ms through
        3000 ms.

    .PARAMETER ScalingHeuristics
        Specifies whether to enable scaling heuristics.

    .PARAMETER DynamicPortRangeStartPort
        Specifies the starting port for the dynamic port range. This parameter sets
        the starting port to send and receive TCP traffic. The acceptable values
        for this parameter are: 1 through 65535.

    .PARAMETER DynamicPortRangeStartPort
        Specifies the number of ports for the dynamic port range that starts from the
        port that you specify for the DynamicPortRangeStartPort parameter.

    .PARAMETER AutomaticUseCustom
        Specifies whether the automatic profile assigns a custom template, either
        Datacenter Custom or Internet Custom, to a connection.

    .PARAMETER NonSackRttResiliency
        Specifies whether to enable round trip time resiliency for clients that do not
        support selective acknowledgment.

    .PARAMETER ForceWS
        Specifies whether to force window scaling for retransmission.

    .PARAMETER MaxSynRetransmissions
        Specifies the maximum number of times the computer sends SYN packets without
        receiving a response.

    .PARAMETER AutoReusePortRangeStartPort
        Specifies the starting port for the auto-reuse port range, which is a port range
        used for local ephemeral port selection by outbound TCP connections for which
        either SO_REUSE_UNICASTPORT has been set on the socket, or for which connect()
        has been called without calling bind() on the socket.

    .PARAMETER AutoReusePortRangeNumberOfPorts
        Specifies the number of ports for the auto-reuse port range, which is a port
        range used for local ephemeral port selection by outbound TCP connections for
        which either SO_REUSE_UNICASTPORT has been set on the socket, or for which
        connect() has been called without calling bind() on the socket.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [ValidateSet('InternetCustom', 'DatacenterCustom')]
        [System.String]
        $SettingsName,

        [Parameter()]
        [System.Uint32]
        $MinRtoMs,

        [Parameter()]
        [System.Uint32]
        $InitialCongestionWindowMss,

        [Parameter()]
        [System.String]
        $CongestionProvider,

        [Parameter()]
        [System.String]
        $CwndRestart,

        [Parameter()]
        [System.Uint32]
        $DelayedAckTimeoutMs,

        [Parameter()]
        [System.Byte]
        $DelayedAckFrequency,

        [Parameter()]
        [System.String]
        $MemoryPressureProtection,

        [Parameter()]
        [System.String]
        $AutoTuningLevelLocal,

        [Parameter()]
        [System.String]
        $EcnCapability,

        [Parameter()]
        [System.String]
        $Timestamps,

        [Parameter()]
        [System.Uint32]
        $InitialRtoMs,

        [Parameter()]
        [System.String]
        $ScalingHeuristics,

        [Parameter()]
        [System.Uint16]
        $DynamicPortRangeStartPort,

        [Parameter()]
        [System.Uint16]
        $DynamicPortRangeNumberOfPorts,

        [Parameter()]
        [System.String]
        $AutomaticUseCustom,

        [Parameter()]
        [System.String]
        $NonSackRttResiliency,

        [Parameter()]
        [System.String]
        $ForceWS,

        [Parameter()]
        [System.Byte]
        $MaxSynRetransmissions,

        [Parameter()]
        [System.Uint16]
        $AutoReusePortRangeStartPort,

        [Parameter()]
        [System.Uint16]
        $AutoReusePortRangeNumberOfPorts
    )

    Write-Verbose -Message ( @(
            "$($MyInvocation.MyCommand): "
            $($script:localizedData.TestingNetTcpSettingMessage)
        ) -join '' )

    # Flag to signal whether settings are correct
    $desiredConfigurationMatch = $true

    # Get the current TCP Settings
    $currentNetTcpSetting = Get-NetTcpSetting `
        -ErrorAction Stop

    # Check each parameter
    foreach ($parameter in $script:parameterList)
    {
        $parameterSourceValue = $currentNetTcpSetting.$($parameter.name)
        $parameterNewValue = (Get-Variable -Name ($parameter.name)).Value
        $parameterValueMatch = $true

        # Perform a plain integer comparison.
        if ($PSBoundParameters.ContainsKey($parameter.Name) -and $parameterSourceValue -ne $parameterNewValue)
        {
            $parameterValueMatch = $false
        }

        if ($parameterValueMatch -eq $false)
        {
            Write-Verbose -Message ( @( "$($MyInvocation.MyCommand): "
                    $($script:localizedData.NetTcpSettingParameterNeedsUpdateMessage) `
                        -f $parameter.Name, ($parameterSourceValue -join ','), ($parameterNewValue -join ',')
                ) -join '')
            $desiredConfigurationMatch = $false
        }
    } # foreach

    return $desiredConfigurationMatch
} # Test-TargetResource

Export-ModuleMember -Function *-TargetResource
