

import 'package:model/engine_library.dart';

@SetupModel
class ModuleModel {

    List<String?> downstreamApp;

    ModuleModel({this.downstreamApp = const[]});

    static ModuleModel toResponseModel(Map<String, dynamic> map) {
        return ModuleModel(
            downstreamApp: Mapper.children<String>(map['downstreamApp'])
        );
    }
}