
import 'engine_library.dart';
import 'internal_app/media_upload_model.dart';
import 'product_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class GoodReceipt {

    String? receivedDate;
    String? remarks;

    @IsChildren()
    List<Product?> details;

    @IsChildren()
    List<MediaUploadModel?> photos;

    GoodReceipt({this.receivedDate, this.remarks, this.details = const [], this.photos = const []});

    static GoodReceipt toResponseModel(Map<String, dynamic> map) {
        return GoodReceipt(
            receivedDate: map['receivedDate'],
            remarks: map['remarks'],
            details: Mapper.children<Product>(map['details']),
            photos: Mapper.children<MediaUploadModel>(map['photos'])
        );
    }
}