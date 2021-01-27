Write-Output "Welcome to python app init which uses poetry & pyenv"

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


Write-Output "`n***`n"
$Host.UI.RawUI.FlushInputBuffer()
$proj = Read-Host "Please enter a project name: "

poetry new $proj
Set-Location $proj
pyenv local $python_name
pyenv rehash

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
	$ans = Read-Host "Install older version of jedi for temporary ipython/jupyter incompatability?"
  if ( $response -eq 'y' )
  {
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

$Host.UI.RawUI.FlushInputBuffer()
$ans = Read-Host "Open VSCode?"
if ( $response -eq 'y' )
{
  code .
}
