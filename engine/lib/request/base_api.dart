// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names

import 'package:reflectable/reflectable.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

const Rest = BaseApi();

class BaseApi extends Reflectable {
  const BaseApi() : super(invokingCapability, declarationsCapability, typeRelationsCapability, metadataCapability);
}
