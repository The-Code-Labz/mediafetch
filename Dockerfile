FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---

FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache \
    curl \
    python3 \
    ffmpeg \
    ca-certificates

# TARGETARCH is set by BuildKit/QEMU — correct for GitHub Actions cross-builds
ARG TARGETARCH
RUN case "$TARGETARCH" in \
        arm64) DLP_FILE="yt-dlp_linux_aarch64" ;; \
        arm)   DLP_FILE="yt-dlp_linux_armv7l"  ;; \
        *)     DLP_FILE="yt-dlp_linux"          ;; \
    esac && \
    curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/${DLP_FILE}" \
         -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]
