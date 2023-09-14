### Makefile for internal app ###

SHELL := /bin/bash

gen: ## Generate files Reflect
	flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
