<#
Copyright 2023 SauceyRed

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

Param([string]$source, [string]$dest, [int]$retries, [string]$logDir)

switch ($source) {
	{ !$_ } {
		Write-Error "No source directory specified!"
		exit
	}
	{ !(Test-Path $source) } {
		Write-Error "Specified source directory not found!"
		exit
	}
}

switch ($dest) {
	{ !$_ } {
		Write-Error "No destination directory specified!"
		exit
	}
}

if (!$retries) {
	$retries = 10
	Write-Host "INFO: No retry amount specified, set to default value of 10."
}

if (!$logdir) {
	$logdir = "C:\logs\robocopy.log"
	Write-Host "INFO: No retry amount specified, set to default location at C:\logs\robocopy.log\"
}

Set-Location -Path $PSScriptRoot

$inputArgs = @($source, $dest, "/e", "/z", "/copyall", "/dcopy:DATE", "/r:$retries", "/v", "/eta", "/log:$logDir")

$robocopy = Get-Command "robocopy.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source

if (Test-Path $robocopy) {
	Write-Host "Command:" $robocopy $inputArgs
	Write-Host "Log location:" $logDir
	& $robocopy $inputArgs
} else {
	Write-Host "Robocopy not found."
}

# robocopy . .\..\output\ /e /z /copyall /dcopy:DATE /r:10 /v /eta /log:".\..\robocopy.log"
