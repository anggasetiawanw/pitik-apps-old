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
    runApp(const ModelGeneratorMain());
    ModelGenerator().build(['tes.json']);
}

class ModelGeneratorMain extends StatelessWidget {
    const ModelGeneratorMain({super.key});

    @override
    Widget build(BuildContext context) {
        return const MaterialApp();
    }
}