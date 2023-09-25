// ignore_for_file: constant_identifier_names

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
                return 'Pitik Connect';
            case Flavor.DEV:
                return 'Pitik Connect Staging';
            default:
                return 'title';
        }
    }

    static  String get uri {
        switch (appFlavor) {
            case Flavor.PROD:
                return 'https://api.pitik.id/';
            case Flavor.DEV:
                return 'https://api-dev.pitik.id/';
            default:
                return 'https://api-dev.pitik.id/';
        }
    }

    static String get crashlyticsNote {
        switch (appFlavor) {
            case Flavor.PROD:
                return 'PRODUCTION';
            case Flavor.DEV:
                return 'STAGING';
            default:
                return 'STAGING';
        }
    }

    static String get webCert {
        switch (appFlavor) {
            case Flavor.PROD:
                return 'BBvxd2h6r3LorufuwBFL4OQBO9xqL1su5UiGwYog1OzZl37l0-pUH3eefV1wxorVTHvUhnps8TIluNmTHjkugdU';
            case Flavor.DEV:
                return 'BGCGePCYo6SzEDbUGu2O0X-Oc83BHsikB-VAC7CjZZBtOKvNCWmKQxXbvWbLa6ukkUuhyB_ru7Drgj1lYdmal1Q';
            default:
                return 'BGCGePCYo6SzEDbUGu2O0X-Oc83BHsikB-VAC7CjZZBtOKvNCWmKQxXbvWbLa6ukkUuhyB_ru7Drgj1lYdmal1Q';
        }
    }

    static String get tokenMixpanel {
        switch (appFlavor) {
            case Flavor.PROD:
                return 'a2d18b06e65530177065d53a2d6e9ebb';
            case Flavor.DEV:
                return '5adcb071601ebc56ae75ce6238d67595';
            default:
                return '5adcb071601ebc56ae75ce6238d67595';
        }
    }
}