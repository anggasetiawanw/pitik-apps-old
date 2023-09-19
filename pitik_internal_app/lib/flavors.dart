

// ignore_for_file: constant_identifier_names

import 'package:global_variable/global_variable.dart';

enum Flavor {
    PROD,
    DEV,
}

class F {
    static Flavor? appFlavor;

    static String get name => appFlavor?.name ?? '';

    static String get title {
        switch (appFlavor) {
            case Flavor.PROD:
                return AppStrings.APP_NAME;
            case Flavor.DEV:
                return AppStrings.APP_NAME;
            default:
                return 'title';
        }
    }

    static  String get uri {
        switch (appFlavor) {
            case Flavor.PROD:
                return AppStrings.BASE_URL_PROD;
            case Flavor.DEV:
                return AppStrings.BASE_URL_STAGING;
            default:
                return AppStrings.BASE_URL_PROD;
        }
    }

    static String get crashlyticsNote {
        switch (appFlavor) {
            case Flavor.PROD:
                return AppStrings.PRODUCTION;
            case Flavor.DEV:
                return AppStrings.STAGING;
            default:
                return AppStrings.PRODUCTION;
        }
    }

    static String get webCert {
        switch (appFlavor) {
            case Flavor.PROD:
                return AppStrings.WEB_CERT_PRODUCTION;
            case Flavor.DEV:
                return AppStrings.WEB_CERT_STAGING;
            default:
                return AppStrings.WEB_CERT_PRODUCTION;
        }
    }
}