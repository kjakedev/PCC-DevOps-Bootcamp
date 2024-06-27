FROM node:18.12.1-slim

COPY . /opt/nodejs-todo
WORKDIR /opt/nodejs-todo
ENV DB_URL="mongodb"
ENV DB_NAME="test"

RUN npm install
RUN npm run build-prod

ENTRYPOINT ["npm","run", "serve"]
