import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:tcc/service/ProdutoService.dart';

import '../models/Produto.dart';

class ProdutosReservaPage extends StatefulWidget {

  int idPost;

  ProdutosReservaPage({super.key, required this.idPost});

  @override
  State<ProdutosReservaPage> createState() => _ProdutosReservaPageState(idPost: idPost);
}

class _ProdutosReservaPageState extends State<ProdutosReservaPage> {

  late TextEditingController nrProdutoReserva = TextEditingController();

  int idPost;
  _ProdutosReservaPageState({required this.idPost});

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

                    },
                    child: Text("Salvar"),
                  ),
                ),
              ),
            ]),
      ),
      body: FutureBuilder(
          future: ProdutoService.findPost(idPost),
          builder: (context, snapshot) {

            if (snapshot.hasData) {

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ProdutoService.getProduto.length,
                itemBuilder: (context, index) {

                  return getProduct(ProdutoService.getProduto[index]);
              },
              );

            }

            return Center(child: CircularProgressIndicator());

          },),
    );
  }

  getProduct(Produto produto) {

    MoneyMaskedTextController formatValue = MoneyMaskedTextController(
        leftSymbol: 'R\$ ', decimalSeparator: '.', thousandSeparator: ',');

    formatValue.text = produto.vlProduto.toString();

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
                child:  const Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: '0',
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
}
