import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wallpaper_app/data_source/remote/Urls.dart';
import 'package:wallpaper_app/data_source/remote/app_exception.dart';

class ApiHelper {
  Future<dynamic> getApi(
      {required String url, Map<String, String>? heders}) async {
    var uri = Uri.parse(url);

    try {
      // Get Json
      var respnonseData = await http.get(uri,
          headers: heders ?? {'Authorization': Urls.apiKey});
      return returnDataResponse(respnonseData);
    } on SocketException {
      // Internet Error
      throw FetchDataExecption(body: 'Internet Error');
    }
  }

  dynamic returnDataResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestExecption(body: response.body.toString());

      case 401:
      case 403:
        throw UnauthorizedExecption(body: response.body.toString());
      case 500:
      default:
        throw FetchDataExecption(
            body:
                'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
