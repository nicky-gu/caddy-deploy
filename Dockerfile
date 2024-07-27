# 使用caddy:builder镜像作为构建阶段
FROM caddy:builder AS builder

# 使用xcaddy构建带有forwardproxy插件的Caddy
RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy

# 使用官方的caddy镜像作为基础镜像
FROM caddy:latest

# 从构建阶段复制Caddy二进制文件到基础镜像中
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 设置Caddy二进制文件的可执行权限
RUN chmod +x /usr/bin/caddy

# 复制Caddyfile到Caddy的配置目录
COPY Caddyfile /etc/caddy/Caddyfile
