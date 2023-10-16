
class ProdutoReserva {

  late int idPost;
  late int idProduto;
  late int idUser;
  late String qtdProduto;
  late int totalProdutosReservados;
  late double valorTotalProdutosReservados;

  ProdutoReserva({this.idPost = 0, this.idProduto = 0, this.idUser = 0, this.qtdProduto = "0"});

  Map<String, dynamic> toJson() =>
      {
        "idPost" : idPost,
        "idProduto" : idProduto,
        "idUser" : idUser,
        "qtdProduto" : qtdProduto
      };

  static List<ProdutoReserva> fromJson(List<dynamic> listJson) {

    List<ProdutoReserva> produto = [];

    for (var json in listJson) {

      produto.add(ProdutoReserva(idPost: json["idPost"], idProduto: json["idProduto"],
          idUser: json["idUser"], qtdProduto: json["qtdProduto"]));
    }

    return produto;
  }
}