FROM alpine:latest

COPY server /server

ENTRYPOINT ["/server"]
CMD ["--port=8080"]
