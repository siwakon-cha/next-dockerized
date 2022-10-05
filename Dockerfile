# ================================================================
# builder stage
# ================================================================
FROM node:16-alpine as builder
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app
COPY package*.json ./
COPY . ./
RUN yarn
RUN yarn build
RUN yarn export

# ================================================================
# final deploy stage
# ================================================================
FROM nginx:alpine as app
COPY --from=builder /usr/src/app/out /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
