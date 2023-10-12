
class Produto {

  late String dsProduto;
  late double vlProduto;

  Produto(this.dsProduto, this.vlProduto);

  Map<String, dynamic> toJson() =>
      {
        "dsProduto" : dsProduto,
        "vlProduto" : vlProduto
      };

  static List<Produto> fromJson(List<dynamic> listJson) {

    List<Produto> produto = [];

    for (var json in listJson) {

      produto.add(Produto(json["dsProduto"], json["vlProduto"]));
    }

    return produto;
  }
}