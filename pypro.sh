#!/bin/bash

function clearInput {
	while read -t 0.01; do
    true
	done
}

echo "Welcome to python app init which uses poetry & pyenv"

echo $'\n***\n'
poetry --version
if [ $? -ne 0 ] 
then 	
	echo "Poetry command failed exiting"
	exit 1
fi

poetry config virtualenvs.in-project true

echo $'\n***\n'
echo "VSCode version is:"
code --version

echo $'\n***\n'
pyenv --version
if [ $? -ne 0 ] 
then 	
	echo "pyenv command failed exiting"
	exit 1
fi

echo $'\n***\n'
echo "Available pythons are:"
pyenv versions

if [ $? -ne 0 ] 
then 	
	echo "pyenv command failed exiting"
	exit 1
fi

echo $'\n***\n'
clearInput
read -p "Use current python version? (y/n):" response

if [ $response == 'y' ]
then
	echo "Using current python version"
	python_name=$(pyenv version-name)
elif [ $response == 'n' ]
then
	clearInput
	read -p "Please enter the python version to use: " response
	python_name=$response
else
	echo "Invalid option exiting..."
	exit -1
fi

echo "Using python version $python_name"

pyenv local $python_name
if [ $? -ne 0 ] 
then 	
	echo "pyenv command failed exiting"
	exit $?
fi

echo $'\n***\n'
clearInput
read -p "Please enter a project name: " proj

poetry new $proj;

cd $proj
pyenv local $python_name

clearInput
read -p "Install venv? (y/n)" response
if [ $response == 'y' ]
then
	echo "Installing poetry"
	poetry install
fi

clearInput
read -p "Install standard dev packages? (y/n) (ipython, black, flake8)" response
if [ $response == 'y' ]
then
	echo "Installing dev packages"
	poetry add --dev ipython black flake8 jupyter notebook
	clearInput
	read -p "Install older version of jedi for temporary ipython/jupyter incompatability?" response
	if [ $response == 'y' ]
	then
		poetry add --dev 'jedi=0.17.2'
	fi
fi

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
mkdir .vscode
mkdir .jupyter
cp $SCRIPTPATH/linux/vscode/settings.json .vscode/
cp $SCRIPTPATH/linux/vscode/tasks.json .vscode/
cp $SCRIPTPATH/linux/vscode/launch.json .vscode/
cp $SCRIPTPATH/linux/.gitignore ./

clearInput
read -p "Initialise git repo?" response
if [ $response == 'y' ]
then
	git init;
	cp ~/bin/vscode/.gitignore ./
fi

clearInput
read -p "Open VSCode?" response
if [ $response == 'y' ]
then
	echo "Opening VSCode"
	code .;
fi

echo "End"
