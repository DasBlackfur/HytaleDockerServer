FROM alpine AS build
RUN apk upgrade -U && apk add wget unzip && wget https://downloader.hytale.com/hytale-downloader.zip && unzip hytale-downloader.zip

FROM eclipse-temurin:25-jre
ENV MAX_MEM=4G
RUN apt update && apt install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*
RUN rm /etc/machine-id && ln -s /server/machine-id /etc/machine-id
WORKDIR /server
USER 1000:1000
COPY entrypoint.sh /
COPY --from=build /hytale-downloader-linux-amd64 /
ENTRYPOINT ["sh", "/entrypoint.sh"]
