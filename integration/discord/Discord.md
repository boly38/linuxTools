< [Back](../../README.md)

# Discord

## How to

### setup
 
(first time only)
 * go to discord #channel parameters/integration to create your own webhook url
 * set webhook url with token as environment variable
````shell
export DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/xxxx/update_me
````

### send text + file
````shell
. ./discordNotifier.sh
discordNotification hello
````

### send text + file
````shell
echo "this is a file" > myFile
discordNotification "here is the file" ./myFile
````