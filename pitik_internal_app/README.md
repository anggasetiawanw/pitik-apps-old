# Internal App Project

An app to help downstream teams

## Tech Writter

- Angga Setiawan Wahyudin
- Dicky Maulana Akbar
- Robertus Mahardhi Kuncoro

## Getting Started

Currently we are facing issues in terms of data quality that is being input through gform when our team doing visits to new/existing customers. The bad inputs lead into inaccurate analysis and can lead us into the wrong direction and decision making process. Therefore, we need to build a simple tool to minimize the bad data input so that we can perform better analysis.

## How to Use

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/Pitik-Digital-Indonesia/Mobile-Flutter.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 3:**

This project uses `annotation` and `reflect` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or

```
make gen
```

## Boilerplate Features:

Phase 1 :

- Splash
- Google Login
- Customer Module
- GetX State Management
- Firebase Crashlytic
- Firebase Remote Config
- Flavor (Build Variant with 2 mode `Production` and `Development`)
- Get Location
- Local Database
- Dependency Injection
- Engine
- Http
- Logging

Phase 2:

- Multirole login
- Dashboard
- Purchase Module
- Good Receive Module
- Sales Order Module
- Delivery Module
- Internal Transfer Module
- Stock Opname Module
- Manufacture Module
- Stock Disposal Module
- Enchant Get Location
- Model Generator

### Up-Coming Features:

- [TBD]

### Libraries & Tools Used

- [Getx State Management](https://pub.dev/packages/get)
- [Sqlite](https://pub.dev/packages/sqflite)
- [Flavour](https://pub.dev/packages/flutter_flavorizr)
- [Http](https://pub.dev/packages/http)
- [Logging](https://pub.dev/packages/chucker_flutter)
- [Reflectable](https://pub.dev/packages/reflectable/install)
- [Google Sign In](https://pub.dev/packages/google_sign_in)
- ... and more (you can see in [pubspec.yaml](https://github.com/Pitik-Digital-Indonesia/Mobile-Flutter/blob/main/pubspec.yaml))

### Makefile Command

for command easilier

| Command           | Description                                  |
| ----------------- | -------------------------------------------- |
| `gen`             | Generate files Reflect                       |
| `run-dev`         | Running Debug with dev configuration         |
| `run-prod`        | Running Debug with production configuration  |
| `build-dev`       | Build aab file with debug configuration      |
| `build-prod`      | Build aab file with production configuration |
| `apk-dev`         | Build apk file with debug configuration      |
| `apk-prod`        | Build apk file with production configuration |
| `gen-flavor`      | FGenerate New flavor configuration           |
| `model-generator` | Running Model Generator                      |

### Folder Structure

Here is the core folder structure which flutter provides.

```
mobile-flutter/
|- android
|- build
|- images
|- font
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- component/
|- engine/
|- ui/
|- app.dart
|- core.dart
|- flavors.dart
|- main_dev.dart
|- main_prod.dart
|- main.dart
|- main.reflectable.dart //Generated
|- model_generator_main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- component — Contains the common widgets for this applications. For example, Button, TextField etc.
2- engine -
3- app.dart -
4- core.dart -
5- flavors.dart -
6- main_dev.dart -
7- main_prod.dart -
8- main.dart -
9- main.reflectable.dart -
10- model_generator_main.dart -
```

### Component

Contains the common widgets that are shared across multiple screens. For example, Button, TextField etc.

```
widgets/
|- controller/
|- listener/
|- button_fill.dart
```

### Engine

Contains the all the business logic of the application, it represents the data layer, application layer(repository). It is sub-divided into sixth directories `dao`, `model`, `offline_capabillity`, `request`, `transport`, and `util`

```
engine/
|- dao/
    |- annotation/
    |- impl/
    |- base_entity.dart

|- model/
    |- error/
    |- response/
    |- auth_model.dart

|- offlinecapability
    |- offline_body/
    |- offline.dart

|- request
    |- annotation/
    |- api.dart
    |- service.dart

|- transport
    |- body/
    |- interface/
    |- transporter.dart

|- util
    |- interface/
    |- mapper/
    |- convert.dart

|- get_x_creator.dart
```

### UI

This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen have bussines logic specific will be placed in `*_controller.dart` as shown in the example below:

```
ui/
|- login/
    |- login_screen.dart
    |- login_controller.dart

|- home/
    |- beranda/
        |- beranda_screen.dart
        |- beranda_controller.dart
```

### Main

This is the starting point of the application.

```dart
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'engine/dao/db_lite.dart';
import 'engine/util/firebase_config.dart';
import 'flavors.dart';
import 'package:mobile_flutter/main.reflectable.dart';

void main() async{
    F.appFlavor = Flavor.PROD;
    ChuckerFlutter.showOnRelease = false;
    initializeReflectable();
    await initPlatformState();
    runApp(App());
}

Future<void> initPlatformState() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DBLite().database;
    await Firebase.initializeApp();

    FirebaseConfig.setupCrashlytics();
    FirebaseConfig.setupRemoteConfig();

    await FirebaseConfig.setupCloudMessaging();
}
```

### App

This in the app initialize for running the apps. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

```dart
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_flutter/ui/home/beranda_activity/beranda_controller.dart';

import 'engine/util/globar_var.dart';
import 'engine/util/internet_connection.dart';
import 'engine/util/route.dart';

class App extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        StreamInternetConnection.init();
        Constant.setContext(context);
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Montserrat_Medium'),
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            initialRoute: AppRoutes.initial,
            initialBinding: BerandaBindings(context: context),
            getPages: AppRoutes.page,
        );
    }
}
```

## Conclusion

We are Mobile Developer at pitik
