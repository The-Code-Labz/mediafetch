FROM node:20-alpine

RUN apk add --no-cache curl python3 ffmpeg

ARG TARGETARCH
RUN case "$TARGETARCH" in \
    amd64)  YTDLP=yt-dlp ;; \
    arm64)  YTDLP=yt-dlp_linux_aarch64 ;; \
    arm)    YTDLP=yt-dlp_linux_armv7l ;; \
    *)      YTDLP=yt-dlp ;; \
  esac && \
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/$YTDLP -o /usr/local/bin/yt-dlp && \
  chmod a+rx /usr/local/bin/yt-dlp

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
