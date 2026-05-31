FROM golang:1.22.5 AS base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

# EXPOSE 8080

# CMD ["./main"]

# Final Stage -- DISTROLESS IMAGE (FOR REDUCED SIZE & SECURITY)

FROM gcr.io/distroless/base

WORKDIR /

#copy the built binary from the base stage to the final image
COPY --from=base /app/main .  

#copy the static files from the base stage to the final image
COPY --from=base /app/static ./static

EXPOSE 8080

# Set the command to run the application
CMD ["/main"]  