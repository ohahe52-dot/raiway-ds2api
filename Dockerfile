FROM node:22-alpine AS builder

WORKDIR /app

RUN npm install -g ds2api

EXPOSE 5001

CMD ["ds2api"]
