FROM node:22-slim

# 安装 pnpm
RUN npm install -g pnpm

WORKDIR /src

# 复制所有文件
COPY . .

# 1. 安装依赖
RUN pnpm install

# 2. 编译 schema (这是最关键的一步，报错就在这)
RUN pnpm --filter @earthworm/schema build

# 3. 编译前端
RUN pnpm --filter client build

# 4. 使用预览模式运行
EXPOSE 8080
CMD ["pnpm", "--filter", "client", "preview", "--", "--host", "0.0.0.0", "--port", "8080"]
