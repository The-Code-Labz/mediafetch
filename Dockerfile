FROM node:20-alpine

WORKDIR /app

# Install system dependencies including python3 for pip-based yt-dlp
RUN apk add --no-cache \
    curl \
    python3 \
    py3-pip \
    ffmpeg \
    ca-certificates

# Install yt-dlp via pip — works on Alpine musl, any architecture, no glibc needed
# The prebuilt yt-dlp binaries require glibc which Alpine does not have
RUN pip3 install --break-system-packages yt-dlp

# Verify yt-dlp is installed and executable
RUN yt-dlp --version

COPY package*.json ./
RUN npm install --omit=dev

COPY . .

# Ensure logs directory exists
RUN mkdir -p /app/logs

ENV NODE_ENV=production
ENV FORCE_COLOR=0

EXPOSE 3002
CMD ["node", "server.js"]
