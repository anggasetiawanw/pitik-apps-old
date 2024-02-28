// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'package:reflectable/reflectable.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

// ignore: constant_identifier_names
const SetupEntity = BaseEntity();

class BaseEntity extends Reflectable {
  const BaseEntity() : super(invokingCapability, superclassQuantifyCapability, declarationsCapability, typeRelationsCapability, metadataCapability, newInstanceCapability, instanceInvokeCapability, typeCapability);

  dynamic toModelEntity(Map<String, dynamic> map) {
    debugPrint('Persistance Type not contains function => toModel. Please extends to BaseEntity and add override "toModel"');
  }
}
