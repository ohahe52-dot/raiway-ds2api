# Dùng image Go chính thức để build
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Cài đặt git và các công cụ cần thiết để build
RUN apk add --no-cache git nodejs npm

# Clone mã nguồn và build frontend
RUN git clone https://github.com/CJackHwang/ds2api.git . && \
    cd webui && npm install && npm run build && \
    cd .. && go build -o ds2api ./cmd/ds2api

# Tạo image cuối cùng, nhẹ hơn
FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

# Copy file thực thi và thư mục static từ builder
COPY --from=builder /app/ds2api .
COPY --from=builder /app/static ./static

# Mở cổng mặc định
EXPOSE 5001

CMD ["./ds2api"]
