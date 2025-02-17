FROM node:20-slim
ENV YARN_VERSION=4.2.2

# Add these environment variables
ENV FORCE_COLOR=0
ENV YARN_ENABLE_PROGRESS_BARS=false
ENV YARN_ENABLE_COLORS=false

RUN corepack enable && corepack prepare yarn@${YARN_VERSION}

WORKDIR /app

COPY package.json ./

# Install dependencies (including devDependencies)
RUN yarn install


# Now set production mode for runtime
ENV NODE_ENV=production

COPY config /app/config
ENV MESHQL_CONFIG_PATH=/app/config/config.conf

CMD ["yarn", "start"]