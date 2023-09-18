import 'package:model/engine_library.dart';
import 'package:model/internal_app/media_upload_model.dart';
@SetupModel
class MediaUploadResponse {
    int? code;
    MediaUploadModel? data;

    MediaUploadResponse({this.code, required this.data});

    static MediaUploadResponse toResponseModel(Map<String, dynamic> map) {
        return MediaUploadResponse(
            code: map['code'],
            data: Mapper.child<MediaUploadModel>(map['data'])
        );
    }
}