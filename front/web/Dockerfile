FROM node:latest

WORKDIR /app

COPY /app .

RUN npm install \
    && npm run build

EXPOSE 8081

CMD [ "node", "app/.output/server/index.mjs" ]
