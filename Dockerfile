# 使用基礎鏡像（例如 Node.js）來構建 React 應用
FROM node:18 AS builder

# 設置工作目錄
WORKDIR /app

# 將 package.json 和 package-lock.json（如果有）複製到工作目錄
COPY package*.json ./

# 安裝專案依賴
RUN npm ci

# 複製整個專案到工作目錄
COPY . .

# 構建 Vue 應用
RUN npm run build

# 使用 Nginx 作為基礎鏡像
FROM nginx

# 將自定義的 Nginx 配置文件複製到容器中
# COPY nginx.conf /etc/nginx/nginx.conf

# 啟用 gzip 壓縮
# RUN sed -i 's/#gzip/gzip/' /etc/nginx/nginx.conf

# 將 React 構建文件複製到 Nginx 默認的靜態文件目錄
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露容器的端口
EXPOSE 80

# 啟動 Nginx 伺服器
CMD ["nginx", "-g", "daemon off;"]
