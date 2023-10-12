import 'dart:convert';

import 'package:tcc/models/Produto.dart';

import '../shared/Request.dart';

class ProdutoRepository {

  static Future<List<Produto>> findProdutosByIdPost(int idPost) async {

    return Produto.fromJson(jsonDecode(await Requests
        .getUsingToken('${Requests.hostApi}produto/$idPost')));
  }
}