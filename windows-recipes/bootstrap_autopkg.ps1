# $pyVersion is the Python version that will be downloaded
$pyVersion = "3.9.5"
# $pythonSavePath is place where the Python installer will be downloaded on disk
$pythonSavePath = "~\Downloads\python-$pyVersion-amd64.exe"
# $pythonInstallHash is the hash used to verify the Python installer download
$pythonInstallHash = "53a354a15baed952ea9519a7f4d87c3f"
# $pyEXEUrl is the url where the Python installer will be obtained
$pyEXEUrl = "https://www.python.org/ftp/python/$pyVersion/python-$pyVersion-amd64.exe"

# Download Python if needed
if ((Test-Path $pythonSavePath) -eq $False) {
    Write-Host "Downloading Python $pyVersion"
    curl $pyEXEUrl -UseBasicParsing -OutFile $pythonSavePath
} else {
    Write-Host "Python $pyVersion was already downloaded"
}

# Verify hash of Python installer
while ((Get-FileHash ($pythonSavePath) -Algorithm MD5).Hash -ne $pythonInstallHash) {
    Write-Host "Python hashes did not match. Removing and redownloading"
    rm $pythonSavePath
    curl $pyEXEUrl -UseBasicParsing -OutFile $pythonSavePath
}

& $pythonSavePath TargetDir=C:\Python39 Include_launcher=0 /passive

foreach ($dep in @("pyyaml", "appdirs")) {
    python -m pip install $dep
}
