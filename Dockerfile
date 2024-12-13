# Update Node.js to version 20
FROM node:20-alpine AS builder
# Set the working directory to /usr/src/app
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm cache clean --force
RUN npm install
COPY . .
FROM node:20-alpine
# Install dependencies for wkhtmltopdf
RUN apk update && apk add --no-cache \
    build-base \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libssl3 \
    ca-certificates \
    fontconfig \
    freetype \
    ttf-dejavu \
    ttf-droid \
    ttf-freefont \
    ttf-liberation \
    ghostscript \
    chromium \
    # more fonts
    && apk add --no-cache --virtual .build-deps \
    msttcorefonts-installer \
    # Install microsoft fonts
    && update-ms-fonts \
    && fc-cache -f \
    # Clean up when done
    && rm -rf /tmp/* \
    && apk del .build-deps

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
RUN yarn add puppeteer

# Set the working directory to /usr/src/app
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app /usr/src/app
EXPOSE 4000 9229
CMD npm start
