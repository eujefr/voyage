import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcc/models/ProdutoReserva.dart';
import 'package:tcc/service/ProdutoService.dart';

import '../models/Produto.dart';
import '../models/User.dart';
import '../shared/ResponseRequest.dart';

class ProdutosReservaPage extends StatefulWidget {

  int idPost;
  int idUserPost;
  User user;
  ProdutosReservaPage({super.key, required this.idPost, required this.idUserPost, required this.user});

  @override
  State<ProdutosReservaPage> createState() => _ProdutosReservaPageState(idPost: idPost, idUserPost: idUserPost,
  user: user);
}

class _ProdutosReservaPageState extends State<ProdutosReservaPage> {

  int idPost;
  int idUserPost;
  User user;
  late List<TextEditingController> nrProdutoReserva = [];
  late bool reservado = false;

  _ProdutosReservaPageState({required this.idPost, required this.idUserPost, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        height: 55,
        child: Row(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    ),
                    onPressed: () async {

                      if (reservado == false && verifyExistQtdProdutoReserva()) {

                        List<ProdutoReserva> produtosReserva = [];

                        for (TextEditingController text in nrProdutoReserva) {

                          if (text.value.text.isNotEmpty
                              && int.parse(text.value.text) > 0) {

                            ProdutoReserva produtoReserva = ProdutoReserva(idPost: idPost,
                                idProduto: (ProdutoService.getProduto[nrProdutoReserva.indexOf(text)])
                                    .idProduto, idUser: user.idUser, qtdProduto: text.value.text);

                            produtosReserva.add(produtoReserva);
                          }
                        }

                        ResponseRequest response =
                        await ProdutoService.saveProdutoReserva(produtosReserva);

                        if (response.statusCode == 201) {

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Center(
                                    child: Text(
                                      'produto reservado',
                                      style: TextStyle(
                                          color: Colors.yellow),
                                    ),)));

                        }
                      }
                    },
                    child: Text("Salvar"),
                  ),
                ),
              ),
            ]),
      ),
      body:
      Column(
        children: [
          user.idUser == idUserPost ?
              FutureBuilder(
                future: ProdutoService.realizaCalculos(idPost),
                builder: (context, snapshot) {

                  if (snapshot.hasData) {

                    return Container(
                      padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("total produtos reservados: ${ProdutoService.produtoReserva.totalProdutosReservados}"),
                          Text("valor total R\$: ${ProdutoService.produtoReserva.valorTotalProdutosReservados}"),
                        ],
                      ),
                    );

                  }

                  return Center(child: CircularProgressIndicator(),);

              },)
              : SizedBox(),
          Flexible(
            child: FutureBuilder(
              future: ProdutoService.findAllByIdPostAndIdUser(idPost),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  if (ProdutoService.getProdutosReservado.isNotEmpty) {

                    reservado = true;
                  }

                  return FutureBuilder(
                    future: ProdutoService.findProdutosByIdPost(idPost),
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: ProdutoService.getProduto.length,
                          itemBuilder: (context, index) {

                            return getProduct(index);
                          },
                        );

                      }

                      return Center(child: CircularProgressIndicator());

                    },);
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      )
    );
  }

  getProduct(index) {

    Produto produto = ProdutoService.getProduto[index];
    ProdutoReserva? produtoReserva;

    if (ProdutoService.getProdutosReservado.isNotEmpty) {

      for (ProdutoReserva value in ProdutoService.getProdutosReservado) {

        if (value.idProduto == produto.idProduto) {

          produtoReserva = value;
          break;
        }

      }
    }

    MoneyMaskedTextController formatValue = MoneyMaskedTextController(
        leftSymbol: 'R\$ ', decimalSeparator: '.', thousandSeparator: ',');

    formatValue.text = produto.vlProduto.toString();
    nrProdutoReserva.add(TextEditingController());

    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                enabled: false,
                maxLength: 20,
                decoration:
                    InputDecoration.collapsed(hintText: produto.dsProduto,
                        hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.topLeft,
                height: 35,
                width: 150,
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      enabled: false,
                      border: InputBorder.none,
                      hintText: formatValue.value.text,
                        hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.topRight,
                height: 35,
                width: 80,
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: reservado ? false : true,
                    controller: nrProdutoReserva[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: (produtoReserva != null) ? produtoReserva.qtdProduto : '0',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }

  verifyExistQtdProdutoReserva() {

    for (TextEditingController text in nrProdutoReserva) {

      if (text.value.text.isNotEmpty) {

        return true;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Center(
              child: Text(
                'informe uma quantidade a ser reservada',
                style: TextStyle(
                    color: Colors.yellow),
              ),)));
  }
}
