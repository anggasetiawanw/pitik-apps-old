import '../engine_library.dart';
import '../product_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ProductsResponse {

    @IsChildren()
    List<Product?> data;

    ProductsResponse({this.data = const []});

    static ProductsResponse toResponseModel(Map<String, dynamic> map) {
        return ProductsResponse(
            data: Mapper.children<Product>(map['data'])
        );
    }
}