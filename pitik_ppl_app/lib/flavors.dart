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
        return 'Pitik PPL App';
      case Flavor.DEV:
        return 'Pitik PPL App Staging';
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
        return 'BJqMSQmXZ290x5Ze7Ycv0KP9BTZ14qS8xHGCQ75xve3bh0PN4yln6tydC2aoYwwOgt9HLVrbCTTKqlZq9drOClk';
      case Flavor.DEV:
        return 'BCXA_tPlwgD65dqmis8W4DCaWLwVC0pV5sGPFEaDZzTQYE0_fFT0AI9qkqs1IiD55AJ3Py4BOFA1uo9VSMJkTQM';
      default:
        return 'BCXA_tPlwgD65dqmis8W4DCaWLwVC0pV5sGPFEaDZzTQYE0_fFT0AI9qkqs1IiD55AJ3Py4BOFA1uo9VSMJkTQM';
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