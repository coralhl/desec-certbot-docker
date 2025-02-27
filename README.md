# :warning: The dedyn.io certbot hook has been archived in favor of the [certbot plugin](https://pypi.org/project/certbot-dns-desec/). This repo was based on the cerbot hook and should no longer be used. :warning:

# desec-hook-certbot-docker
A (unofficial) docker container to automatically renew certificates with the desec.io certbot hook via dns challenge.

## Usage

### Notes
**PLEASE BE AWARE THAT A COMPROMISED, VALID DESEC.IO TOKEN CAN PUT YOUR DOMAINS AT RISK. HARDCODING A TOKEN LIKE IN THIS CONTAINER ISN'T RECOMMENDED UNTIL [SCOPED TOKENS](https://github.com/desec-io/desec-stack/issues/347) ARE FULLY IMPLEMENTED!**

I'm using this container to get a wildcard certificate with a raspberry pi in my local network. Don't deploy this container directly to the internet.

### Build

Clone this repo and inside the project folder: 
`docker image build -t desec-certbot .`

### RUN

```
  docker run \
    -d \
    --restart unless-stopped \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/log/letsencrypt:/var/log/letsencrypt" \
    -e "TZ=Europe/Moscow" \
    --env "DEDYN_TOKEN={DEDYN_TOKEN}" \
    --env "DEDYN_NAME={DEDYN_NAME}" \
    --env "DOMAINS={DOMAINS}" \
    --env "DOMAIN_EMAIL={DOMAIN_EMAIL}" \
    desec-certbot
```
* Volumes and timezone (`TZ`) can be configured as you wish. Timezone is used for cron renewal.
* `{DEDYN_TOKEN}` a dedyn/desec token that's valid for the planned runtime of the container.
* `{DEDYN_NAME}` The domain you want a certificate for, "yourdomain.dedyn.io" or "example.com" depending on whether you use managed dns or dyndns.
* `{DOMAINS}` The domains you want a certificate for, seperated by space. 
* `{DOMAIN_EMAIL}` An email address where you can be reached to supply to Let's Encrypt.

#### Cron
The [crontab](crontab) file can be configured to run the renewal check at any time. Currently 04:00  (at night) is the default.

#### Example
```
  docker run \
    -d \
    --restart unless-stopped \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/log/letsencrypt:/var/log/letsencrypt" \
    -e "TZ=Europe/Moscow" \
    --env "DEDYN_TOKEN=abcxyzabcxyzabcxyz" \
    --env "DEDYN_NAME=example.com" \
    --env "DOMAINS=example.com *.example.com" \
    --env "DOMAIN_EMAIL=me@example.com" \
    desec-certbot
```
Note, the email doesn't need to be the same domain. You can use gmail or whatever you want.

Docker compose:
```
  services:
    desec-certbot:
      image: desec-certbot
      container_name: desec-certbot
      environment:
        - TZ=Europe/Moscow
        - DOMAIN_EMAIL=me@example.com
        - DOMAINS=example.com *.example.com
        - DEDYN_NAME=example.com
        - DEDYN_TOKEN=abcxyzabcxyzabcxyz
      volumes:
        - /etc/letsencrypt:/etc/letsencrypt
        - /var/log/letsencrypt:/var/log/letsencrypt
      restart: unless-stopped
```

## More info

* [desec.io](https://desec.io)
* [desec.io certbot hook](https://github.com/desec-io/desec-certbot-hook)
* [desec.io how to use the certbot hook](https://desec.readthedocs.io/en/latest/dyndns/lets-encrypt.html)
* [Let's Encrypt](https://letsencrypt.org)
* [Certbot](https://certbot.eff.org/)

