Function Test-CommandExists
{

 Param ($command)

 $oldPreference = $ErrorActionPreference

 $ErrorActionPreference = "stop"

 try {if(Get-Command $command){RETURN $true}}

 Catch {Write-Host “$command does not exist”; RETURN $false}

 Finally {$ErrorActionPreference=$oldPreference}

} #end function test-CommandExists

Write-Output "Welcome to python app init which uses poetry & pyenv"


if (-Not (Test-CommandExists poetry) )
{
  Write-Output "Please install poetry for this script to work"
  exit 1
}

$codeInstalled = Test-CommandExists code
if (-Not $codeInstalled )
{
  Write-Output "Warning VSCode is not installed or could not be found on the path"
}

$pyenvInstalled = Test-CommandExists pyenv
$pythonInstalled = Test-CommandExists python
if ((-Not $pyenvInstalled) -and (-Not $pythonInstalled)) {
  Write-Output "Warning pyenv and python is not installed"
  exit 1
}
elseif (-Not $pyenvInstalled) {
  Write-Output "Warning pyenv is not installed or could not be found on path"
}
else {
  $Host.UI.RawUI.FlushInputBuffer()
  $ans = Read-Host "Do you want to use pyenv?"
  if ($ans -eq 'n') {
    $pyenvInstalled = 0
  }
}

Write-Output "`n***`n"
$poetryV = poetry --version
if ( $LASTEXITCODE -ne 0 ) 
{
  Write-Output "poetry command failed"
  exit $LASTEXITCODE
}
Write-Output $poetryV
poetry config virtualenvs.in-project true

Write-Output "`n***`n"
$vscodeV = code --version
if ( $LASTEXITCODE -ne 0 ) 
{
  Write-Output "VSCode command failed"
  exit $LASTEXITCODE
}
Write-Output "VSCode version:"
Write-Output $vscodeV

Write-Output "`n***`n"
if ($pyenvInstalled)
{
  $vscodeV = pyenv --version
  if ( $LASTEXITCODE -ne 0 ) 
  {
    Write-Output "Pyenv command failed"
    exit $LASTEXITCODE
  }
  Write-Output "Pyenv version:"
  Write-Output $vscodeV

  $vscodeV = pyenv versions
  if ( $LASTEXITCODE -ne 0 ) 
  {
    Write-Output "Pyenv command failed"
    exit $LASTEXITCODE
  }
  Write-Output "Pyenv versions available:"
  Write-Output $vscodeV

  Write-Output "`n***`n"
  $Host.UI.RawUI.FlushInputBuffer()
  $ans = Read-Host "Use current python version? [y/n]"
  $python_name = pyenv vname
  if ($ans -eq 'y')
  {
  # Pass
  }
  elseif ($ans -eq 'n')
  {
    $Host.UI.RawUI.FlushInputBuffer()
    $ans = Read-Host "Please enter a python version to use: "
    $python_name = $ans
  }
  else 
  {
    Write-Output "Invalid option"
    exit 1
  }

  pyenv rehash
  Write-Output "Using python version $python_name"

  pyenv local $python_name
  if ( $LASTEXITCODE -ne 0 ) 
  {
    Write-Output "Pyenv command failed"
    exit $LASTEXITCODE
  }
}
else {
  # No pyenv
  Write-Output "Current python version is $(python -V)"
  Write-Output "Current python path is $(where.exe python)"
  $currentPython = "python"
  $Host.UI.RawUI.FlushInputBuffer()
  $ans = Read-Host "Use this python version?"
  if ($ans -eq 'y') {
    # Pass
  }
  else {
    $Host.UI.RawUI.FlushInputBuffer()
    $currentPython = Read-Host "Please type in the python executable to use (or full path to python if not in path)"
  }
}

Write-Output "`n***`n"
$Host.UI.RawUI.FlushInputBuffer()
$proj = Read-Host "Please enter a project name: "

$Host.UI.RawUI.FlushInputBuffer()
$ans = Read-Host "Please select an option`nUse standard poetry module structure? [y] Or define do you want to define it yourself later? [n] : "
if ($ans -eq 'y') {
  poetry new $proj
  Set-Location $proj
}
elseif($ans -eq 'n') {
  mkdir $proj
  Set-Location $proj
  poetry init -n
}
else {
  Write-Output "Unknown option"
  exit 1
}

$didPythonPathGetSetCorrectly = 1
if ($pyenvInstalled) {
  pyenv local $python_name
  pyenv rehash
}
else {
  poetry env use $currentPython
}

if ($LASTEXITCODE -ne 0) {
  Write-Output "Warning: problem setting poetry python environment"
  $didPythonPathGetSetCorrectly = 0
}

$Host.UI.RawUI.FlushInputBuffer()
$ans = Read-Host "Install venv? [y/n]"
if ($ans -eq 'y')
{
  poetry install
}

Write-Output "Installing libraries can take some time..."
$Host.UI.RawUI.FlushInputBuffer()
$ans = Read-Host "Install standard dev packages? (y/n) (ipython, black, flake8)"
if ( $ans -eq 'y' )
{
	poetry add --dev ipython black flake8 jupyter notebook
  $Host.UI.RawUI.FlushInputBuffer()
  Write-Output "There is a bug with the latest version of ipython with tab complete https://github.com/ipython/ipython/issues/12740"
	$ans = Read-Host "Install older version of jedi for temporary compatability?"
  if ( $ans -eq 'y' )
  {
    Write-Output "Updating jedi"
    poetry add --dev 'jedi=0.17.2'
  }
}

mkdir .vscode
mkdir .jupyter
Copy-Item $PSScriptRoot/win/vscode/settings.json .vscode/
Copy-Item $PSScriptRoot/win/vscode/tasks.json .vscode/
Copy-Item $PSScriptRoot/win/vscode/launch.json .vscode/
Copy-Item $PSScriptRoot/win/.gitignore ./

$Host.UI.RawUI.FlushInputBuffer()
$ans = Read-Host "Initialise git repo?"
if ( $ans -eq 'y' )
{
	git init;
}

Write-Output "You can open this folder is vscode or 'code .'"

if ($didPythonPathGetSetCorrectly -eq 0) {
  Write-Output "error setting poetry python executable, you can try `npoetry env use python_exe"
}