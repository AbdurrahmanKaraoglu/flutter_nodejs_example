import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_nodejs_example/api/services/app_exceptions.dart';
import 'package:http/http.dart' as http;

class BaseClient {
  static String baseUrl = "https://portakil-master-db-09fe3ef6ad55.herokuapp.com";

  static int? timeOutDuration = 300;

  //POST
  static Future<http.Response> post(String api, dynamic params) async {
    http.Response? resp;
    var uri = Uri.parse(baseUrl + api);
    var body = json.encode(params);

    try {
      Map<String, String> header = {"Content-type": "application/json"};

      var response = await http.post(uri, headers: header, body: body).timeout(Duration(seconds: timeOutDuration!));

      return response;
    } catch (e) {
      return resp!;
    }
  }

  static Future<http.Response> postToken(String api, dynamic params, String jwtToken, String userID) async {
    var uri = Uri.parse(baseUrl + api);
    var body = json.encode(params);
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': jwtToken,
        'UserID': userID, // Kullanıcı kimliği buraya eklenecek
      };

      var response = await http.post(uri, headers: header, body: body).timeout(Duration(seconds: timeOutDuration!));
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }

  // GET

  static Future<http.Response> get(String api, Map<String, dynamic>? queryParameters) async {
    http.Response? resp;
    Uri uri = Uri.parse(baseUrl + api).replace(queryParameters: queryParameters);

    try {
      Map<String, String> header = {"Content-type": "application/json"};

      var response = await http.get(uri, headers: header).timeout(Duration(seconds: timeOutDuration!));

      return response;
    } catch (e) {
      return resp!;
    }
  }

  static Future<http.Response> getToken(String api, String jwtToken, String userID, Map<String, dynamic>? queryParameters) async {
    Uri uri = Uri.parse(baseUrl + api).replace(queryParameters: queryParameters);
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': jwtToken,
        'UserID': userID, // Kullanıcı kimliği buraya eklenecek
      };

      var response = await http.get(uri, headers: header).timeout(Duration(seconds: timeOutDuration!));
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
}
