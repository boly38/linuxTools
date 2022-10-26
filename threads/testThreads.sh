#!/bin/bash

# setup JVM memory limits
# export JAVA_OPTS="-Xms12029m -Xmx12029m -Xss228K"
export JAVA_OPTS="-Xms22029m -Xmx22029m -XX:ThreadStackSize=228 -XX:VMThreadStackSize=228"

# report current JVM info about threads
java $JAVA_OPTS -XX:+PrintFlagsFinal -version | grep -iE 'HeapSize|PermSize|ThreadStackSize'

# start test reusing JVM config from JAVA_OPTS
MAX_THREAD_LIMIT=100000 java $JAVA_OPTS MaxThreadCounter
