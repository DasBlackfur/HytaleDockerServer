#!/usr/bin/env sh

download_install () {
  /hytale-downloader-linux-amd64 -download-path /server/current-version.zip
  unzip ./current-version.zip
  rm ./current-version.zip
  /hytale-downloader-linux-amd64 -print-version > ./current-version
}

clean_files () {
  rm -rf ./Server
  rm Assets.zip
}

if [ ! -f /server/current-version]; then
  echo "Running first time installation..."
  download_install
else
  echo "Checking for updates..."
  upstream_version=$(/hytale-downloader-linux-amd64 -print-version)
  current_version=$(cat ./current-version)
  if [$upstream_version != $current_version]; then
    echo "Update from $current_version to $upstream_version found! Updating..."
    clean_files
    download_install
  fi
fi

echo "Starting the server..."
java -jar -Xmx"$MAX_MEM" ./Server/HytaleServer.jar --assets ./Assets.zip --bind 0.0.0.0:5555
