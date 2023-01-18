#!/bin/bash

export WORK_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "$WORK_ROOT"
export DISPLAY=localhost:0.0

PROGRAMS_ROOT=$WORK_ROOT/programs

if [[ $(uname) == Linux* ]];then
  PROGRAMS_ROOT=$PROGRAMS_ROOT/nix
  echo "Running on nix-like environment will use programs in $PROGRAMS_ROOT";
fi

export PROGRAMS_ROOT

export JAVA_HOME=$PROGRAMS_ROOT/java/current/
export NODE=$PROGRAMS_ROOT/nodejs/current/
export PYTHONPATH=$PROGRAMS_ROOT/python/current
export M2_HOME=$PROGRAMS_ROOT/maven/current
export GRADLE_HOME=$PROGRAMS_ROOT/gradle/current
export PROJECT_ROOT=$WORK_ROOT/code/synergisms/
export CMAKE="/C/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/"

PATH=$M2_HOME/bin:$JAVA_HOME/bin:$NODE/bin:$PYTHONPATH:$PYTHONPATH/Scripts:$PYTHONPATH/Lib:$YARN_HOME/bin:$PATH
PATH=$CODEQL_HOME:$PROTOC_HOME/bin:$PATH:$PROJECT_ROOT/bin:$CMAKE/bin:$GRADLE_HOME/bin:$PATH
PATH=$PATH:$PROGRAMS_ROOT/rust/rustup/toolchains/stable-$(uname -m)-unknown-linux-gnu/bin:$PATH
export PATH

source "$PROGRAMS_ROOT/rust/cargo/env"
export RUSTUP_HOME=$PROGRAMS_ROOT/rust/rustup
export CARGO_HOME=$PROGRAMS_ROOT/rust/cargo


export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.desktop/java.awt.font=ALL-UNNAMED \
-DWORK_ROOT=$WORK_ROOT"
export MAVEN_OPTS="${JAVA_OPTS}"
export PYTHONPATH=$PYTHONPATH:$WORK_ROOT/code/current/automation/pyscripting/

alias pushmaster='git push origin HEAD:refs/for/master'
alias pushwip='git push origin HEAD:refs/for/wip'

function activate_pyworking() {
    if test -d "$PROGRAMS_ROOT/python/venv/working/Scripts"; then
      . "${WORK_ROOT}/programs/python/venv/working/Scripts/activate"
    else
      . "${WORK_ROOT}/programs/python/venv/working/bin/activate"
    fi
}

alias pyworking=activate_pyworking

alias pipupgrade='$PROGRAMS_ROOT/python/python38/python -m pip install --upgrade pip'

function jupstart() {
    cd "$PROJECT_ROOT" || false
    activate_pyworking
    jupyter notebook
}

function in_all_directories() {
  if [ "$#" -ne 3 ]; then
      echo "3 parameters are required"
  fi

  while IFS= read -r -d '' file
  do
      exec_it=$3
      exec_it=${exec_it//\$it/$file}
      eval "$exec_it"
  done <   <(find "$1" -name "$2" -print0)
}

function log() {
    echo "$(date) $1"
}
