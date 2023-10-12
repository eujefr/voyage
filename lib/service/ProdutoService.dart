import 'package:tcc/repositories/ProdutoRepository.dart';

class ProdutoService {

  static List getProduto = [];

  static Future<bool> findPost(idPost) async {

    getProduto.clear();
    getProduto.addAll(await ProdutoRepository.findProdutosByIdPost(idPost));

    return true;
  }
}