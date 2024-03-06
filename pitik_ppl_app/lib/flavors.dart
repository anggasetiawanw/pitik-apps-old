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
        return 'Pitik - Smart Broiler Farming';
      case Flavor.DEV:
        return 'Pitik - Smart Broiler Farming (Staging)';
      default:
        return 'title';
    }
  }

  static String get uri {
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
        return '6193f0deb30c1cde5326ee6cb3a402eb';
      case Flavor.DEV:
        return '5c4078b77ef73b0bc10c277cba6512eb';
      default:
        return '5c4078b77ef73b0bc10c277cba6512eb';
    }
  }

  static String get appStoreId {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'com.pitik.pitik';
      case Flavor.DEV:
        return 'com.pitik.pitik';
      default:
        return '';
    }
  }

  static String get androidAppBundleId {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'id.pitik.mobile';
      case Flavor.DEV:
        return 'id.pitik.mobile';
      default:
        return 'id.pitik.mobile';
    }
  }
}
