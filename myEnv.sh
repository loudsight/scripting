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
export GROOVY_HOME=$PROGRAMS_ROOT/groovy/current
export AUTOMATION_AGENT_HOME=$PROGRAMS_ROOT/automation-agent/current
export PROJECT_ROOT=$WORK_ROOT/code/synergisms/
export NEW_PROJECT_ROOT=$WORK_ROOT/code/primitives/primitives/


PATH=$M2_HOME/bin:$JAVA_HOME/bin:$NODE/bin:$PYTHONPATH:$PYTHONPATH/Scripts:$PYTHONPATH/Lib:$YARN_HOME/bin:$PATH
PATH=$CODEQL_HOME:$PROTOC_HOME/bin:$PATH:$PROJECT_ROOT/bin:$CMAKE/bin:$GROOVY_HOME/bin:$AUTOMATION_AGENT_HOME:$PATH
#PATH=$PATH:$PROGRAMS_ROOT/rust/rustup/toolchains/stable-$(uname -m)-unknown-linux-gnu/bin:$PATH
export PATH

export JAVA_OPTS="${JAVA_OPTS} --add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.desktop/java.awt.font=ALL-UNNAMED \
--add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED \
--add-exports jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED \
-DWORK_ROOT=$WORK_ROOT"
export MAVEN_OPTS="${JAVA_OPTS}"
export PYTHONPATH=$PYTHONPATH:$WORK_ROOT/code/current/automation/pyscripting/

alias pushmaster='git push origin HEAD:refs/for/master'
alias pushwip='git push origin HEAD:refs/for/wip'

function activate_pyworking() {
    if test -d "$PROGRAMS_ROOT/python/venv/working/Scripts"; then
      . "${WORK_ROOT}/programs/python/venv/working/Scripts/activate"
    else
      . "${WORK_ROOT}/programs/python/venvs/working/bin/activate"
    fi
}

alias pyworking=activate_pyworking

alias pipupgrade='$PROGRAMS_ROOT/python/python38/python -m pip install --upgrade pip'

function wget2() {
  wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"
}

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
