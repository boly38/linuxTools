< [Back](../../README.md)

# SshNotify

[Original idea from Dev.to 🙏](https://dev.to/search?utf8=%E2%9C%93&q=%2BSsh+%2BLogin+%2BNotify)

As VM/VPS owner/maintainer, I would like to be notified when someone is login onto my server.

We don't talk here about sshd security config, ex. `PasswordAuthentication no`, `PubkeyAuthentication yes`.. or [fail2ban](https://github.com/fail2ban/fail2ban) tools. But only to get notified on ssh login event.

## How to

### setup

1) update and customize `sshnotify.sh` with your needs :

- set your own notification mechanism. For example, you can use Discord webhook, Slack, email
- if you're using Discord, simply update suggested Discord webhook url
- put it on your server in `/etc/ssh/scripts/` with good permissions (`chmod 755 /etc/ssh/scripts/sshnotify.sh`)

```bash
 # ls /etc/ssh/scripts/
-rwxr-xr-x 1 root root  742 Oct 12  2021 sshnotify.sh
```

2) verify it !

- verify that customized `sshnotify.sh` is working well.

3) add it to login event

- add `sshnotify.sh` to your login triggered script

Ex. for `pam.d`
```bash
# add this line to the end of:  /etc/pam.d/sshd
session    optional     pam_exec.so seteuid /etc/ssh/scripts/sshnotify.sh
```

- without logout, try to login in another terminal to verify your ssh login step is ok.
- et voilà 
