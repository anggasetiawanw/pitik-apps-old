// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ModelGenerator {
  void build(List<String> jsonFileNames) {
    jsonFileNames.forEach((fileName) async {
      final manifestJson = await rootBundle.loadString('json/$fileName');
      Map<String, dynamic> myMap = json.decode(manifestJson);
      _generateObject(fileName.substring(0, fileName.indexOf(".")), myMap, true);

      print('MODEL GENERATOR IS DONE');
    });
  }

  void _generateArray(String fileName, List<dynamic> json, bool isResponseDirectory) {
    for (var element in json) {
      _generateObject(fileName, element, isResponseDirectory);
    }
  }

  void _generateObject(String classParentName, Map json, bool isResponseDirectory) async {
    String import = "import 'package:mobile_flutter/engine/util/mapper/mapper.dart';\n";
    if (isResponseDirectory) {
      import += "import '../base_model.dart';\n";
      import += "import '../../util/mapper/annotation/is_child.dart';\n";
      import += "import '../../util/mapper/annotation/is_children.dart';\n";
    } else {
      import += "import 'base_model.dart';\n";
      import += "import '../util/mapper/annotation/is_child.dart';\n";
      import += "import '../util/mapper/annotation/is_children.dart';\n";
    }

    String constructor = "\n    $classParentName({";
    String content = ""
        "\n"
        "/*\n"
        "  @author AKBAR <akbar.attijani@gmail.com>\n"
        " */\n"
        "\n"
        "@SetupModel\n"
        "class $classParentName {\n"
        "\n";

    String toResponseModel = ""
        "    static $classParentName toResponseModel(Map<String, dynamic> map) {\n"
        "        return $classParentName(\n";

    json.forEach((key, value) {
      if (value is Map) {
        String className = key.split(("->"))[1];
        String tagName = key.split(("->"))[0];

        if (isResponseDirectory) {
          import += "import '../${_toSnakeCase(className)}.dart';\n";
        } else {
          import += "import '${_toSnakeCase(className)}.dart';\n";
        }

        content += "\n    @IsChild()\n"
            "    $className? $tagName;\n";
        toResponseModel += "            $tagName: Mapper.child<$className>(map['$tagName']),\n";
        constructor += "this.$tagName, ";
        _generateObject(className, value, false);
      } else if (value is List) {
        String className = key.split(("->"))[1];
        String tagName = key.split(("->"))[0];

        content += "\n    @IsChildren()\n"
            "    List<$className?>? $tagName;\n";
        toResponseModel += "            $tagName: Mapper.children<$className>(map['$tagName']),\n";
        constructor += "this.$tagName, ";

        if (className != "String" && className != "bool" && className != "int" && className != "double") {
          if (isResponseDirectory) {
            import += "import '../${_toSnakeCase(className)}.dart';\n";
          } else {
            import += "import '${_toSnakeCase(className)}.dart';\n";
          }

          _generateArray(className, value, false);
        }
      } else {
        if (value.toString().contains("boolean")) {
          content += "    bool? $key;\n";
        } else if (value.toString().contains("integer")) {
          content += "    int? $key;\n";
        } else if (value.toString().contains("double")) {
          content += "    double? $key;\n";
        } else {
          content += "    String? $key;\n";
        }
        toResponseModel += "            $key: map['$key'],\n";
        constructor += "this.$key, ";
      }
    });

    constructor += "});\n";
    content += constructor;
    toResponseModel += "        );\n"
        "    }\n"
        "}\n";
    content += "\n$toResponseModel";
    import += content;

    Directory root = await getApplicationSupportDirectory();
    File file = File('${root.path}/model_generator/${isResponseDirectory ? 'response/' : ''}${_toSnakeCase(classParentName)}.dart');
    await file.create(recursive: true);
    file.writeAsString(import);
  }

  String _toSnakeCase(String text) {
    final exp = RegExp('(?<=[a-z])[A-Z]');
    return text.replaceAllMapped(exp, (m) => '_${m.group(0)}').toLowerCase();
  }
}
