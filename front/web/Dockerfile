FROM node:20-alpine AS build

COPY app/package.json ./app/package.json
RUN cd app && npm install --frozen-lockfile

COPY app/ ./app
