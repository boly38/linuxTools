< [Back](../README.md)

# Linux thread limits error

> "unable to create new native thread"

this error means that the system dont let you create one more thread due to resource limits or limitations.

# Linux thread limits test

- compile then execute [MaxThreadCounter](./MaxThreadCounter.java)

````shell
MAX_THREAD_LIMIT=100000 java -Xms12029m -Xmx12029m -Xss256k MaxThreadCounter
````

# Linux thread limitations

- kernel pid max

````shell
$ sysctl kernel.pid_max
kernel.pid_max = 32768
# theoretical maximum of 32768 (2^15) for 32 bit systems or 4194304 (2^22) for 64 bit

update it as root
# echo 100000 > /proc/sys/kernel/pid_max
cat /proc/sys/kernel/pid_max
````

- kernel thread max

````shell
$ sysctl kernel.threads-max
kernel.threads-max = 127800
````

- shell resource limits: soft limitations

````shell
$ ulimit -Sa
````

- shell resource limits: hard limitations

````shell
$ ulimit -Ha
````

- effective limitations applied to a given process

````shell
cat /proc/$PID/limits
````

- systemd default user/system limits (comment)

````shell
$ cat /etc/systemd/logind.conf
$ cat /etc/systemd/system.conf
````

- systemd current user default tasks max

````shell
$ systemctl show --property DefaultTasksMax
````

- systemd overall status ([src](https://www.suse.com/support/kb/doc/?id=000015901))

````shell
$ systemd-analyze dump
````

- systemd TasksMax of given service (or user)

````shell
$ systemd-analyze dump | sed -n "/-> Unit my-service.service:/,/-> Unit /p"| grep -e "TasksMax="
$ cat /etc/systemd/system/my-service.service.d/00-limits.conf # example
[Service]
LimitNOFILE=infinity:infinity
TasksMax=30000

# set user limit
$ sudo systemctl set-property user-1013.slice TasksMax=100000
````
