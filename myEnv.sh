#!/bin/bash

export WORK_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "$WORK_ROOT"
export DISPLAY=localhost:0.0
export JAVA_HOME=$WORK_ROOT/programs/java/latest/
export NODE=$WORK_ROOT/programs/node/latest/
export PYTHONPATH=$WORK_ROOT/programs/python/python38
export M2_HOME=$WORK_ROOT/programs/maven/latest
export PROJECT_ROOT=$WORK_ROOT/code/synergisms/

export PATH=$M2_HOME/bin:$JAVA_HOME/bin:$NODE/bin:$PYTHONPATH:$PYTHONPATH/Scripts:$PYTHONPATH/Lib:$YARN_HOME/bin:$CODEQL_HOME:$PROTOC_HOME/bin:$PATH:$PROJECT_ROOT/bin
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.util=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.lang.reflect=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.text=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.util=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.lang.reflect=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.text=ALL-UNNAMED"
export JAVA_OPTS="${JAVA_OPTS} --add-opens java.desktop/java.awt.font=ALL-UNNAMED"
export MAVEN_OPTS="${JAVA_OPTS}"

alias pushmaster='git push origin HEAD:refs/for/master'
alias pushwip='git push origin HEAD:refs/for/wip'

function activate_pyworking() {
    if test -d "$WORK_ROOT/programs/python/venvs/working/Scripts"; then
      . "${WORK_ROOT}/programs/python/venvs/working/Scripts/activate"
    else
      . "${WORK_ROOT}/programs/python/venvs/working/bin/activate"
    fi
}

alias pyworking=activate_pyworking

alias pipupgrade='$WORK_ROOT/programs/python/python38/python -m pip install --upgrade pip'

function jupstart() {
    cd "$PROJECT_ROOT" || false
    activate_pyworking
    jupyter notebook
}
