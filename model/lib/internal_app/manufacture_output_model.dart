
import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class ManufactureOutputModel {

    @IsChild()
    Products? input;
    @IsChildren()
    List<Products?>? output;

    ManufactureOutputModel({this.input, this.output});

    static ManufactureOutputModel toResponseModel(Map<String, dynamic> map) {
        return ManufactureOutputModel(
            input: Mapper.child<Products>(map['input']), 
            output: Mapper.children<Products>(map['output']),
        );
    }
}