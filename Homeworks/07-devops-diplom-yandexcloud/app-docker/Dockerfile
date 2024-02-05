FROM amd64/nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY ./www /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
 