# pypro

pypro is a simple python project maker script which uses poetry & pyenv to setup your own customizable dev environment.

## Prerequisites
* poetry
* pyenv - with the python version that you want to use
* Linux or Windows (with powershell) OS

## Getting started

Download the repository
```bash
git clone https://github.com/djplt/pypro.git
```

You also need to add the scripts to your path

### Windows
1. Adding the script to your path
* Open "edit environment variables"
* Add the root of this repo to your "PATH" variable
2. Setting the execution policy on the script 
* Right click the file "pypro.ps1" and select properties
* On the General tab, under Security, click the Unblock checkbox.
* Click OK.

Restart your cmd window.

### Linux
1. Adding the script to your path
Adding in your repo directory name
  ```bash
  echo 'export PATH="$PATH:REPO_ROOT_DIRECTORY' >> ~/.bashrc
  ```
2. Setting the execution policy on the script
```bash
chmod +x ./pypro.sh
```

Restart your cmd window.

## Usage

Navigate in your cmd prompt to where you want to build your python project
```bash
pypro
```

The script will then walk you through setting up your project

### Adding modules

For libraries used in your code
```bash
poetry add numpy
```

For libraries used for developing your code (e.g linters)
```bash
poetry add --dev black
```

See poetry for more info.

### VSCode
Open the created folder in VSCode.

Run Task (Terminal->Run Task) Run Jupyter to start a jupyter server to play around in your virtual environment

Open the terminal with Ctrl+' should open the terminal with your virtual environment

Ctrl+<F5> to execute (either current file or whole module)

## Improvements

* Give option for user to setup python virtual environment without using pyenv


## License
[MIT](https://choosealicense.com/licenses/mit/)