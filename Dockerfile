# syntax = docker/dockerfile:1

# Set Ruby version (Ensure it matches .ruby-version and Gemfile)
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Install system dependencies, Node.js, Yarn, and Redis client
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential git libvips pkg-config libpq-dev curl redis-tools && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Bundler 2.6 explicitly
RUN gem install bundler -v 2.6.0 -N

# Install Foreman globally
RUN gem install foreman -N

# Throw-away build stage to reduce final image size
FROM base as build

# Copy Gemfile and Gemfile.lock before installing gems
COPY Gemfile Gemfile.lock ./

# Remove duplicate gems from Gemfile.lock
RUN bundle lock --remove-platform x86_64-linux && bundle install --without development test && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Install JavaScript dependencies (for Vite and CSS Bundling)
RUN yarn install

# Ensure Sidekiq and Rails executables are installed
RUN bundle binstubs bundler --force && \
    bundle binstubs sidekiq --force && \
    bundle binstubs rails --force

# Final stage for the application
FROM base

# Copy built artifacts: gems and application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails db log storage tmp node_modules
USER rails:rails

# Set up environment variables
ENV DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME_PROD}" \
    REDIS_URL="redis://${REDIS_HOST}:${REDIS_PORT}/0" \
    OLLAMA_API="http://ollama:11434"

# Expose the Rails server port
EXPOSE 3000

# Start Foreman to manage multiple processes (Rails, Vite, Sidekiq)
CMD ["foreman", "start", "-f", "Procfile"]
