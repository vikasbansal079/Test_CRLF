From node:14.17.1-alpine as base

WORKDIR /app
COPY . .
RUN npm install

From base as compile
RUN npm run build

From compile as test
RUN npm run test
