FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache ffmpeg python3 curl

ARG TARGETARCH
RUN case "$TARGETARCH" in \
        amd64)  DLP_FILE="yt-dlp" ;; \
        arm64)  DLP_FILE="yt-dlp_linux_aarch64" ;; \
        arm)    DLP_FILE="yt-dlp_linux_armv7l" ;; \
        *)      DLP_FILE="yt-dlp" ;; \
    esac && \
    curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/${DLP_FILE}" \
         -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

COPY package*.json ./
RUN npm install --omit=dev

COPY . .

ENV NODE_ENV=production
EXPOSE 3002
CMD ["node", "server.js"]
