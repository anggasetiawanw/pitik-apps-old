import 'package:flutter/cupertino.dart';
import 'package:reflectable/reflectable.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

const SetupEntity = BaseEntity();

class BaseEntity extends Reflectable {
    const BaseEntity() : super(invokingCapability,
                               superclassQuantifyCapability,
                               declarationsCapability,
                               typeRelationsCapability,
                               metadataCapability,
                               newInstanceCapability,
                               instanceInvokeCapability,
                               typeCapability);

    dynamic toModelEntity(Map<String, dynamic> map) {
        debugPrint('Persistance Type not contains function => toModel. Please extends to BaseEntity and add override "toModel"');
    }
}