Function Get-RedirectedUrl
{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )
 
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

$url = "https://go.microsoft.com/fwlink/?LinkID=799012"
$codeSetupUrl = Get-RedirectedUrl -URL $url

$infPath = $PSScriptRoot + "\sql.inf"
$sqlcodeSetup = "${env:Temp}\SQLServer2016-SSEI-Expr.exe"

try
{
    (New-Object System.Net.WebClient).DownloadFile($codeSetupUrl, $sqlcodeSetup)
}
catch
{
    Write-Error "Failed to download sql setup"
}

try
{
    Start-Process -FilePath $sqlcodeSetup -ArgumentList "/VERYSILENT /MERGETASKS=!runcode /LOADINF=$infPath"
}
catch
{
    Write-Error 'Failed to install sql server'
}