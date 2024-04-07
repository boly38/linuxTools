#!/bin/bash

# setup JVM memory limits
java_args=("-Xms22029m" "-Xmx22029m" "-XX:ThreadStackSize=228" "-XX:VMThreadStackSize=228")

# report current JVM info about threads
java "${java_args[@]}" -XX:+PrintFlagsFinal -version | grep -iE 'HeapSize|PermSize|ThreadStackSize'

# start test reusing JVM config from JAVA_OPTS
MAX_THREAD_LIMIT=100000 java "${java_args[@]}" MaxThreadCounter
