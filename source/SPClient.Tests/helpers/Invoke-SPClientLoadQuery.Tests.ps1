#Requires -Version 3.0

$testProjectDir = [String](Resolve-Path -Path ($MyInvocation.MyCommand.Path + '\..\..\'))
$targetProjectDir = $testProjectDir.Replace('.Tests\', '\')

Get-ChildItem -Path $targetProjectDir -Recurse `
    | Where-Object { -not $_.FullName.Contains('.Tests.') } `
    | Where-Object Extension -eq '.ps1' `
    | ForEach-Object { . $_.FullName }

$testConfig = [Xml](Get-Content "${testProjectDir}\TestConfiguration.xml")

$Script:SPClient = @{}

Describe 'Invoke-SPClientLoadQuery' {
    Context 'Loads ClientObject without Retrievals' {
        Add-SPClientType
        $clientContext = Connect-SPClientContext `
            -Url $testConfig.configuration.sharePointOnlineUrl `
            -Online `
            -UserName $testConfig.configuration.sharePointOnlineUserName `
            -Password (ConvertTo-SecureString -AsPlainText $testConfig.configuration.sharePointOnlinePassword -Force)
        $result = Invoke-SPClientLoadQuery `
            -ClientContext $clientContext `
            -ClientObject $clientContext.Web
        It 'Return value is null' {
            $result | Should Be $null
        }
    }
    Context 'Loads ClientObject with Retrievals' {
        Add-SPClientType
        $clientContext = Connect-SPClientContext `
            -Url $testConfig.configuration.sharePointOnlineUrl `
            -Online `
            -UserName $testConfig.configuration.sharePointOnlineUserName `
            -Password (ConvertTo-SecureString -AsPlainText $testConfig.configuration.sharePointOnlinePassword -Force)
        $result = Invoke-SPClientLoadQuery `
            -ClientContext $clientContext `
            -ClientObject $clientContext.Web `
            -Retrievals 'Id, RootFolder.ServerRelativeUrl'
        It 'Return value is null' {
            $result | Should Be $null
        }
    }
    Context 'Loads ClientObjectCollection without Retrievals' {
        Add-SPClientType
        $clientContext = Connect-SPClientContext `
            -Url $testConfig.configuration.sharePointOnlineUrl `
            -Online `
            -UserName $testConfig.configuration.sharePointOnlineUserName `
            -Password (ConvertTo-SecureString -AsPlainText $testConfig.configuration.sharePointOnlinePassword -Force)
        $result = Invoke-SPClientLoadQuery `
            -ClientContext $clientContext `
            -ClientObject $clientContext.Web.Lists
        It 'Return value is null' {
            $result | Should Be $null
        }
    }
    Context 'Loads ClientObjectCollection with Retrievals' {
        Add-SPClientType
        $clientContext = Connect-SPClientContext `
            -Url $testConfig.configuration.sharePointOnlineUrl `
            -Online `
            -UserName $testConfig.configuration.sharePointOnlineUserName `
            -Password (ConvertTo-SecureString -AsPlainText $testConfig.configuration.sharePointOnlinePassword -Force)
        $result = Invoke-SPClientLoadQuery `
            -ClientContext $clientContext `
            -ClientObject $clientContext.Web.Lists `
            -Retrievals 'Include(RootFolder.ServerRelativeUrl)'
        It 'Return value is null' {
            $result | Should Be $null
        }
    }
}
