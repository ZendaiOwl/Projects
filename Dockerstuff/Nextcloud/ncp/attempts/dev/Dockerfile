# syntax=docker/dockerfile:1
FROM docker/compose AS compose
COPY ./Caddy/Dockerfile.caddy /Caddy/Dockerfile
COPY ./Caddy/Caddyfile /Caddy/Caddyfile
COPY ./docker-compose.yml ./docker-compose.yml
COPY ./.env ./.env
# CMD docker-compose up
