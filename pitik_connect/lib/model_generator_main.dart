import 'package:engine/model_generator.dart';
import 'package:flutter/material.dart';

import 'flavors.dart';
import 'main.reflectable.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

void main() {
    F.appFlavor = Flavor.DEV;
    initializeReflectable();
    runApp(ModelGeneratorMain());
    ModelGenerator().build(['smart_scale_response.json']);
}

class ModelGeneratorMain extends StatelessWidget {
    ModelGeneratorMain({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp();
    }
}