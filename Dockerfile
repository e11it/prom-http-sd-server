FROM golang:1.25.5 AS builder

LABEL maintainer="Alain Lefebvre <hartfordfive@gmail.com>"
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN make DOCKER=1 build

FROM golang:1.25.5-alpine 

COPY --from=builder /app/prom-http-sd-server /bin/prom-http-sd-server
ADD _samples/config_local.yaml /etc/prom-http-sd-server/prom-http-sd-server.conf

EXPOSE 80
VOLUME /sd-server
ENTRYPOINT [ "/bin/prom-http-sd-server" ]
#CMD [ "-conf-path", "/etc/prom-http-sd-server/conf.yaml" ]
