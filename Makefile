# Jekyll Studio Docker Management
.PHONY: build up down create serve build-site logs shell clean help

# Default site name
SITE_NAME ?= my-site
PORT ?= 4000

help: ## Show this help message
	@echo "Jekyll Studio Docker Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build Jekyll container
	docker-compose build jekyll

up: ## Start Jekyll container
	docker-compose up -d jekyll

down: ## Stop Jekyll container
	docker-compose down

create: ## Create new Jekyll site (usage: make create SITE_NAME=my-blog)
	docker-compose run --rm jekyll create $(SITE_NAME)

serve: ## Serve Jekyll site (usage: make serve SITE_NAME=my-blog PORT=4001)
	docker-compose run --rm -p $(PORT):$(PORT) jekyll serve /workspace/projects/$(SITE_NAME) $(PORT)

build-site: ## Build Jekyll site (usage: make build-site SITE_NAME=my-blog)
	docker-compose run --rm jekyll build /workspace/projects/$(SITE_NAME)

logs: ## Show container logs
	docker-compose logs -f jekyll

shell: ## Access container shell
	docker-compose exec jekyll /bin/bash

clean: ## Clean up containers and volumes
	docker-compose down -v
	docker system prune -f

# Development shortcuts
dev: build up ## Build and start development environment

new: ## Quick create and serve new site
	make create SITE_NAME=$(SITE_NAME)
	make serve SITE_NAME=$(SITE_NAME)

# Production commands
prod-build: ## Build for production
	JEKYLL_ENV=production docker-compose run --rm jekyll build /workspace/projects/$(SITE_NAME)

# Proxy commands (optional)
proxy-up: ## Start with nginx proxy
	docker-compose --profile proxy up -d

proxy-down: ## Stop proxy
	docker-compose --profile proxy down