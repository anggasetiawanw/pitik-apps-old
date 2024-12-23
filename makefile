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
	@melos proc-ppl && make -C pitik_ppl_app/ sb-build-dev
bundle-dev-ppl-ios:
	@melos bundle-dev-ppl-ios

#for build patch staging
patch-dev-internal-and:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos patch-dev-internal-and
patch-dev--internalios:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos patch-dev-internal-ios
patch-dev-connect-and:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos patch-dev-connect-and
patch-dev-connect-ios:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos patch-dev-connect-ios
patch-dev-ppl-and:
	@melos proc-ppl && make -C pitik_ppl_app/ sb-patch-dev
patch-dev-ppl-ios:
	@melos patch-dev-ppl-ios

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
	@melos proc-ppl && make -C pitik_ppl_app/ sb-build-prod
bundle-prod-ppl-ios:
	@melos pub-get-ppl && @melos force_build_ppl && @melos generate-assets  && @melos bundle-prod-ppl-ios

#for build patch Production
patch-prod-internal-and:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos patch-prod-internal-and
patch-prod--internalios:
	@melos pub-get-internal && @melos force_build_internal && @melos generate-assets  && @melos patch-prod-internal-ios
patch-prod-connect-and:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos patch-prod-connect-and
patch-prod-connect-ios:
	@melos pub-get-connect && @melos force_build_connect && @melos generate-assets  && @melos patch-prod-connect-ios
patch-prod-ppl-and:
	make -C pitik_ppl_app/ sb-patch-prod
patch-prod-ppl-ios:
	@melos patch-prod-ppl-ios

# for generate assets
generate-assets:
	@melos generate-assets