# $pyVersion is the Python version that will be downloaded
$pyVersion = "3.9.5"
# $pythonSavePath is place where the Python installer will be downloaded on disk
$pythonSavePath = "~\Downloads\python-$pyVersion-amd64.exe"
# $pythonInstallHash is the hash used to verify the Python installer download
$pythonInstallHash = "53a354a15baed952ea9519a7f4d87c3f"
# $pyEXEUrl is the url where the Python installer will be obtained
$pyEXEUrl = "https://www.python.org/ftp/python/$pyVersion/python-$pyVersion-amd64.exe"

$gitGitTag = "v2.33.0.windows.2"
$gitURL = "https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"

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



