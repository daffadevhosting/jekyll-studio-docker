# Use official Ruby image as base
FROM ruby:3.1-alpine

# Set maintainer info
LABEL maintainer="jekyll-studio"
LABEL description="Jekyll container for Jekyll Studio webapp"

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    curl \
    bash \
    tzdata \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /workspace

# Install Jekyll and Bundler
RUN gem install jekyll bundler \
    && gem cleanup

# Create non-root user for security
RUN addgroup -g 1000 jekyll && \
    adduser -D -s /bin/bash -u 1000 -G jekyll jekyll

# Create directories with proper permissions
RUN mkdir -p /workspace/projects /workspace/templates \
    && chown -R jekyll:jekyll /workspace

# Copy entrypoint script
COPY --chown=jekyll:jekyll entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to non-root user
USER jekyll

# Expose ports
EXPOSE 4000 35729

# Set environment variables
ENV JEKYLL_ENV=development
ENV BUNDLE_PATH=/workspace/.bundle
ENV BUNDLE_BIN=/workspace/.bundle/bin
ENV PATH=/workspace/.bundle/bin:$PATH

# Default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload", "--incremental"]