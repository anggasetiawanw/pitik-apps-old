// ignore_for_file: unnecessary_null_comparison, avoid_logging.log, invalid_return_type_for_catch_error, slash_for_doc_comments, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as logging;

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:reflectable/mirrors.dart';
import 'package:reflectable/reflectable.dart';

import '../../model/base_model.dart';
import '../../model/string_model.dart';
import '../../util/mapper/mapper.dart';
import './body/body_builder.dart';
import './interface/response_listener.dart';
import 'transporter_response.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
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

    String log = "";

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

        if (persistanceClass != null && persistanceClass != String) {
            bool persistanceAs = false;
            var classMirrorPersistanceAs = SetupModel.reflectType(persistanceClass) as ClassMirror;

            for (var v in classMirrorPersistanceAs.declarations.values) {
                if (v.simpleName == "toResponseModel") {
                    persistanceAs = true;
                }
            }

            if (!persistanceAs) throw Exception('Persistance Class (As) not contains function static => toResponseModel. Please add to function static "toResponseModel"');
        }

        if (persistanceClassError != null && persistanceClass != String) {
            bool persistanceError = false;
            var classMirrorPersistanceError = SetupModel.reflectType(persistanceClassError) as ClassMirror;

            for (var v in classMirrorPersistanceError.declarations.values) {
                if (v.simpleName == 'toResponseModel') {
                    persistanceError = true;
                }
            }

            if (!persistanceError) throw Exception('Persistance Class (Error) not contains function static => toResponseModel. Please add to function static "toResponseModel"');
        }
    }

    /// A function that is called when the user clicks on a button.
    void execute() async {
        validate();

        processing().then((transporterResponse) {
            _postLog(transporterResponse);

            if (transporterResponse.statusCode >= 200 && transporterResponse.statusCode < 300) {
                if (persistanceClass == StringModel) {
                    StringModel stringModel = StringModel();
                    stringModel.data = transporterResponse.body as String;
                    transportListener.onResponseDone(transporterResponse.statusCode, transporterResponse.reasonPhrase, stringModel, code, arrPacket);
                } else {
                    persistanceClass = Mapper.childPersistance(transporterResponse.body, persistanceClass);
                    transportListener.onResponseDone(transporterResponse.statusCode, transporterResponse.reasonPhrase, persistanceClass, code, arrPacket);
                }
            } else {
                if (transporterResponse.statusCode == 401) {
                    transportListener.onTokenInvalid();
                } else {
                    if (persistanceClassError != null && persistanceClassError != String) {
                        persistanceClassError = Mapper.childPersistance(transporterResponse.body, persistanceClassError);
                        transportListener.onResponseFail(transporterResponse.statusCode, transporterResponse.reasonPhrase, persistanceClassError, code, arrPacket);
                    } else {
                        transportListener.onResponseFail(transporterResponse.statusCode, transporterResponse.reasonPhrase, transporterResponse.body, code, arrPacket);
                    }
                }
            }
        }).catchError((exception, stacktrace) {
            _postLogException(stacktrace);
            transportListener.onResponseError(exception.toString(), stacktrace, code, arrPacket);
        });
    }

    void _preLog() {
        log = '{"url": "$baseUrl$path", "mediaType": "${bodyBuilder.getMediaType()}", "headers": [';
        headers.forEach((k, v) => log += '"$k => $v", ');
        log += '], "method" : "$method", "request": "${bodyBuilder.toString()}"';
    }

    void _postLog(TransporterResponse transportResponse) {
        StackTrace? stacktrace;
        log += ', "code": ${transportResponse.statusCode}, "message": "${transportResponse.reasonPhrase}", "response": ${transportResponse.body}';
        FirebaseCrashlytics.instance.recordError(log, stacktrace, fatal: false);
        FirebaseCrashlytics.instance.log(log);
    }

    void _postLogException(stacktrace) {
        StackTrace? stacktrace;
        log += ', "response": ${stacktrace.toString()}';
        FirebaseCrashlytics.instance.recordError(log, stacktrace, fatal: false);
        FirebaseCrashlytics.instance.log(log);
    }

    /// It takes the request parameters and sends the request to the server
    ///
    /// Returns:
    ///   A Future<dynamic> object.
    Future<dynamic> processing() async {
        if (method == 'POST') {
            String headerPrint = '';
            headers.forEach((k, v) => headerPrint += 'Header   : $k => $v');
            logging.log(
                '============================ POST REQUEST ============================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                '======================================================================\n'
            );

            _preLog();
            dynamic response;

            if (isMultipart) {
                var request = http.MultipartRequest('POST', Uri.parse(baseUrl + path),);

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

                dynamic responseMultipart = await _chuckerHttpClient.send(request).timeout(
                    const Duration(seconds: 60),
                    onTimeout: () => throw 'Request Timeout',
                );
                response = http.Response(await responseMultipart.stream.bytesToString(), (responseMultipart as http.StreamedResponse).statusCode, reasonPhrase: responseMultipart.reasonPhrase);
            } else {
                response = await _chuckerHttpClient.post(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).timeout(
                    const Duration(seconds: 30),
                    onTimeout: () => http.Response("{\"code\": 408, \"error\": {\"message\": \"Request Timeout\", \"stack\": \"\"}}", 408, reasonPhrase: 'Request Timeout'),
                ).catchError((error) => http.Response("{\"code\": 500, \"error\": {\"message\": \"Internal Server Error (${error.toString()})\", \"stack\": \"\"}}", 500, reasonPhrase: 'Internal Server Error (${error.toString()})'));
            }

            TransporterResponse transporterResponse = TransporterResponse(body: response.body, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
            logging.log(
                '============================ POST RESPONSE ===========================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                    'Code     : ${transporterResponse.statusCode}\n'
                    'Message  : ${transporterResponse.reasonPhrase}\n'
                    'Response : ${transporterResponse.body}\n'
                '======================================================================\n');

            return transporterResponse;
        } else if (method == 'PUT') {
            String headerPrint = '';
            headers.forEach((k, v) => headerPrint += 'Header   : $k => $v');
            logging.log(
                '============================ PUT REQUEST ============================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                '=====================================================================\n'
            );

            _preLog();
            dynamic response;

            if (isMultipart) {
                var request = http.MultipartRequest('PUT', Uri.parse(baseUrl + path),);

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

                dynamic responseMultipart = await _chuckerHttpClient.send(request).timeout(
                    const Duration(seconds: 60),
                    onTimeout: () => throw 'Request Timeout',
                );
                response = http.Response(await responseMultipart.stream.bytesToString(), (responseMultipart as http.StreamedResponse).statusCode, reasonPhrase: responseMultipart.reasonPhrase);
            } else {
                response = await _chuckerHttpClient.put(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).timeout(
                    const Duration(seconds: 30),
                    onTimeout: () => http.Response("{\"code\": 408, \"error\": {\"message\": \"Request Timeout\", \"stack\": \"\"}}", 408, reasonPhrase: 'Request Timeout'),
                ).catchError((error) => http.Response("{\"code\": 500, \"error\": {\"message\": \"Internal Server Error (${error.toString()})\", \"stack\": \"\"}}", 500, reasonPhrase: 'Internal Server Error (${error.toString()})'));
            }

            TransporterResponse transporterResponse = TransporterResponse(body: response.body, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
            logging.log(
                '============================ PUT RESPONSE ===========================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                    'Code     : ${transporterResponse.statusCode}\n'
                    'Message  : ${transporterResponse.reasonPhrase}\n'
                    'Response : ${transporterResponse.body}\n'
                '=====================================================================\n');

            return transporterResponse;
        } else if (method == 'PATCH') {
            String headerPrint = '';
            headers.forEach((k, v) => headerPrint += 'Header   : $k => $v');
            logging.log(
                '============================ PATCH REQUEST ============================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                '======================================================================\n'
            );

            _preLog();
            dynamic response;

            if (isMultipart) {
                var request = http.MultipartRequest('PATCH', Uri.parse(baseUrl + path),);

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

                dynamic responseMultipart = await _chuckerHttpClient.send(request).timeout(
                    const Duration(seconds: 60),
                    onTimeout: () => throw 'Request Timeout',
                );
                response = http.Response(await responseMultipart.stream.bytesToString(), (responseMultipart as http.StreamedResponse).statusCode, reasonPhrase: responseMultipart.reasonPhrase);
            } else {
                response = await _chuckerHttpClient.patch(
                    Uri.parse(baseUrl + path),
                    headers: headers,
                    body: bodyBuilder.toString(),
                ).timeout(
                    const Duration(seconds: 30),
                    onTimeout: () => http.Response("{\"code\": 408, \"error\": {\"message\": \"Request Timeout\", \"stack\": \"\"}}", 408, reasonPhrase: 'Request Timeout'),
                ).catchError((error) => http.Response("{\"code\": 500, \"error\": {\"message\": \"Internal Server Error (${error.toString()})\", \"stack\": \"\"}}", 500, reasonPhrase: 'Internal Server Error (${error.toString()})'));
            }

            TransporterResponse transporterResponse = TransporterResponse(body: response.body, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
            logging.log(
                '============================ PATCH RESPONSE ===========================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                    'Code     : ${transporterResponse.statusCode}\n'
                    'Message  : ${transporterResponse.reasonPhrase}\n'
                    'Response : ${transporterResponse.body}\n'
                '=======================================================================\n');

            return transporterResponse;
        } else if (method == 'GET') {
            String headerPrint = '';
            headers.forEach((k, v) => headerPrint += 'Header   : $k => $v');
            logging.log(
                '============================ GET REQUEST ============================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                '=====================================================================\n'
            );

            _preLog();

            final response = await _chuckerHttpClient.get(
                Uri.parse(baseUrl + path),
                headers: headers
            ).timeout(
                const Duration(seconds: 30),
                onTimeout: () => http.Response("{\"code\": 408, \"error\": {\"message\": \"Request Timeout\", \"stack\": \"\"}}", 408, reasonPhrase: 'Request Timeout'),
            ).catchError((error) => http.Response("{\"code\": 500, \"error\": {\"message\": \"Internal Server Error (${error.toString()})\", \"stack\": \"\"}}", 500, reasonPhrase: 'Internal Server Error (${error.toString()})'));

            TransporterResponse transporterResponse = TransporterResponse(body: response.body, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
            logging.log(
                '============================ GET RESPONSE ===========================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                    'Code     : ${transporterResponse.statusCode}\n'
                    'Message  : ${transporterResponse.reasonPhrase}\n'
                    'Response : ${transporterResponse.body}\n'
                '=====================================================================\n');

            return transporterResponse;
        } else if (method == 'DELETE') {
            String headerPrint = '';
            headers.forEach((k, v) => headerPrint += 'Header   : $k => $v');
            logging.log(
                '============================ DELETE REQUEST ============================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                '========================================================================\n'
            );

            _preLog();

            final response = await _chuckerHttpClient.delete(
                Uri.parse(baseUrl + path),
                headers: headers
            ).timeout(
                const Duration(seconds: 30),
                onTimeout: () => http.Response("{\"code\": 408, \"error\": {\"message\": \"Request Timeout\", \"stack\": \"\"}}", 408, reasonPhrase: 'Request Timeout'),
            ).catchError((error) => http.Response("{\"code\": 500, \"error\": {\"message\": \"Internal Server Error (${error.toString()})\", \"stack\": \"\"}}", 500, reasonPhrase: 'Internal Server Error (${error.toString()})'));

            TransporterResponse transporterResponse = TransporterResponse(body: response.body, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
            logging.log(
                '============================ DELETE RESPONSE ===========================\n'
                    'URL      : $baseUrl$path\n'
                    '$headerPrint\n'
                    'Request  : $bodyBuilder\n'
                    'Code     : ${transporterResponse.statusCode}\n'
                    'Message  : ${transporterResponse.reasonPhrase}\n'
                    'Response : ${transporterResponse.body}\n'
                '========================================================================\n');

            return transporterResponse;
        }

        return null;
    }
}
