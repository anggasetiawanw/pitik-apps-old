# ### Makefile for Pitik Mobile Project ###

SHELL := /bin/bash

pub-sync: ## Generate files Reflect
	@melos bootstrap

melos-clean: ## Generate files Reflect
	@melos clean

#for build and generate file necessary for apps
build-all:
	@melos force-build-all
build-internal:
	@melos force-build-internal
build-connect:
	@melos force-build-connect
build-ppl:
	@melos force-build-ppl
gen-assets:
	@melos generate-assets

#for format document using standart code and fixing some issue code for better code
format-all:
	@melos format-all
format-commonpage:
	@melos format-commonpage
format-core:
	@melos format-core
format-components:
	@melos format-components
format-internal:
	@melos format-internal
format-connect:
	@melos format-connect
format-ppl:
	@melos format-ppl

#for analyze the app
analyze:
	@melos analyze

analyze-internal:
	@melos analyze-internal

analyze-connect:
	@melos analyze-connect

analyze-ppl:
	@melos analyze-ppl

#for build bundle staging
bundle-dev-internal-and:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos bundle-dev-internal-and
bundle-dev--internalios:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos bundle-dev-internal-ios
bundle-dev-connect-and:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos bundle-dev-connect-and
bundle-dev-connect-ios:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos bundle-dev-connect-ios
bundle-dev-ppl-and:
	@melos pub-get-ppl && @melos force_build_ppl && @melos generate-assets  && @melos bundle-dev-ppl-and
bundle-dev-ppl-ios:
	@melos pub-get-ppl && @melos force_build_ppl && @melos generate-assets  && @melos bundle-dev-ppl-ios

#for build bundle prod
bundle-prod-internal-and:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets && @melos bundle-prod-internal-and
bundle-prod--internalios:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos bundle-prod-internal-ios
bundle-prod-connect-and:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos bundle-prod-connect-and
bundle-prod-connect-ios:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos bundle-prod-connect-ios
bundle-prod-ppl-and:
	@melos pub-get-ppl && @melos force_build_ppl && @melos generate-assets  && @melos bundle-prod-ppl-and
bundle-prod-ppl-ios:
	@melos pub-get-ppl && @melos force_build_ppl && @melos generate-assets  && @melos bundle-prod-ppl-ios

# for generate assets
generate-assets:
	@melos generate-assets