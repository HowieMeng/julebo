FROM node:22-slim

# 1. 安装基础工具
RUN npm install -g pnpm

WORKDIR /src

# 2. 复制所有文件
COPY . .

# 3. 核心修正：安装依赖，并强行补上构建所需的 typescript
# --no-frozen-lockfile 可以防止因手动添加包导致的锁定文件报错
RUN pnpm install --no-frozen-lockfile
RUN pnpm add -Dw typescript --filter client

# 4. 编译基础依赖包
RUN pnpm --filter @earthworm/schema build

# 5. 编译前端
RUN pnpm --filter client build

# 6. 预览启动
EXPOSE 8080
CMD ["pnpm", "--filter", "client", "preview", "--", "--host", "0.0.0.0", "--port", "8080"]
