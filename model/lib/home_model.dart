// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import 'coop_model.dart';
import 'farm_model.dart';
import 'organization_model.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class Home{

    @IsChild()
    Farm? farm;

    @IsChild()
    Organization? organization;

    @IsChildren()
    List<Coop?>? coops;

    Home({this.organization, this.farm, this.coops});

    static Home toResponseModel(Map<String, dynamic> map) {
        return Home(
            farm: Mapper.child<Farm>(map['farm']),
            organization: Mapper.child<Organization>(map['organization']),
            coops: Mapper.children<Coop>(map['coops']),
        );
    }
}