import 'dart:convert';

import 'package:tcc/models/Produto.dart';
import 'package:tcc/models/ProdutoReserva.dart';
import 'package:tcc/shared/LocalStorage.dart';
import 'package:tcc/shared/ResponseRequest.dart';

import '../shared/Request.dart';

class ProdutoRepository {

  static Future<List<Produto>> findProdutosByIdPost(int idPost) async {

    return Produto.fromJson(jsonDecode((await Requests
        .getUsingToken('${Requests.hostApi}produto/$idPost')).body));
  }

  static Future<List<ProdutoReserva>> findAllByIdPostAndIdUser(int idPost) async {

    return ProdutoReserva.fromJson(jsonDecode((await Requests
        .getUsingToken('${Requests.hostApi}produto/reserva/$idPost/${(
        await LocalStorage.getUser()).idUser}')).body));
  }

  static Future<List<dynamic>> realizaCalculos(int idPost) async {

    return jsonDecode((await Requests
        .getUsingToken('${Requests.hostApi}produto/reserva/$idPost')).body);
  }

  static Future<ResponseRequest> saveProdutoReserva(String jsonBody) async {

    return await Requests
        .post('${Requests.hostApi}produto/reserva',
        jsonBody
    );
  }
}