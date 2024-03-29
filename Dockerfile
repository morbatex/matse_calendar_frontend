FROM node:alpine
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN yarn install && yarn build

FROM flashspys/nginx-static
ENTRYPOINT ["/entrypoint.sh"]
RUN apk update && apk upgrade
COPY --from=0 /usr/src/app/dist /static
COPY entrypoint.sh /
