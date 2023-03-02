FROM rust as build

COPY ./Cargo.lock ./Cargo.toml /build/
COPY ./src /build/src

WORKDIR /build

RUN cargo build --release

# Let's build the final image
FROM debian:11

COPY --from=build /build/target/release/agate /usr/local/bin/agate
COPY tools/docker/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]
