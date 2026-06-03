FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache ffmpeg python3 curl

# Architecture-aware yt-dlp download
# Supports: linux/amd64 (x86_64), linux/arm64 (aarch64), linux/arm/v7 (armv7l)
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64)  DLP_FILE="yt-dlp" ;; \
        aarch64) DLP_FILE="yt-dlp_linux_aarch64" ;; \
        armv7l)  DLP_FILE="yt-dlp_linux_armv7l" ;; \
        *)       DLP_FILE="yt-dlp" ;; \
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
