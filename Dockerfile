# Build stage
FROM golang:1.26.3-alpine3.23 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Run stage
FROM alpine:3.23
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /go/bin/migrate .
COPY db/migration ./migration
COPY app.env .
COPY start.sh .
RUN chmod +x /app/start.sh
EXPOSE 8080
ENTRYPOINT ["/app/start.sh"]
CMD ["/app/main"]