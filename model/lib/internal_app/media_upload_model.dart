
import 'package:model/engine_library.dart';

@SetupModel
class MediaUploadModel {
    String?  id;
    String? url;

    MediaUploadModel({this.id, this.url});

    static MediaUploadModel toResponseModel(Map<String, dynamic> map) {
        return MediaUploadModel(
            id: map['id'],
            url: map['url']
        );
    }
}