# Stage 1: Build Angular
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/dist/angular-github-actions /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
