.DEFAULT_GOAL := help
.PHONY: help deploy

# Build the documents

dist/index.json: scripts/generate-index.js
	@mkdir -p $(dir $@)
	node $< > $@

# Deploy

AWS_BUCKET ?= meta.nrfcloud.com
AWS_REGION ?= us-east-1
S3_CFG := /tmp/.s3cfg-$(AWS_BUCKET)

deploy: ## Deploy to AWS S3
	@make guard-AWS_ACCESS_KEY_ID
	@make guard-AWS_SECRET_ACCESS_KEY

	$(eval VERSION ?= $(shell /usr/bin/env node -e "console.log(require('./package.json').version);"))
	$(eval DEPLOY_TIME ?= $(shell date +%s))

	# Create s3cmd config
	@echo $(S3_CFG)
	@echo "[default]" > $(S3_CFG)
	@echo "access_key = $(AWS_ACCESS_KEY_ID)" >> $(S3_CFG)
	@echo "secret_key = $(AWS_SECRET_ACCESS_KEY)" >> $(S3_CFG)
	@echo "bucket_location = $(AWS_REGION)" >> $(S3_CFG)

	# Create bucket if not exists
	@if [[ `s3cmd -c $(S3_CFG) ls | grep s3://$(AWS_BUCKET) | wc -l` -eq 1 ]]; then \
		echo "Bucket exists"; \
	else \
		s3cmd -c $(S3_CFG) mb s3://$(AWS_BUCKET); \
		s3cmd -c $(S3_CFG) ws-create s3://$(AWS_BUCKET)/ --ws-index=index.json --ws-error=404.html; \
	fi

	# Upload
	s3cmd -c $(S3_CFG) \
		sync -P -M --no-mime-magic --delete-removed ./dist/ s3://$(AWS_BUCKET)/

	# Expires 60 minutes for json files
	s3cmd -c $(S3_CFG) \
		modify --recursive \
		--add-header=Cache-Control:public,max-age=3600,must-revalidate \
		--remove-header=Expires \
		--exclude "*" --include "*.json" \
		--add-header=x-amz-meta-version:$(VERSION)-$(DEPLOY_TIME) \
		--mime-type="application/vnd.nrfcloud.meta.v1+json" \
		s3://$(AWS_BUCKET)/

# Helper

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

help: ## (default), display the list of make commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	rm -rf dist
