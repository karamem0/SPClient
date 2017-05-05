﻿#Requires -Version 3.0

# Remove-SPClientList.ps1
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

function Remove-SPClientListItem {

<#
.SYNOPSIS
  Deletes a list item.
.PARAMETER ClientContext
  Indicates the client context.
  If not specified, uses the default context.
.PARAMETER ClientObject
  Indicates the list item to delete.
.PARAMETER ParentObject
  Indicates the list which the list item is contained.
.PARAMETER Identity
  Indicates the list item ID.
#>

    [CmdletBinding(DefaultParameterSetName = 'ClientObject')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'ClientObject')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Identity')]
        [Microsoft.SharePoint.Client.ClientContext]
        $ClientContext = $SPClient.ClientContext,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ClientObject')]
        [Microsoft.SharePoint.Client.ListItem]
        $ClientObject,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Identity')]
        [Microsoft.SharePoint.Client.List]
        $ParentObject,
        [Parameter(Mandatory = $true, ParameterSetName = 'Identity')]
        [Alias('Id')]
        [int]
        $Identity
    )

    process {
        if ($ClientContext -eq $null) {
            throw "Cannot bind argument to parameter 'ClientContext' because it is null."
        }
        if ($PSCmdlet.ParameterSetName -eq 'ClientObject') {
            if (-not $ClientObject.IsPropertyAvailable('Id')) {
                Invoke-SPClientLoadQuery `
                    -ClientContext $ClientContext `
                    -ClientObject $ClientObject
            }
        } else {
            if ($PSCmdlet.ParameterSetName -eq 'Identity') {
                $ClientObject = $ParentObject.GetItemById($Identity)
                Invoke-SPClientLoadQuery `
                    -ClientContext $ClientContext `
                    -ClientObject $ClientObject
            }
        }
        $ClientObject.DeleteObject()
        $ClientContext.ExecuteQuery()
    }

}
