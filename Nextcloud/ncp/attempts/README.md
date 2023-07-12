# Nextcloud-fpm with Caddy

### Prerequisites

- Docker Compose V2

Copy the `docker-compose.yml` & `Caddyfile` files locally

<details><summary>Docker Compose file</summary>

```
version: '3.7'
services:
  db:
    image: mariadb:10.5
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=mysqld-bin --binlog-format=ROW
    networks:
      net:
        ipv4_address: 172.24.0.2
        # ipv6_address: [Add IPv6 address here]
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD="$DB_ROOT_PASSWORD"
      - MYSQL_PASSWORD="$DB_PASSWORD"
      - MYSQL_DATABASE="$DB_DATABASE"
      - MYSQL_USER="$DB_USER"

  app:
    image: nextcloud:fpm-alpine
    restart: always
    links:
      - db
    networks:
      net:
        ipv4_address: 172.24.0.3
        # ipv6_address: [Add IPv6 address here]
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_PASSWORD="$DB_PASSWORD"
      - MYSQL_DATABASE="$DB_DATABASE"
      - MYSQL_USER="$DB_USER"
      - MYSQL_HOST=db
      # See: https://hub.docker.com/_/nextcloud/
      - APACHE_DISABLE_REWRITE_IP=1
      # See: https://github.com/nextcloud/documentation/issues/7005
      # and: https://old.reddit.com/r/NextCloud/comments/s3skdn/nextcloud_behind_caddy_as_a_reverse_proxy_using/hsnj5wh/
      - TRUSTED_DOMAINS="$IP"
      - TRUSTED_DOMAINS="$DOMAIN"
      - TRUSTED_PROXIES=127.0.0.1
      - TRUSTED_PROXIES=web
    # see: https://github.com/nextcloud/documentation/blob/master/admin_manual/configuration_server/reverse_proxy_configuration.rst  
    labels:
      # caddy: 192.xx.xxx.xx:8080
      caddy.reverse_proxy: "{{upstreams}}"
      # see: https://github.com/lucaslorentz/caddy-docker-proxy/issues/114
      caddy.header: /*
      # see: https://docs.nextcloud.com/server/23/admin_manual/installation/harden_server.html#enable-http-strict-transport-security
      caddy.header.Strict-Transport-Security: '"max-age=15552000;"'
      # see: https://docs.nextcloud.com/server/23/admin_manual/issues/general_troubleshooting.html#service-discovery
      # https://github.com/lucaslorentz/caddy-docker-proxy/issues/222
      caddy.rewrite_0: /.well-known/carddav /remote.php/dav
      caddy.rewrite_1: /.well-known/caldav /remote.php/dav

  web:
    image: zendai/caddy:2.6.2
    ports:
      - 8080:80
      - 8443:443
    links:
      - app
    networks:
      net:
        ipv4_address: 172.24.0.4
        # ipv6_address: [Add IPv6 address here]
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
    volumes_from:
      - app
    restart: always

networks:
  net:
    ipam:
      driver: default
      config:
        - subnet: "172.24.0.0/24"
        # - subnet: "[Add IPv6 subnet here]"

volumes:
  db:
  nextcloud:
  caddy_data: {}

```

</details>

<details><summary>Caddyfile</summary>

```
{
	# email 
	# http_port 80
	# https_port 443
	# skip_install_trust
	# debug
	local_certs
	# auto_https off
	# Development certificates from letsencrypt, not as rate-limited as the regular one
    # Comment it to use the regular certificates if you have a FQDN and not developing
	acme_ca https://acme-staging-v02.api.letsencrypt.org/directory
	log {
		format json {
			message_key msg
			level_key level
			time_key ts
			name_key name
		}
	}
	servers {
		protocols h1 h2 h2c h3
		strict_sni_host insecure_off
	}
}

:80 {
	redir /.well-known/carddav /remote.php/dav 301
	redir /.well-known/caldav /remote.php/dav 301

	header {
		# enable HSTS
		# Strict-Transport-Security max-age=31536000;
	}

	# .htaccess / data / config / ... shouldn't be accessible from outside
	@forbidden {
		path /.htaccess
		path /data/*
		path /config/*
		path /db_structure
		path /.xml
		path /README
		path /3rdparty/*
		path /lib/*
		path /templates/*
		path /occ
		path /console.php
	}
	respond @forbidden 404

	root * /var/www/html
	php_fastcgi app:9000
	file_server
}

:443 172.24.0.4 {
	redir /.well-known/carddav /remote.php/dav 301
	redir /.well-known/caldav /remote.php/dav 301

	header {
		enable HSTS
		Strict-Transport-Security max-age=15552000;
	}

	# .htaccess / data / config / ... shouldn't be accessible from outside
	@forbidden {
		path /.htaccess
		path /data/*
		path /config/*
		path /db_structure
		path /.xml
		path /README
		path /3rdparty/*
		path /lib/*
		path /templates/*
		path /occ
		path /console.php
	}
	respond @forbidden 404

	root * /var/www/html
	php_fastcgi app:9000
	file_server
}
```

</details>

Create an environment file named `.env` and put the following environment variables inside

<details><summary>Environment variables</summary>

```
# # # # # # # # # # # # #
# Variables used in the docker-compose.yml file

IP=[Put device IP-address here]
DOMAIN=[Put FQDN here]
DB_ROOT_PASSWORD=[Put a database root password here]
# You will need the DB_PASSWORD when you initialize Nextcloud
DB_PASSWORD=[Put a database password here]
DB_DATABASE=nextcloud
DB_USER=nextcloud

# # # # # # # # # # # # # 
# Change pre-defined environment variables
# https://docs.docker.com/compose/environment-variables/envvars/

# COMPOSE_CONVERT_WINDOWS_PATHS=
# COMPOSE_FILE=
# COMPOSE_PROFILES=
# This sets the default project name that compose will append to networks, volumes etc.
COMPOSE_PROJECT_NAME=ncp
# DOCKER_CERT_PATH=
# COMPOSE_PARALLEL_LIMIT=
# COMPOSE_IGNORE_ORPHANS=
# COMPOSE_REMOVE_ORPHANS=
# COMPOSE_PATH_SEPARATOR=

# # # # # # # # # # # # #
```

</details>

Start/Run the services with: `docker compose up -d` & access them via the device's local IP-address or your FQDN 
