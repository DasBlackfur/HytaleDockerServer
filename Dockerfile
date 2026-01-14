FROM alpine AS build
RUN apk upgrade -U && apk add wget unzip && wget https://downloader.hytale.com/hytale-downloader.zip && unzip hytale-downloader.zip

FROM eclipse-temurin:25-jre
WORKDIR /server
#USER server
ENV MAX_MEM=4G
RUN apt update && apt install -y unzip
COPY entrypoint.sh /
COPY --from=build /hytale-downloader-linux-amd64 /
ENTRYPOINT ["sh", "/entrypoint.sh"]
