﻿#Requires -Version 3.0

# New-SPClientWeb.ps1
#
# Copyright (c) 2017 karamem0
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function New-SPClientWeb {

<#
.SYNOPSIS
  Creates a new web.
.PARAMETER ClientContext
  Indicates the client context.
  If not specified, uses the default context.
.PARAMETER ParentObject
  Indicates the web which a web to be created.
  If not specified, uses the default web.
.PARAMETER Url
  Indicates the url.
.PARAMETER Title
  Indicates the title.
  If not specified, uses default title of the web template.
.PARAMETER Description
  Indicates the description.
.PARAMETER Language
  Indicates the locale ID in which the language is used.
  If not specified, uses the parent web language.
.PARAMETER Template
  Indicates the template name.
.PARAMETER UniquePermissions
  If specified, the web uses unique permissions.
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Microsoft.SharePoint.Client.ClientContext]
        $ClientContext = $SPClient.ClientContext,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Microsoft.SharePoint.Client.Web]
        $ParentObject = $SPClient.ClientContext.Web,
        [Parameter(Mandatory = $true)]
        [string]
        $Url,
        [Parameter(Mandatory = $false)]
        [string]
        $Title,
        [Parameter(Mandatory = $false)]
        [string]
        $Description,
        [Parameter(Mandatory = $false)]
        [string]
        $Language,
        [Parameter(Mandatory = $false)]
        [string]
        $Template,
        [Parameter(Mandatory = $false)]
        [switch]
        $UniquePermissions
    )

    process {
        if ($ClientContext -eq $null) {
            throw "Cannot bind argument to parameter 'ClientContext' because it is null."
        }
        if ($ParentObject -eq $null) {
            throw "Cannot bind argument to parameter 'ParentObject' because it is null."
        }
        $Creation = New-Object Microsoft.SharePoint.Client.WebCreationInformation
        $Creation.Url = $Url
        $Creation.Language = $Language
        $Creation.WebTemplate = $Template
        $Creation.Title = $Title
        $Creation.Description = $Description
        $Creation.UseSamePermissionsAsParentSite = -not $UniquePermissions
        $ClientObject = $ParentObject.Webs.Add($Creation)
        Invoke-SPClientLoadQuery `
            -ClientContext $ClientContext `
            -ClientObject $ClientObject
        Write-Output $ClientObject
    }

}
