
class Produto {

  late int idProduto;
  late String dsProduto;
  late String vlProduto;

  Produto({this.idProduto = 0, required this.dsProduto, required this.vlProduto});

  Map<String, dynamic> toJson() =>
      {
        "idProduto" : idProduto,
        "dsProduto" : dsProduto,
        "vlProduto" : vlProduto
      };

  static List<Produto> fromJson(List<dynamic> listJson) {

    List<Produto> produto = [];

    for (var json in listJson) {

      produto.add(Produto(idProduto: json["idProduto"], dsProduto: json["dsProduto"], vlProduto: json["vlProduto"]));
    }

    return produto;
  }
}