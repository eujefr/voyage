import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:tcc/models/User.dart';

import '../models/Produto.dart';
import '../shared/LocalStorage.dart';
import '../shared/Request.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  late List<MoneyMaskedTextController> controllerValueProduto = [];
  late List<TextEditingController> controllerDsProduto = [];
  late TextEditingController dsPost = TextEditingController();
  late TextEditingController dsImgPost = TextEditingController();
  var listIndex = [];
  bool btnAbled = true;

  containsIndexList(index) {

    if (listIndex.contains(index)) {

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        height: 55,
        child: Row(
            children: [
              listIndex.isNotEmpty ? IconButton(
                  iconSize: 30,
                  splashColor: Colors.blue,
                  onPressed: () {

                    listIndex.sort();

                    listIndex.reversed.forEach((element) {

                      controllerValueProduto.removeAt(element);
                      controllerDsProduto.removeAt(element);
                    });

                    listIndex.clear();

                    setState(() {

                    });

                  }, icon: const Icon(Icons.delete_forever)) : Text(''),
              listIndex.isNotEmpty ? Text("itens ${listIndex.length}") : Text(''),
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
                      onPressed: btnAbled ? () async {

                        if (dsPost.value.text.isEmpty
                            && dsImgPost.value.text.isEmpty) {

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Center(
                                    child: Text(
                                      'necessário uma descrição ou imagem para o post',
                                      style: TextStyle(
                                          color: Colors.yellow),
                                    ),)));

                        } else {

                          setState(() {

                          });

                          User user = await LocalStorage.getUser();

                          Map<String, dynamic> json =
                          {'dsPost' : dsPost.value.text,
                            'dsImgPost' : dsImgPost.value.text,
                            'dsEmailUsuario' : user.dsEmailUsuario,
                            'produto': []};


                          controllerDsProduto.forEach((element) {

                            int index = controllerDsProduto.indexOf(element);

                            String valueProduto = controllerValueProduto[index].value
                                .text.replaceAll("R\$ ", "").replaceAll(",", "");
                            json['produto'].add(Produto(dsProduto: element.value.text,
                                vlProduto: valueProduto).toJson());

                          });

                          String response = (await Requests.post('${Requests.hostApi}post/save',
                              jsonEncode(json))).body;

                          if (response.isNotEmpty) {

                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        }

                      } : null,
                  child: Text("Salvar"),
                  ),
                ),
              ),
            ]),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(children: [
           Card(
              color: Colors.grey,
              child: TextField(
                maxLength: 200,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: dsPost,
                decoration:
                    InputDecoration.collapsed(hintText: "Texto do post"),
              )),
          const SizedBox(height: 20),
           Card(
              color: Colors.grey,
              child: TextField(
                maxLength: 1000,
                controller: dsImgPost,
                decoration:
                    InputDecoration.collapsed(hintText: "url da imagem"),
              )),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {

                controllerValueProduto.add(MoneyMaskedTextController(
                    leftSymbol: 'R\$ ', decimalSeparator: '.', thousandSeparator: ','));
                controllerDsProduto.add(TextEditingController());
              });
            },
          ),
          Flexible(
            child: Container(
               padding: const EdgeInsetsDirectional.only(bottom: 60),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controllerValueProduto.length,
                    itemBuilder: (context, index) => getProduct(index))),
          )
        ]),
      ),
    );
  }

  getProduct(int index) {

    return InkWell(
      splashColor: Colors.blue,
        onTap: () {

        if (listIndex.isNotEmpty) {

          setState(() {

            if (listIndex.contains(index)) {

              listIndex.remove(index);
            } else {

              listIndex.add(index);
            }

          });
        }

        },
        onLongPress: () {

        if (listIndex.isEmpty) {

          setState(() {

            if (listIndex.contains(index)) {

              listIndex.remove(index);
            } else {

              listIndex.add(index);
            }

          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border:  Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
             Card(
              color: Colors.grey,
              child: TextField(
                controller: controllerDsProduto[index],
                maxLength: 20,
                decoration:
                    const InputDecoration.collapsed(hintText: "descrição do produto"),
              ),
            ),
            Row(children: [
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
                      keyboardType: TextInputType.number,
                      controller: controllerValueProduto[index],
                      decoration: const InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: 'valor do produto',
                      ),
                    ),
                  ),
                ),
              ),
              containsIndexList(index) ? Flexible(
                child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    alignment: Alignment.centerRight,
                    child: const CircleAvatar(backgroundColor: Colors.red, radius: 8)),
              ) : Container(),
            ]),
          ],
        ),
      ),
    );
  }
}
