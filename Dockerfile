# 使用caddy:builder镜像作为构建阶段
FROM caddy:builder AS builder

# 使用xcaddy构建带有forwardproxy插件的Caddy
RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy

# 使用官方的caddy镜像作为基础镜像
FROM caddy:latest

# 从构建阶段复制Caddy二进制文件到基础镜像中
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 设置Caddy二进制文件的可执行权限为755
RUN chmod 755 /usr/bin/caddy

# 复制Caddyfile到Caddy的配置目录
COPY Caddyfile /etc/caddy/Caddyfile

# 添加调试信息
RUN echo "Caddy binary permissions:" && ls -l /usr/bin/caddy
RUN echo "Caddyfile contents:" && cat /etc/caddy/Caddyfile

# 使用非root用户运行Caddy
USER caddy

# 运行 Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
