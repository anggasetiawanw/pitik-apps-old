// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ExpandableController extends GetxController {

    String tag;
    ExpandableController({required this.tag});

    var expanded = false.obs;

    void expand() {
        expanded.value = true;
        refresh();
    }
    void collapse() => expanded.value = false;
}

class ExpandableBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ExpandableController>(() => ExpandableController(tag: ""));
    }
}