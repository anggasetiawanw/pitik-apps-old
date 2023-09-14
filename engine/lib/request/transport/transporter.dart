// ignore_for_file: unnecessary_null_comparison, avoid_logging.log, invalid_return_type_for_catch_error
import 'dart:async';
import 'dart:developer' as logging;

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:http/http.dart' as http;
import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';
import 'package:get/get.dart' as gets;

import '../../model/base_model.dart';
import '../../model/string_model.dart';
import '../../util/mapper/mapper.dart';
import './body/body_builder.dart';
import './interface/response_listener.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class Transporter {
    Client client = Client();
    final _chuckerHttpClient = ChuckerHttpClient(http.Client());
    late ResponseListener transportListener;
    late String baseUrl;
    late String path;
    late BodyBuilder bodyBuilder;
    late int code;
    late String method;
    late BuildContext mContext;

    dynamic arrPacket;
    bool isMultipart = false;
    Map<String, String> headers = {};

    dynamic persistanceClass;
    dynamic persistanceClassError;

    /// It sets the context of the transporter to the build context of the widget.
    ///
    /// Args:
    ///   buildContext (BuildContext): The context of the activity or fragment.
    ///
    /// Returns:
    ///   The current instance of the class.
    Transporter context(BuildContext buildContext) {
        mContext = buildContext;
        return this;
    }

    /// This function sets the transportListener to the transportListener passed in
    /// as a parameter.
    ///
    /// Args:
    ///   transportListener (ResponseListener): The listener that will be notified
    /// when the response is received.
    ///
    /// Returns:
    ///   The object itself.
    Transporter listener(ResponseListener transportListener) {
        this.transportListener = transportListener;
        return this;
    }

    /// `url` is a function that takes a `String` as a parameter and returns a
    /// `Transporter` object
    ///
    /// Args:
    ///   baseUrl (String): The base URL of the API.
    ///
    /// Returns:
    ///   The object itself.
    Transporter url(String baseUrl) {
        this.baseUrl = baseUrl;
        return this;
    }

    /// This function takes a string and returns a Transporter object.
    ///
    /// Args:
    ///   path (String): The path to the file you want to upload.
    ///
    /// Returns:
    ///   The Transporter object itself.
    Transporter route(String path) {
        this.path = path;
        return this;
    }

    String getRoute() {
        return path;
    }

    /// > Adds a header to the request
    ///
    /// Args:
    ///   key (String): The key of the header.
    ///   value (String): The value of the header.
    ///
    /// Returns:
    ///   The Transporter object itself.
    Transporter header(String key, String value) {
        headers[key] = value;
        return this;
    }

    /// This function sets the bodyBuilder field to the bodyBuilder parameter and
    /// returns this.
    ///
    /// Args:
    ///   bodyBuilder (BodyBuilder): The BodyBuilder object that will be used to
    /// build the body of the request.
    ///
    /// Returns:
    ///   The Transporter object itself.
    Transporter body(BodyBuilder bodyBuilder) {
        this.bodyBuilder = bodyBuilder;
        return this;
    }

    /// It returns the object itself.
    ///
    /// Args:
    ///   arrPacket (dynamic): The array of bytes to be sent.
    ///
    /// Returns:
    ///   The object itself.
    Transporter packet(dynamic arrPacket) {
        this.arrPacket = arrPacket;
        return this;
    }

    /// This function returns a Transporter object with the code property set to the
    /// value of the code parameter.
    ///
    /// Args:
    ///   code (int): The code of the transporter.
    ///
    /// Returns:
    ///   The object itself.
    Transporter id(int code) {
        this.code = code;
        return this;
    }

    /// Setting the persistanceClass variable to the persistanceClass passed in.
    Transporter as(dynamic persistanceClass) {
        this.persistanceClass = persistanceClass;
        return this;
    }

    /// > If the persistanceClass is not null, then the persistanceClassError is set
    /// to the persistanceClass
    ///
    /// Args:
    ///   persistanceClass (dynamic): This is the class that you want to use to
    /// persist the data.
    ///
    /// Returns:
    ///   The object itself.
    Transporter error(dynamic persistanceClass) {
        persistanceClassError = persistanceClass;
        return this;
    }

    /// If the request is a multipart request, then return the transporter object.
    ///
    /// Returns:
    ///   The Transporter object itself.
    Transporter multipart() {
        isMultipart = true;
        return this;
    }

    /// This function sets the method to POST and returns the Transporter object.
    ///
    /// Returns:
    ///   The object itself.
    Transporter post() {
        method = 'POST';
        return this;
    }

    /// This function sets the method to PUT and returns the transporter object.
    ///
    /// Returns:
    ///   The Transporter object itself.
    Transporter put() {
        method = 'PUT';
        return this;
    }

    /// The patch() function sets the method to PATCH and returns the Transporter
    /// object.
    ///
    /// Returns:
    ///   The object itself.
    Transporter patch() {
        method = 'PATCH';
        return this;
    }

    /// This function returns a Transporter object with the method property set to
    /// 'GET'.
    ///
    /// Returns:
    ///   The object itself.
    Transporter get() {
        method = 'GET';
        return this;
    }

    /// If the method is not already set, set it to DELETE.
    ///
    /// Returns:
    ///   The object itself.
    Transporter delete() {
        method = 'DELETE';
        return this;
    }

    /// The above function is used to validate the data before sending the request.
    void validate() {
        if (baseUrl.isEmpty) {
            throw Exception('URL is empty');
        } else if (path.isEmpty) {
            throw Exception('Route is empty');
        } else if (transportListener == null) {
            throw Exception('Listener not set');
        } else if (method.isEmpty) {
            throw Exception('Method not set');
        } else if (mContext == null) {
            throw Exception('Context Null Pointer');
        }

        if (persistanceClass != null) {
            bool persistanceAs = false;
            var classMirrorPersistanceAs = SetupModel.reflectType(persistanceClass) as ClassMirror;

            for (var v in classMirrorPersistanceAs.declarations.values) {
                if (v.simpleName == "toResponseModel") {
                    persistanceAs = true;
                }
            }

            if (!persistanceAs) throw Exception('Persistance Class (As) not contains function static => toModel. Please add to function static "toModel"');
        }

        if (persistanceClassError != null) {
            bool persistanceError = false;
            var classMirrorPersistanceError = SetupModel.reflectType(persistanceClassError) as ClassMirror;

            for (var v in classMirrorPersistanceError.declarations.values) {
                if (v.simpleName == 'toResponseModel') {
                    persistanceError = true;
                }
            }

            if (!persistanceError) throw Exception('Persistance Class (Error) not contains function static => toModel. Please add to function static "toModel"');
        }
    }

    /// A function that is called when the user clicks on a button.
    void execute() async {
        validate();

        processing().then((response) {
            try {
                if (response.statusCode >= 200 && response.statusCode < 300) {
                    if (persistanceClass != null) {
                        if (persistanceClass == StringModel) {
                            StringModel stringModel = StringModel();
                            stringModel.data = response.body as String;

                            String reasonPhrase = "";
                            if (response.reasonPhrase != null) {
                                reasonPhrase = response.reasonPhrase;
                            }

                            transportListener.onResponseDone(response.statusCode, reasonPhrase, stringModel, code, arrPacket);
                        } else {
                            persistanceClass = Mapper.childPersistance(response.body, persistanceClass);
                            String reasonPhrase = "";
                            if (response.reasonPhrase != null) {
                                reasonPhrase = response.reasonPhrase;
                            }
                            transportListener.onResponseDone(response.statusCode,reasonPhrase, persistanceClass, code, arrPacket);
                        }
                    } else {
                        String reasonPhrase = "";
                        if (response.reasonPhrase != null) {
                            reasonPhrase = response.reasonPhrase;
                        }
                        transportListener.onResponseDone(response.statusCode, reasonPhrase, response.body, code, arrPacket);
                    }
                } 
                else if (response.statusCode == 401) {
                    StackTrace? stacktrace;
                    FirebaseCrashlytics.instance.recordError("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}", stacktrace, fatal:false);
                    FirebaseCrashlytics.instance.log("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}");
                    transportListener.onTokenInvalid();
                } 
                else {
                    StackTrace? stacktrace;
                    FirebaseCrashlytics.instance.recordError("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}", stacktrace, fatal:false);
                    FirebaseCrashlytics.instance.log("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}");
                    if (persistanceClassError != null) {
                        String reasonPhrase = "";
                        if (response.reasonPhrase != null) {
                            reasonPhrase = response.reasonPhrase;
                        }

                        try {
                            persistanceClassError = Mapper.childPersistance(response.body, persistanceClassError);
                            transportListener.onResponseFail(response.statusCode, reasonPhrase, persistanceClassError, code, arrPacket);
                        } catch (exception, stacktrace) {
                            transportListener.onResponseError(exception.toString(), stacktrace, code, arrPacket);
                            FirebaseCrashlytics.instance.recordError("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}", stacktrace, fatal:false);
                            FirebaseCrashlytics.instance.log("url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}");
                        }
                        
                       
                    } else {
                        String reasonPhrase = "";
                        if (response.reasonPhrase != null) {
                            reasonPhrase = response.reasonPhrase;
                        }
                        transportListener.onResponseFail(response.statusCode, reasonPhrase, response.body, code, arrPacket);
                    }
                }
            } catch (exception, stacktrace) {
              transportListener.onResponseError(exception.toString(), stacktrace, code, arrPacket);
              // FirebaseCrashlytics.instance.recordError("${F.crashlyticsNote} --> url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}", stacktrace, fatal:false);
              // FirebaseCrashlytics.instance.log("${F.crashlyticsNote} --> url : $baseUrl$path , method : $method,  headers: $headers  response:  ${response.body}");
            }
        });
    }

    /// It takes the request parameters and sends the request to the server
    ///
    /// Returns:
    ///   A Future<dynamic> object.
    Future<dynamic> processing() async {
        if (method == 'POST') {
            logging.log('============================ POST REQUEST ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            logging.log('======================================================================');

            dynamic response;
            dynamic responseMulti;
            if (isMultipart) {
                var request = http.MultipartRequest(
                    'POST',
                    Uri.parse(baseUrl + path),
                );

                Map<String, String> bodyText = {};
                List<http.MultipartFile> bodyFile = [];
                for (var key in bodyBuilder.parameters.keys) {
                    dynamic value = bodyBuilder.parameters[key];
                    if (value is String) {
                        bodyText[key] = value;
                    } else {
                        bodyFile.add(await http.MultipartFile.fromPath(key, value.path));
                    }
                }

                request.headers.addAll(headers);
                request.fields.addAll(bodyText);
                request.files.addAll(bodyFile);

                responseMulti = await _chuckerHttpClient.send(request);
            } else {
                response = await _chuckerHttpClient.post(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).catchError((error) {
                    gets.Get.snackbar("ERROR", error.toString(),
                        snackPosition: gets.SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white);

                    return null;
                });
            }

            logging.log(
                '============================ POST RESPONSE ===========================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            if(isMultipart) {
                String responseString = await responseMulti.stream.bytesToString();
                response= Response(responseString, (responseMulti as http.StreamedResponse).statusCode, reasonPhrase:responseMulti.reasonPhrase,);
            }
            logging.log('Code     : ${response.statusCode}');
            logging.log('Message  : ${response.reasonPhrase}');
            logging.log('Response : ${response.body}');
            logging.log(
                '======================================================================');

            return response;
        } else if (method == 'PUT') {
            logging.log('============================ PUT REQUEST ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            logging.log('=====================================================================');

            dynamic response;
            dynamic responseMulti;
            if (isMultipart) {
                var request = http.MultipartRequest(
                    'PUT',
                    Uri.parse(baseUrl + path),
                );

                Map<String, String> bodyText = {};
                List<http.MultipartFile> bodyFile = [];
                for (var key in bodyBuilder.parameters.keys) {
                    dynamic value = bodyBuilder.parameters[key];
                    if (value is String) {
                        bodyText[key] = value;
                    } else {
                        bodyFile.add(await http.MultipartFile.fromPath(key, value.path));
                    }
                }

                request.headers.addAll(headers);
                request.fields.addAll(bodyText);
                request.files.addAll(bodyFile);

                responseMulti = await _chuckerHttpClient.send(request);
            } else {
                response = await _chuckerHttpClient.put(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).catchError((error) {
                    gets.Get.snackbar("ERROR", error.toString(),
                        snackPosition: gets.SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white);
                    return null;
                });
            }

            logging.log('============================ PUT RESPONSE ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            if(isMultipart) {
                String responseString = await responseMulti.stream.bytesToString();
                response= Response(responseString, (responseMulti as http.StreamedResponse).statusCode, reasonPhrase:responseMulti.reasonPhrase,);
            }
            logging.log('Code     : ${response.statusCode}');
            logging.log('Message  : ${response.reasonPhrase}');
            logging.log('Response : ${response.body}');
            logging.log('=====================================================================');

            return response;
        } else if (method == 'PATCH') {
            logging.log('============================ PATCH REQUEST ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            logging.log('=====================================================================');

            dynamic response;
            dynamic responseMulti;
            if (isMultipart) {
                var request = http.MultipartRequest(
                    'PATCH',
                    Uri.parse(baseUrl + path),
                );

                Map<String, String> bodyText = {};
                List<http.MultipartFile> bodyFile = [];
                for (var key in bodyBuilder.parameters.keys) {
                    dynamic value = bodyBuilder.parameters[key];
                    if (value is String) {
                        bodyText[key] = value;
                    } else {
                        bodyFile.add(await http.MultipartFile.fromPath(key, value.path));
                    }
                }

                request.headers.addAll(headers);
                request.fields.addAll(bodyText);
                request.files.addAll(bodyFile);

                responseMulti = await _chuckerHttpClient.send(request);
            } else {
                response = await _chuckerHttpClient.patch(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).catchError((error) {
                    gets.Get.snackbar("ERROR", error.toString(),
                        snackPosition: gets.SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white);

                    return null;
                });
            }

            logging.log('============================ PATCH RESPONSE ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Request  : $bodyBuilder');
            if(isMultipart) {
                String responseString = await responseMulti.stream.bytesToString();
                response= Response(responseString, (responseMulti as http.StreamedResponse).statusCode, reasonPhrase:responseMulti.reasonPhrase,);
            }
            logging.log('Code     : ${response.statusCode}');
            logging.log('Message  : ${response.reasonPhrase}');
            logging.log('Response : ${response.body}');
            logging.log('=====================================================================');

            return response;
        } else if (method == 'GET') {
            logging.log('============================ GET REQUEST ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('=====================================================================');


            final response = await _chuckerHttpClient
                .get(Uri.parse(baseUrl + path), headers: headers)
                .catchError((error) {
                gets.Get.snackbar("ERROR", error.toString(),
                        snackPosition: gets.SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white);
                    return null;
                });

            logging.log('============================ GET RESPONSE ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Code     : ${response.statusCode}');
            logging.log('Message  : ${response.reasonPhrase}');
            logging.log('Response : ${response.body}');
            logging.log('=====================================================================');

            return response;
        } else if (method == 'DELETE') {
            logging.log('============================ DELETE REQUEST ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('========================================================================');

            final response = await _chuckerHttpClient
                .delete(Uri.parse(baseUrl + path), headers: this.headers)
                .catchError((error) {
                    gets.Get.snackbar("ERROR", error.toString(),
                        snackPosition: gets.SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                        colorText: Colors.white);
                    return null;
                });

            logging.log('============================ DELETE RESPONSE ============================');
            logging.log('URL      : $baseUrl$path');
            headers.forEach((k, v) => logging.log('Header   : ${k} => ${v}'));
            logging.log('Code     : ${response.statusCode}');
            logging.log('Message  : ${response.reasonPhrase}');
            logging.log('Response : ${response.body}');
            logging.log('========================================================================');

            return response;
        }

        return null;
    }
}
