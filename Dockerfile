### BUILD STAGE ### 

FROM node:24-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
RUN npm run build


### RUNTIME STAGE ###

FROM nginx:alpine 
COPY --from=build /app/dist /usr/share/nginx/html 
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /etc/nginx/conf.d && \
    touch /run/nginx.pid && \
    chown appuser:appgroup /run/nginx.pid
USER appuser
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD wget --no-verbose --tries=1 --spider http://localhost:80 || exit 1 
CMD ["nginx", "-g", "daemon off;"]

