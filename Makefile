.DEFAULT_GOAL := help
.PHONY: help deploy

# Build the documents

dist/index.json: scripts/generate-index.js
	@mkdir -p $(dir $@)
	node $< > $@

# Build the API docs

dist/swagger-api.yaml: docs/swagger-api.json swagger/swagger-codegen-cli.jar
	mkdir -p $(dir $@)
	cp $< swagger
	cp ./node_modules/@nrfcloud/models/dist/model/schema/*.json swagger
	java -jar swagger/swagger-codegen-cli.jar generate -l swagger-yaml -i swagger/swagger-api.json -o swagger
	cp swagger/swagger.yaml $@

swagger/swagger-codegen-cli.jar:
	mkdir -p $(dir $@)
	wget http://central.maven.org/maven2/io/swagger/swagger-codegen-cli/2.2.3/swagger-codegen-cli-2.2.3.jar -O $@

# Deploy

AWS_BUCKET ?= meta.nrfcloud.com
AWS_DEFAULT_REGION ?= us-east-1

deploy: dist/index.json dist/swagger-api.yaml ## Deploy to AWS S3
	@make guard-AWS_ACCESS_KEY_ID
	@make guard-AWS_SECRET_ACCESS_KEY

	npm test

	$(eval VERSION ?= $(shell /usr/bin/env node -e "console.log(require('./package.json').version);"))
	$(eval DEPLOY_TIME ?= $(shell date +%s))

	# Create bucket if not exists
	@if [[ `s3cmd ls | grep s3://$(AWS_BUCKET) | wc -l` -eq 1 ]]; then \
		echo "Bucket exists"; \
	else \
		s3cmd mb s3://$(AWS_BUCKET); \
		s3cmd ws-create s3://$(AWS_BUCKET)/ --ws-index=index.json --ws-error=404.html; \
	fi

	# Upload
	s3cmd \
		sync -P -M --no-mime-magic --delete-removed ./dist/ s3://$(AWS_BUCKET)/

	# Expires 60 minutes for json files
	s3cmd modify --recursive \
		--add-header=Cache-Control:public,max-age=3600,must-revalidate \
		--remove-header=Expires \
		--exclude "*" --include "*.json" \
		--add-header=x-amz-meta-version:$(VERSION)-$(DEPLOY_TIME) \
		--mime-type="application/vnd.nrfcloud.meta.v2+json" \
		s3://$(AWS_BUCKET)/

	# Expires 24 hours for yaml files
	s3cmd modify --recursive \
		--add-header=Cache-Control:public,max-age=86400 \
		--remove-header=Expires \
		--exclude "*" --include "*.yaml" \
		--add-header=x-amz-meta-version:$(VERSION)-$(DEPLOY_TIME) \
		--mime-type="text/vnd.yaml" \
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
