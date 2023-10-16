import 'dart:convert';

import 'package:tcc/repositories/ProdutoRepository.dart';

import '../models/ProdutoReserva.dart';
import '../shared/ResponseRequest.dart';

class ProdutoService {

  static List getProduto = [];
  static List getProdutosReservado = [];
  static late ProdutoReserva produtoReserva = ProdutoReserva();

  static Future<bool> findProdutosByIdPost(int idPost) async {

    getProduto.clear();
    getProduto.addAll(await ProdutoRepository.findProdutosByIdPost(idPost));

    return true;
  }

  static Future<bool> findAllByIdPostAndIdUser(int idPost) async {

    getProdutosReservado.clear();
    getProdutosReservado.addAll(await ProdutoRepository.findAllByIdPostAndIdUser(idPost));

    return true;
  }

  static Future<bool> realizaCalculos(int idPost) async {

    List<dynamic> list = await ProdutoRepository.realizaCalculos(idPost);

    produtoReserva.totalProdutosReservados = list[0];
    produtoReserva.valorTotalProdutosReservados = list[1];

    return true;
  }

  static Future<ResponseRequest> saveProdutoReserva(List<ProdutoReserva> produtoReserva) async {

    return await ProdutoRepository.saveProdutoReserva(jsonEncode(produtoReserva));
  }

}