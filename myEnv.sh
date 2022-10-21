#!/bin/bash

export WORK_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "$WORK_ROOT"

export DISPLAY=localhost:0.0
export JAVA_HOME=$WORK_ROOT/programs/java/current/
export NODE=$WORK_ROOT/programs/nodejs/current/
export PYTHONPATH=$WORK_ROOT/programs/python/current
export M2_HOME=$WORK_ROOT/programs/maven/current
export PROJECT_ROOT=$WORK_ROOT/code/synergisms/
export CMAKE="/C/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/"

export PATH=$M2_HOME/bin:$JAVA_HOME/bin:$NODE/bin:$PYTHONPATH:$PYTHONPATH/Scripts:$PYTHONPATH/Lib:$YARN_HOME/bin:$CODEQL_HOME:$PROTOC_HOME/bin:$PATH:$PROJECT_ROOT/bin:$CMAKE/bin
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
    if test -d "$WORK_ROOT/programs/python/venv/working/Scripts"; then
      . "${WORK_ROOT}/programs/python/venv/working/Scripts/activate"
    else
      . "${WORK_ROOT}/programs/python/venv/working/bin/activate"
    fi
}

alias pyworking=activate_pyworking

alias pipupgrade='$WORK_ROOT/programs/python/python38/python -m pip install --upgrade pip'

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


