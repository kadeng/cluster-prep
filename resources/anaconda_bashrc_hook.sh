#!/bin/bash
export CONDA_EXE="$HOME/anaconda3/bin/conda"
export _CE_M=''
export _CE_CONDA=''
export CONDA_PYTHON_EXE="$HOME/anaconda3/bin/python"

# In dev-mode CONDA_EXE is python.exe and on Windows
# it is in a different relative location to condabin.
if [ -n "${_CE_CONDA}" -a -n "${WINDIR-}" ]; then
    CONDA_ETC=$(\dirname "${CONDA_EXE}")/etc
else
    CONDA_ETC=$(\dirname "${CONDA_EXE}")
    CONDA_ETC=$(\dirname "${CONDA_ETC}")/etc
fi

# Load the POSIX setup
. $CONDA_ETC/profile.d/conda.sh

conda activate base

# Check for interactive bash with bash_completion setup
if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -n "${BASH_COMPLETION_VERSINFO-}" ]; then

    # Check for recent enough version of bash.
    if [ ${BASH_VERSINFO[0]} -gt 4 ] || \
       [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then

        . $CONDA_ETC/bash_completion.d/conda
    fi
fi