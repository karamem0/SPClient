#Requires -Version 3.0

. "$($PSScriptRoot)\..\..\TestInitialize.ps1"

Describe 'New-SPClientFieldMultilineText' {

    AfterEach {
        try {
            $Web = $SPClient.ClientContext.Site.OpenWebById($TestConfig.WebId)
            $List = $Web.Lists.GetById($TestConfig.ListId)
            $Field = $List.Fields.GetByInternalNameOrTitle('TestField0')
            $SPClient.ClientContext.Load($Field)
            $SPClient.ClientContext.ExecuteQuery()
            $Xml = [xml]$Field.SchemaXml
            $Xml.DocumentElement.SetAttribute('Hidden', 'FALSE')
            $Field.SchemaXml = $Xml.InnerXml
            $Field.DeleteObject()
            $SPClient.ClientContext.ExecuteQuery()
        } catch {
            Write-Host " [AfterEach] $($_)" -ForegroundColor Yellow 
        }
    }

    It 'Creates a new field with mandatory parameters' {
        $Web = Get-SPClientWeb -Identity $TestConfig.WebId
        $List = Get-SPClientList -ParentObject $Web -Identity $TestConfig.ListId
        $Params = @{
            ParentObject = $List
            Name = 'TestField0'
        }
        $Result = New-SPClientFieldMultilineText @Params
        $Result | Should Not BeNullOrEmpty
        $Result | Should BeOfType 'Microsoft.SharePoint.Client.FieldMultilineText'
        $Result.InternalName | Should Be 'TestField0'
        $Result.Id | Should Not BeNullOrEmpty
        $Result.Title | Should Be 'TestField0'
        $Result.Required | Should Be $false
        $Result.NumberOfLines | Should Be 6
        $Result.RichText | Should Be $false
    }

    It 'Creates a new field with all parameters' {
        $Web = Get-SPClientWeb -Identity $TestConfig.WebId
        $List = Get-SPClientList -ParentObject $Web -Identity $TestConfig.ListId
        $Params = @{
            ParentObject = $List
            Name = 'TestField0'
            Identity = '2F992681-3273-4C8C-BACD-8B7A9BBA0EE4'
            Title = 'Test Field 0'
            Description = 'Test Field 0'
            Required = $true
            NumberOfLines = 10
            RichText = $true
            AddToDefaultView = $true
        }
        $Result = New-SPClientFieldMultilineText @Params
        $Result | Should Not BeNullOrEmpty
        $Result | Should BeOfType 'Microsoft.SharePoint.Client.FieldMultilineText'
        $Result.InternalName | Should Be 'TestField0'
        $Result.Id | Should Be '2F992681-3273-4C8C-BACD-8B7A9BBA0EE4'
        $Result.Title | Should Be 'Test Field 0'
        $Result.Description | Should Be 'Test Field 0'
        $Result.Required | Should Be $true
        $Result.NumberOfLines | Should Be 10
        $Result.RichText | Should Be $true
    }

}
