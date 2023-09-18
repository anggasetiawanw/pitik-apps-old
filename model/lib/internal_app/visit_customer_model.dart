import 'package:model/engine_library.dart';
import 'package:model/internal_app/order_categories_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/sales_person_model.dart';

/**
 * @author [Angga Setiawan Wahyudin]
 * @email [angga.setiawan@pitik.id]
 * @create date 2023-02-20 09:25:38
 * @modify date 2023-02-20 09:25:38
 * @desc [description]
 */

@SetupModel
class VisitCustomer {
    String? id;

    @IsChild()
    SalesPerson? salesperson;

    String? createdDate;
    String? leadStatus;
    String? prospect;
    bool? orderIssue;
    
    @IsChildren()
    List<OrderIssueCategories?>? orderIssueCategories;
    
    String? remarks;
    double? latitude;
    double? longitude;

    @IsChildren()
    List<Products?>? products;

    VisitCustomer({this.id, this.salesperson, this.createdDate, this.leadStatus, this.prospect, this.products, this.latitude,
                   this.longitude,this.orderIssue,this.remarks, this.orderIssueCategories});

    static VisitCustomer toResponseModel(Map<String, dynamic> map) {
        return VisitCustomer(
            id: map['id'],
            salesperson: Mapper.child<SalesPerson>(map['salesperson']),
            createdDate: map['createdDate'],
            leadStatus: map['leadStatus'],
            prospect: map['prospect'],
            products: Mapper.children<Products>(map['products']),
            orderIssueCategories: Mapper.children<OrderIssueCategories>(map['orderIssueCategories']),
            latitude: map["latitude"],
            longitude: map["longitude"],
            orderIssue: map["orderIssue"],
            remarks: map['remarks']
        );
    }
}
