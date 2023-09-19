
import 'package:model/engine_library.dart';
import 'package:model/internal_app/place_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';
import 'package:model/internal_app/visit_customer_model.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-08 10:50:33
/// @modify date 2023-02-08 10:50:33
/// @desc [Model For Customer]

@SetupModel
class Customer {
    String? id;
    String? businessName;
    String? businessType;
    String? ownerName;
    String? phoneNumber;
    String? salespersonId;
    String? plusCode;
    int? provinceId;
    int? cityId;
    int? districtId;
    String? supplier;
    String? supplierDetail;
    bool? isArchived;
    double? longitude;
    double? latitude;
    String? name;
    String? operationUnitName;

    @IsChild()
    Location? city;

    @IsChild()
    Location? district;

    @IsChild()
    Location? province;

    @IsChild()
    SalesPerson? salesperson;

    @IsChild()
    VisitCustomer? latestVisit;

    @IsChildren()
    List<Products?>? products;

    Customer({this.id, this.businessName, this.businessType, this.phoneNumber, this.salespersonId, this.plusCode, this.provinceId, this.cityId, this.city,
              this.districtId, this.district, this.supplier, this.supplierDetail, this.salesperson, this.latestVisit, this.isArchived, this.latitude, this.longitude,
              this.province, this.ownerName, this.products, this.name, this.operationUnitName});

    static Customer toResponseModel(Map<String, dynamic> map) {
        return Customer(
            id: map['id'],
            businessName: map['businessName'],
            businessType: map['businessType'],
            phoneNumber: map['phoneNumber'],
            plusCode: map['plusCode'],
            provinceId: map['provinceId'],
            cityId: map['cityId'],
            districtId: map['districtId'],
            salespersonId: map['salespersonId'],
            supplier: map['supplier'],
            supplierDetail: map['supplierDetail'],
            salesperson: Mapper.child<SalesPerson>(map['salesperson']),
            latestVisit: Mapper.child<VisitCustomer>(map['latestVisit']),
            city: Mapper.child<Location>(map["city"]),
            district: Mapper.child<Location>(map["district"]),
            province: Mapper.child<Location>(map["province"]),
            isArchived: map["isArchived"],
            latitude: map["latitude"],
            longitude: map["longitude"],
            ownerName: map["ownerName"],
            products: Mapper.children<Products>(map['products']),
            name: map["name"],
            operationUnitName: map["operationUnitName"],
        );
    }
}
