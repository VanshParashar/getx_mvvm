import 'dart:convert';
import 'dart:io';

import 'package:getx_mvvm/data/app_exception.dart';
import 'package:getx_mvvm/data/network/base_api_services.dart';
import 'package:http/http.dart ' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future getApi(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeout {
      throw RequestTimeout('');
    }

    return responseJson;
  }

  @override
  Future postApi(var data, String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.post(Uri.parse(url),
          body: jsonEncode(data)
          ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeout {
      throw RequestTimeout('');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw InvalidUrlException;

      default:
        throw FetchDataException(
            'Error occured while communicating with server ' +
                response.statusCode.toString());
    }
  }
}
