import 'package:http/http.dart' as request;
import 'package:tcc/shared/LocalStorage.dart';
import 'package:tcc/shared/ResponseRequest.dart';

class Requests {

  static const String hostApi = "http://192.168.3.6:8080/";
  static const String endpointAuthToken = "user/auth/token";

  static Future<ResponseRequest> post(url, body) async {

    request.Response response =
    await request.post(Uri.parse(url), body: body);

    return ResponseRequest(response.statusCode, response.body);
  }

  static Future<ResponseRequest> getUsingToken(url) async {

    String? token = await LocalStorage.getToken();

    if(token != null) {

      return get(url, {'Authorization' : token});

    } else {

      throw ArgumentError("token não existe");
    }
  }

  static Future<ResponseRequest> get(url, headers) async {
    
    request.Response response =
    await request.get(Uri.parse(url), headers: headers);

    return ResponseRequest(response.statusCode, response.body);
  }
}