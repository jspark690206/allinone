FROM nginx:alpine
LABEL org.opencontainers.image.title="e1-workstation"
ENV APP_ENV=learning
COPY site/ /usr/share/nginx/html/
EXPOSE 80
