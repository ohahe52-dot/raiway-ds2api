FROM golang:1.21-alpine AS builder

WORKDIR /app

# Cài đặt git và các công cụ cần thiết
RUN apk add --no-cache git

# Cài đặt Node.js 22 từ nguồn edge (không cài npm mặc định)
RUN apk add --no-cache nodejs=22.14.0-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk add --no-cache npm --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

# Clone mã nguồn và build frontend
RUN git clone https://github.com/CJackHwang/ds2api.git . && \
    cd webui && npm install && npm run build && \
    cd .. && go build -o ds2api ./cmd/ds2api

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/ds2api .
COPY --from=builder /app/static ./static

EXPOSE 5001

CMD ["./ds2api"]
