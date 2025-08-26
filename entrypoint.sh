#!/bin/bash
set -e

# Function to create new Jekyll site
create_site() {
    local site_name="$1"
    local site_dir="/workspace/projects/$site_name"
    
    echo "Creating new Jekyll site: $site_name"
    
    # Create site directory if it doesn't exist
    mkdir -p "$site_dir"
    cd "$site_dir"
    
    # Initialize Jekyll site
    if [ ! -f "_config.yml" ]; then
        jekyll new . --force --blank
        echo "Jekyll site created successfully"
    else
        echo "Jekyll site already exists"
    fi
    
    # Install dependencies if Gemfile exists
    if [ -f "Gemfile" ]; then
        echo "Installing dependencies..."
        bundle install
    fi
}

# Function to build Jekyll site
build_site() {
    local site_dir="$1"
    
    echo "Building Jekyll site in: $site_dir"
    cd "$site_dir"
    
    # Install dependencies first
    if [ -f "Gemfile" ]; then
        bundle install
    fi
    
    # Build the site
    bundle exec jekyll build
    echo "Site built successfully"
}

# Function to serve Jekyll site
serve_site() {
    local site_dir="$1"
    local port="${2:-4000}"
    
    echo "Serving Jekyll site from: $site_dir on port: $port"
    cd "$site_dir"
    
    # Install dependencies first
    if [ -f "Gemfile" ]; then
        bundle install
    fi
    
    # Serve the site
    bundle exec jekyll serve --host 0.0.0.0 --port "$port" --livereload --incremental --force_polling
}

# Main command handling
case "$1" in
    "create")
        create_site "$2"
        ;;
    "build")
        build_site "$2"
        ;;
    "serve")
        if [ -n "$2" ]; then
            serve_site "$2" "$3"
        else
            # Default serve behavior for development
            cd /workspace
            exec "$@"
        fi
        ;;
    "jekyll")
        # Default Jekyll commands
        exec "$@"
        ;;
    *)
        echo "Usage: $0 {create|build|serve} [site_name] [port]"
        echo "  create <site_name>  - Create new Jekyll site"
        echo "  build <site_dir>    - Build existing Jekyll site"
        echo "  serve <site_dir>    - Serve Jekyll site with live reload"
        echo "  jekyll [args]       - Run Jekyll directly"
        exit 1
        ;;
esac