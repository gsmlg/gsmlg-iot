FROM node:lts-alpine

MAINTAINER "GSMLG < me@gsmlg.org >"

RUN npm install -g homebridge pm2 homebridge-mi-acpartner miio && mkdir /homebridge

USER 1000

VOLUME "/homebridge"

ENTRYPOINT ["homebridge", "--user-storage-path", "/homebridge"]


