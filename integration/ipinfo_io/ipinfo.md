< [Back](../../README.md)

# ipinfo.io

## How to

### setup

(first time only)
* login and get a free token from https://ipinfo.io/
* setup `IPINFO_TOKEN` as environment variable or in root `.env` file (cf. template)
````shell
export IPINFO_TOKEN=xxxx
````

### get ip information

My ip
````shell
./integration/ipinfo_io/ipinfo.sh me
````

another ip
````shell
./integration/ipinfo_io/ipinfo.sh www.xxx.yyy.zzz
````