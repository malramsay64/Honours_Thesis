#!/bin/bash

# Count instances of each word
cat $1 | tr "[:punct:]" " " | tr " " "\n" | tr '[:upper:]' '[:lower:]' | grep -v '^$' | sort | uniq -c | sort
