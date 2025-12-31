FROM node:22-slim

# 强制安装 pnpm 和 typescript (解决 Vue 编译器报错)
RUN npm install -g pnpm typescript

WORKDIR /src

# 复制所有文件
COPY . .

# 1. 禁用 husky 等不必要的钩子，只安装依赖
RUN pnpm install --no-frozen-lockfile

# 2. 编译基础依赖包
RUN pnpm --filter @earthworm/schema build

# 3. 强制使用 pnpm 编译 client (不让 Zeabur 自动调 yarn)
RUN pnpm --filter client build

# 4. 预览启动
EXPOSE 8080
CMD ["pnpm", "--filter", "client", "preview", "--", "--host", "0.0.0.0", "--port", "8080"]
