FROM rust:alpine as build

# We need g++ for stdint.h which is required by the dependency ring
RUN apk update && apk add g++

COPY ./Cargo.lock ./Cargo.toml /build/
COPY ./src /build/src

WORKDIR /build

RUN cargo build --release

# Let's build the final image
FROM alpine:latest

COPY --from=build /build/target/release/agate /usr/local/bin/agate
COPY tools/docker/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]
