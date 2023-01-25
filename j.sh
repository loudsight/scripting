#!/bin/bash

SCRIPT=$(cat "$1")

IFS='/' read -ra STR_TOKENS <<< "$1"
LEN=${#STR_TOKENS[@]}
JAVA_SCRIPT_FILE=${STR_TOKENS[$LEN - 1]}

echo $JAVA_SCRIPT_FILE

IFS='.' read -ra STR_TOKENS <<< "$JAVA_SCRIPT_FILE"
JAVA_CLASS=${STR_TOKENS[0]}

jshell << END
$SCRIPT
new $JAVA_CLASS().accept();
END
