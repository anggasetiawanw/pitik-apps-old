// ignore_for_file: slash_for_doc_comments, constant_identifier_names

import 'dart:convert';
import 'package:engine/request/transport/body/xml.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class BodyBuilder {
  Map<String, dynamic> parameters = {};
  List<dynamic> parametersList = [];
  int _mediaType = PLAIN;

  static const FORM_ENCODED = 0;
  static const JSON = 1;
  static const MULTIPART = 2;
  static const XML = 3;
  static const PLAIN = 4;

  String _bodyFormAndPlain = "";
  bool isJsonObject = false;

  BodyBuilder(int mediaType) {
    _mediaType = mediaType;
  }

  String getMediaType() {
    return _mediaType == 0
        ? "FORM_ENCODED"
        : _mediaType == 1
            ? "JSON"
            : _mediaType == 2
                ? "MULTIPART"
                : _mediaType == 3
                    ? "XML"
                    : "PLAIN";
  }

  /// `addForText` is a function that takes in a `key` and a `value` and adds them
  /// to the `parameters` map
  ///
  /// Args:
  ///   key (String): The key of the parameter.
  ///   value (String): The value of the parameter.
  ///
  /// Returns:
  ///   The FormBodyBuilder object
  BodyBuilder addForText(String key, String value) {
    parameters[key] = value;
    return this;
  }

  /// Add a key-value pair to the parameters map, where the value is an integer.
  ///
  /// Args:
  ///   key (String): The key of the parameter.
  ///   value (int): The value of the parameter.
  ///
  /// Returns:
  ///   The FormBodyBuilder object
  BodyBuilder addForInt(String key, int value) {
    parameters[key] = value;
    return this;
  }

  /// Add a boolean value to the body.
  ///
  /// Args:
  ///   key (String): The key of the parameter.
  ///   value (bool): The value of the parameter.
  ///
  /// Returns:
  ///   The FormBodyBuilder object.
  BodyBuilder addForBool(String key, bool value) {
    parameters[key] = value;
    return this;
  }

  /// Add a double to the body.
  ///
  /// Args:
  ///   key (String): The key of the parameter.
  ///   value (double): The value of the parameter.
  ///
  /// Returns:
  ///   The FormBodyBuilder object.
  BodyBuilder addForDouble(String key, double value) {
    parameters[key] = value;
    return this;
  }

  /// `parameters = jsonData;`
  ///
  /// That's it
  ///
  /// Args:
  ///   jsonData (Map<String, dynamic>): The data to be converted to JSON.
  ///
  /// Returns:
  ///   The instance of the class.
  BodyBuilder toJson(Map<String, dynamic> jsonData) {
    parameters = jsonData;
    isJsonObject = true;
    return this;
  }

  /// > This function takes a map of strings and dynamic values and sets the
  /// parameters of the body builder to the map
  ///
  /// Args:
  ///   multipart (Map<String, dynamic>): A map of key-value pairs where the key
  /// is the name of the parameter and the value is the value of the parameter.
  ///
  /// Returns:
  ///   The current instance of the class.
  BodyBuilder toMultipart(Map<String, dynamic> multipart) {
    parameters = multipart;
    return this;
  }

  /// > This function takes a json string and converts it to a map
  ///
  /// Args:
  ///   jsonData (String): The JSON data to be sent to the server.
  ///
  /// Returns:
  ///   The instance of the class.
  BodyBuilder toJsonFromText(String jsonData) {
    if (jsonDecode(jsonData) is List) {
      parametersList = jsonDecode(jsonData);
    } else {
      parameters = jsonDecode(jsonData);
      isJsonObject = true;
    }

    return this;
  }

  /// > It takes a string as a parameter and assigns it to the _bodyFormAndPlain
  /// variable
  ///
  /// Args:
  ///   body (String): The body of the request.
  ///
  /// Returns:
  ///   The instance of the class.
  BodyBuilder toPlain(String body) {
    _bodyFormAndPlain = body;
    return this;
  }

  /// > It takes a map of strings and returns a bodybuilder with the form data
  /// encoded in the body
  ///
  /// Args:
  ///   formData (Map<String, String>): A map of key-value pairs that will be
  /// encoded as form data.
  ///
  /// Returns:
  ///   The instance of the class.
  BodyBuilder toFormEncoded(Map<String, String> formData) {
    for (String key in formData.keys) {
      _bodyFormAndPlain += "$key=${formData[key]}&";
    }

    return this;
  }

  /// > It takes an XmlBody object, converts it to a map, and then iterates over
  /// the map, adding the key and value to the _bodyFormAndPlain variable
  ///
  /// Args:
  ///   xml (XmlBody): The XmlBody object that contains the parameters to be
  /// converted to XML.
  ///
  /// Returns:
  ///   The XmlBodyBuilder object.
  BodyBuilder toXml(XmlBody xml) {
    Map<String, dynamic> xmlBody = xml.getParams();
    for (String key in xmlBody.keys) {
      dynamic value = xmlBody[key];

      _bodyFormAndPlain += "<$key>";
      if (value is XmlBody) {
        XmlBody innerXml = value;
        toXml(innerXml);
      } else {
        _bodyFormAndPlain += value;
      }

      _bodyFormAndPlain += "</$key>";
    }

    return this;
  }

  /// It returns the parameters
  ///
  /// Returns:
  ///   A map of the parameters.
  Map<String, dynamic> get() {
    return parameters;
  }

  @override
  String toString() {
    if (_mediaType == FORM_ENCODED || _mediaType == PLAIN || _mediaType == XML) {
      return _bodyFormAndPlain;
    } else if (_mediaType == JSON) {
      if (isJsonObject) {
        return json.encode(parameters);
      } else {
        return json.encode(parametersList);
      }
    } else {
      return "not supported body";
    }
  }
}
