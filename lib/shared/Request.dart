import 'package:http/http.dart' as request;
import 'package:tcc/shared/LocalStorage.dart';

class Requests {

  static const String hostApi = "http://192.168.128.91:8080/";
  static const String endpointAuthToken = "user/auth/token";

  static Future<String> post(url, body) async {

    request.Response response =
    await request.post(Uri.parse(url), body: body);

    return response.body;
  }

  static Future<String> getUsingToken(url) async {

    String? token = await LocalStorage.getToken();

    if(token != null) {

      return get(url, {'Authorization' : token});

    } else {

      throw ArgumentError("token não existe");
    }
  }

  static Future<String> get(url, headers) async {
    
    request.Response response =
    await request.get(Uri.parse(url), headers: headers);

    return response.body;
  }
}