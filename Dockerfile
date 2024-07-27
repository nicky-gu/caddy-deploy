# 使用Caddy builder镜像构建包含 forwardproxy 插件的Caddy二进制文件
FROM caddy:builder AS builder

# 使用 xcaddy 构建包含 forwardproxy 插件的Caddy
RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy

# 使用最新的Caddy镜像
FROM caddy:latest

# 从 builder 镜像中复制生成的Caddy二进制文件
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 复制Caddyfile到Caddy的配置目录
COPY Caddyfile /etc/caddy/Caddyfile
