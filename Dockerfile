##
## Build stage
##
FROM docker.io/library/golang:1.16-buster AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN go build -o /app/bypass-cors

##
## Deploy stage
##
FROM gcr.io/distroless/base-debian10

WORKDIR /app

COPY --from=build /app/bypass-cors /app/bypass-cors

EXPOSE 9000

USER nonroot:nonroot

CMD ["/app/bypass-cors"]
