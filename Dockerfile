FROM node:latest

MAINTAINER Ramu Arumugam 

RUN echo "Tryin to build my first application"

COPY . /var/www

WORKDIR /var/www

RUN npm install

RUN npm rebuild node-saas

EXPOSE 3000

ENTRYPOINT ["npm","start"]