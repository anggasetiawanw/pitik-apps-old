/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */


import 'package:reflectable/reflectable.dart';

const Rest = BaseApi();

class BaseApi extends Reflectable {
    const BaseApi() : super(invokingCapability, declarationsCapability, typeRelationsCapability, metadataCapability);
}