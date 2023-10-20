### Makefile for internal app ###

SHELL := /bin/bash

gen: ## Generate files Reflect
	flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

gen2: ## Generate files Reflect
	flutter clean && flutter pub get && flutter pub run build_runner build

gen-packages: ## Generate files Reflect with Packages
	flutter clean && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs

run-dev: ##Running Debug with dev configuration
	flutter run --flavor dev -t lib/main_dev.dart

run-prod: ##Running Debug with production configuration
	flutter run --flavor prod -t lib/main_prod.dart

build-dev: ## Build aab file with debug configuration
	flutter build appbundle --flavor dev -t lib/main_dev.dart

build-prod: ## Build aab file with production configuration
	flutter build appbundle --flavor prod -t lib/main_prod.dart

apk-dev: ## Build aab file with debug configuration
	flutter build apk --flavor dev -t lib/main_dev.dart

apk-prod: ## Build aab file with production configuration
	flutter build apk --flavor prod -t lib/main_prod.dart

gen-flavor: ## Generate New flavor configuration note : app.dart main_dev.dart main_prod.dart and flavor.dart reversal with ctrl+z or command+z
	flutter pub run flutter_flavorizr

model-generator: ##Running Model Generator
	flutter run --flavor dev -t lib/model_generator_main.dart
lints:
	flutter analyze --no-fatal-warnings --no-fatal-infos

sb-build-dev: ## Build Shorebird Dev
	shorebird release android --flavor dev -t lib/main_dev.dart

sb-build-prod: ## Build Shorebird Production
	shorebird release android --flavor prod	-t lib/main_prod.dart

sb-patch-dev: ## Push Patch Shorebird Dev
	shorebird patch android --flavor dev -t lib/main_dev.dart

sb-patch-prod: ## Push Patch Shorebird Production
	shorebird patch android --flavor prod -t lib/main_prod.dart

build-dev-ios: ## Build aab file with debug configuration
	flutter build ipa --flavor dev -t lib/main_dev.dart

build-prod-ios: ## Build aab file with production configuration
	flutter build ipa --flavor prod -t lib/main_prod.dart