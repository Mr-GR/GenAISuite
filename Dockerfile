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

# Install necessary system packages (including PostgreSQL support)
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential git libvips pkg-config libpq-dev curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Throw-away build stage to reduce final image size
FROM base as build

# Copy Gemfile and Gemfile.lock before installing gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Ensure Rails is installed in the image
RUN bundle exec gem install rails

# Final stage for the application
FROM base

# Copy built artifacts: gems and application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Set up environment variables
ENV DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME_PROD}" \
    REDIS_URL="redis://${REDIS_HOST}:${REDIS_PORT}/0" \
    OLLAMA_API="http://ollama:11434"

# Expose the Rails server port
EXPOSE 3000

# Ensure Rails starts
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
