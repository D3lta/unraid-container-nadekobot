# unraid-container-nadekobot

Application: Nadekobot - https://gitlab.com/Kwoth/nadekobot<br>
Documentation: https://nadeko.bot/commands | https://nadekobot.readthedocs.io/en/latest

Nadekobot Version: `5.1.14`

Registry: https://ghcr.io/d3lta/unraid-container-nadekobot <br>
GitHub: https://github.com/D3lta/unraid-container-nadekobot

Required Variables:
- `DISCORD_TOKEN`
- `DISCORD_OWNERIDS`

Mount points:
`/data`
`/config`

---

`/data` will contain the sqlite database and the bot config yaml files <br>
`/config` contains the creds.yml that will be created if it does not exist

A template is generated on first run that setups a basic config in `/config/creds.yml`
for more available options check out `/config/creds_example.yml`

Follow the official guide to get the Discord Token
https://nadekobot.readthedocs.io/en/latest/creds-guide/

ENV: `DISCORD_TOKEN` <br>
VALUE: discordtokenxens.lotsof.0391301$

There are multiple ways to get your Discord ID.
By either right clicking your name and copy ID.
By typing a message in chat `\@Yourname` to see your ID in a message.

ENV: `DISCORD_OWNERIDS` <br>
VALUE: 80351110224678912,165511591545143296
You can add a single ID or split by comma


---

# docker

```
DISCORD_TOKEN=""
DISCORD_OWNERIDS=""

docker run -it -d --rm \
-e DISCORD_TOKEN="$DISCORD_TOKEN" \
-e DISCORD_OWNERIDS="$DISCORD_OWNERIDS" \
-v "$(pwd)/data/data:/data" \
-v "$(pwd)/data/config:/config" \
ghcr.io/d3lta/unraid-container-nadekobot:5.1.14
```
