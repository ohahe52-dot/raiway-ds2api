# Sử dụng image Golang chính thức, nhưng đặt tên builder là "builder"
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Cài đặt git và nodejs (dùng bản mới hơn từ repository community)
RUN apk add --no-cache git nodejs npm

# NÂNG CẤP NODE LÊN 22 ĐỂ TƯƠNG THÍCH VỚI VITE
RUN apk add --no-cache nodejs=22.14.0-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

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

# Chạy ứng dụng
CMD ["./ds2api"]
