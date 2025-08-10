FROM nginx:latest
LABEL authors="bielico"
COPY src/main/resources/static/index.html /usr/share/nginx/html

ENTRYPOINT ["top", "-b"]