### VSCODE DEFAULT ENCODING WILL MISINTERPRET $expectedGitPublisher
### Switch encoding for this file to Windows 1252 if needed

# $pyVersion is the Python version that will be downloaded
$pyVersion = "3.9.5"
# $pythonSavePath is place where the Python installer will be downloaded on disk
$pythonSavePath = "~\Downloads\python-$pyVersion-amd64.exe"
# $pythonInstallHash is the hash used to verify the Python installer download
$pythonInstallHash = "53a354a15baed952ea9519a7f4d87c3f"
# $pyEXEUrl is the url where the Python installer will be obtained
$pyEXEUrl = "https://www.python.org/ftp/python/$pyVersion/python-$pyVersion-amd64.exe"

$gitSavePath = "~/Downloads/gitInstaller.exe"
$expectedGitPublisher = "CN=Johannes Schindelin, O=Johannes Schindelin, L=Köln, S=North Rhine-Westphalia, C=DE"

$gitwin64 = ""
if ((Test-Path $gitSavePath) -eq $False) {
    $gitlatestRelease = (curl https://github.com/git-for-windows/git/releases/latest -UseBasicParsing).Links
    foreach ($link in $gitlatestRelease) {
        if($link -Match ".*/git-for-windows/git/releases/download/.*-64-bit.exe.*") {
            $gitwin64 = ($link | Out-String).Substring(25, 80)
            Write-Host "Found latest win64 at $gitwin64"
            break
        }
    }
    curl "https://github.com/$gitWin64" -UseBasicParsing -OutFile $gitSavePath
}

$gitPublisher = (Get-AuthenticodeSignature "$gitSavePath").SignerCertificate.Subject
if ($gitPublisher -ne $expectedGitPublisher) {
    Write-Host "Git was signed by $gitPublisher but we expected $expectedGitPublisher"
    Write-Host "exiting"
    exit(1)
} else {
    Write-Host "Git was signed by $expectedGitPublisher as expected"
}

# install git: https://github.com/git-for-windows/git/wiki/Silent-or-Unattended-Installation

$gitInstallArgs = "/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS='icons,ext\reg\shellhere,assoc,assoc_sh'"
Write-Host "Installing $gitwin64"
Start-Process -FilePath "$gitSavePath" -ArgumentList $gitInstallArgs -Wait

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

Start-Process -FilePath "$pythonSavePath" -ArgumentList "TargetDir=C:\Python39 Include_launcher=0 /passive" -Wait
Write-Host "Installing Python if not already installed"

$deps = @(
    "pyyaml",
    "appdirs",
    "certifi"
)
foreach ($dep in $deps) {
    Write-Host "Installing $dep"
    C:\Python39\python -m pip install $dep
}

# git clone autopkg

$prefs = @"
{
    "CACHE_DIR": "C:\\autopkg\\cache",
    "RECIPE_SEARCH_DIRS": "C:\\autopkg\\Recipes",
    "RECIPE_OVERRIDE_DIRS": "C:\\autopkg\\RecipeOverrides",
    "RECIPE_REPO_DIR": "C:\\autopkg\\RecipeRepos"
}
"@

if (!(Test-Path c:\autopkg)) {
    Write-Host "Creating c:\autopkg"
    New-Item -ItemType Directory -Path c:\autopkg
} else {
    Write-Host "Skipping creation of c:\autopkg because it already exists"
}

if (!(Test-Path c:\autopkg\config.json)) {
    $prefs | Out-File -FilePath "c:\autopkg\config.json" -Force -Encoding ascii
    Write-Host "Wrote c:\autopkg\config.json"
} else {
    Write-Host "c:\autopkg\config.json already exists, not overwriting"
}



