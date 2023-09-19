// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'dart:convert';

import 'package:reflectable/mirrors.dart';

import '../../model/base_model.dart';
import '../mirror_feature.dart';
import 'annotation/is_child.dart';
import 'annotation/is_children.dart';
import 'annotation/to_snake_case_key.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class Mapper {
    /// It takes a Dart object and returns a JSON string
    ///
    /// Args:
    ///   persistanceSource: The object that you want to convert to JSON.
    ///
    /// Returns:
    ///   A string representation of the object.
    static String? asJsonString(persistanceSource) {
        if (persistanceSource != null) {
            String result = '{';

            if (persistanceSource is List) {
                result = '[';
                for (var element in persistanceSource) {
                    result += asJsonString(element) ?? 'null';
                    result += ', ';
                }

                if (persistanceSource.isNotEmpty) {
                    result = result.substring(0, result.length - 2);
                }

                result += ']';
                return result;
            } else {
                InstanceMirror instanceMirror = SetupModel.reflect(persistanceSource);

                for (var v in instanceMirror.type.declarations.values) {
                    if (v is VariableMirror) {
                        String resultToSnakeCase = "";
                        bool isChild = false;
                        bool isChildren = false;

                        if (MirrorFeature.isAnnotationPresent(v, ToSnakeCaseKey)) {
                            String fieldName = v.simpleName;
                            resultToSnakeCase = fieldName[0];

                            for (int i = 1; i < fieldName.length; i++) {
                                String firstLetter = fieldName[i].trimLeft().substring(0, 1);
                                if (firstLetter.toUpperCase() == fieldName[i].substring(0, 1)) {
                                    resultToSnakeCase += '_${fieldName[i].toLowerCase()}';
                                } else {
                                    resultToSnakeCase += fieldName[i];
                                }
                            }
                        } else if (MirrorFeature.isAnnotationPresent(v, IsChild)) {
                            isChild = true;
                        } else if (MirrorFeature.isAnnotationPresent(v, IsChildren)) {
                            isChildren = true;
                        }

                        InstanceMirror instanceMirror = SetupModel.reflect(persistanceSource);
                        dynamic fieldValue = instanceMirror.invokeGetter(v.simpleName);
                        dynamic dataType = fieldValue.runtimeType;

                        if(fieldValue != null) {
                            if (resultToSnakeCase != "") {
                                if (isChild || isChildren) {
                                    result += '"$resultToSnakeCase": ${asJsonString(fieldValue)}, ';
                                } else {
                                    if (dataType == String) {
                                        result += '"$resultToSnakeCase": "$fieldValue", ';
                                    } else {
                                        result += '"$resultToSnakeCase": $fieldValue, ';
                                    }
                                }
                            } else if (isChild || isChildren) {
                                result += '"${v.simpleName}": ${asJsonString(fieldValue)}, ';
                            } else {
                                if (dataType == String) {
                                    result += '"${v.simpleName}": "$fieldValue", ';
                                } else {
                                    result += '"${v.simpleName}": $fieldValue, ';
                                }
                            }
                        }

                    }
                }

                result = result.substring(0, result.length - 2);
                return '$result}';
            }
        }

        return null;
    }

    /// It takes a JSON string or a Map and converts it to a model
    ///
    /// Args:
    ///   data (dynamic): The data that you want to convert to a model.
    ///   as (dynamic): The type of the object you want to convert to.
    ///
    /// Returns:
    ///   A dynamic object.
    static dynamic childPersistance(dynamic data, dynamic as) {
        if (data is Map) {
            ClassMirror classMirror = SetupModel.reflectType(as) as ClassMirror;
            return classMirror.invoke("toResponseModel", [data]);
        } else {
            Map<String, dynamic> map = json.decode(data);
            ClassMirror classMirror = SetupModel.reflectType(as) as ClassMirror;

            return classMirror.invoke("toResponseModel", [map]);
        }
    }

    /// The function `childrenPersistance` takes in data and a class type, and
    /// returns a list of converted values based on the data type.
    ///
    /// Args:
    ///   data (dynamic): The `data` parameter is a dynamic variable that can hold
    /// any type of data. It is used to pass the input data to the function.
    ///   as (dynamic): The parameter "as" is a type parameter that represents the
    /// class type that you want to convert the data into. It is used to create an
    /// instance of the class and invoke the "toResponseModel" method on that
    /// instance.
    ///
    /// Returns:
    ///   a List.
    static dynamic childrenPersistance(dynamic data, dynamic as) {
        List result = [];

        if (data != null) {
            if (data is List) {
                for (var value in data) {
                    if (value is String) {
                        result.add(value.toString());
                    } else if (value is int || value is double || value is bool) {
                        result.add(value);
                    } else {
                        ClassMirror classMirror = SetupModel.reflectType(as) as ClassMirror;
                        result.add(classMirror.invoke("toResponseModel", [value]));
                    }
                }
            } else {
                List<dynamic> listMap = jsonDecode(data);
                for (var value in listMap) {
                    if (value.length > 0) {
                        ClassMirror classMirror = SetupModel.reflectType(as) as ClassMirror;
                        result.add(classMirror.invoke("toResponseModel", [value]));
                    } else {
                        result.add(null);
                    }
                }
            }
        }

        return result;
    }

    /// It takes a JSON string or a Map and returns an object of type T
    ///
    /// Args:
    ///   data (dynamic): The data that you want to convert to a model.
    ///
    /// Returns:
    ///   A new instance of the class T.
    static T? child<T>(dynamic data) {
        if (data != null) {
            if (data is Map) {
                if (data.isEmpty) {
                    return null;
                } else {
                    ClassMirror classMirror = SetupModel.reflectType(T) as ClassMirror;
                    return classMirror.invoke("toResponseModel", [data]) as T;
                }
            } else {
                Map<String, dynamic> map = json.decode(data);
                ClassMirror classMirror = SetupModel.reflectType(T) as ClassMirror;

                return classMirror.invoke("toResponseModel", [map]) as T;
            }
        } else {
            return null;
        }
    }

    /// It takes a generic type and a dynamic data, and returns a list of the
    /// generic type
    ///
    /// Args:
    ///   data (dynamic): The data to be converted to a list of objects.
    ///
    /// Returns:
    ///   A list of objects of type T.
    static List<T?> children<T>(dynamic data) {
        List<T?> result = [];

        if (data != null) {
            if (data is List) {
                for (var value in data) {
                    if (value is String) {
                        result.add(value.toString() as T);
                    } else if (value is int || value is double || value is bool) {
                        result.add(value as T);
                    } else {
                        ClassMirror classMirror = SetupModel.reflectType(T) as ClassMirror;
                        result.add(classMirror.invoke("toResponseModel", [value]) as T);
                    }
                }
            } else {
                List<dynamic> listMap = jsonDecode(data);
                for (var value in listMap) {
                    if (value.length > 0) {
                        ClassMirror classMirror = SetupModel.reflectType(T) as ClassMirror;
                        result.add(classMirror.invoke("toResponseModel", [value]) as T);
                    } else {
                        result.add(null);
                    }
                }
            }
        }

        return result;
    }
}
