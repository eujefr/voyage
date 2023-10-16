import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tcc/models/User.dart';
import 'package:tcc/modules/CreatePost.dart';
import 'package:tcc/modules/PerfilUser.dart';
import 'package:tcc/modules/ProdutosReservaPage.dart';
import 'package:tcc/service/PostService.dart';
import 'package:tcc/shared/LocalStorage.dart';

import '../models/Post.dart';
import '../models/Produto.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  late User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorage.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {

          user = snapshot.data!;

          if (user != null) {
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.grey,
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("olá, ${user.dsUser.split(" ")[0].camelCase}"),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 2),
                    child: GestureDetector(
                      onTap: () {

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PerfilUser(),));
                      },
                      child: ClipOval(
                        child: Image.network(user.dsImgUser),
                      ),
                    ),
                  ),
                ],
              ),
              body: SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
              onRefresh: () async {

                await PostService.findPost();
                setState(() {

                });
                _refreshController.refreshCompleted();
              },
                onLoading: () async {

                  await PostService.findPost(update: true);
                  setState(() {

                  });

                  _refreshController.loadComplete();

                },
              child:
                  ListView.builder(
                    itemCount: PostService.getPost.length,
                  itemBuilder: (context, index) {

                      if (index == 0) {

                        return getBtnCreatePost();
                      }

                      Post post = PostService.getPost[index];

                      return InkWell(
                        child:
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(post.user.dsImgUser),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        post.user.dsUser,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  post.dsImgPost.isNotEmpty ? Container(
                                    decoration: const BoxDecoration(
                                    ),
                                    child:  CachedNetworkImage(
                                      imageUrl: post.dsImgPost,
                                      alignment: Alignment.center,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error_outline, color: Colors.red),),
                                    ),
                                  ) : const SizedBox(height: 0,),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      utf8.decode(post.dsPost.runes.toList(), allowMalformed: true),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {

                          if (post.containsProduto) {

                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProdutosReservaPage(idPost: post.idPost,
                                idUserPost: post.user.idUser, user: user,)));
                          }

                        },
                      );
                  }
              ,),
            ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

  }

  getBtnCreatePost() {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: Container(
          height: 40,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius:
              BorderRadius.all(Radius.circular(30))),
          alignment: Alignment.center,
          child: const Text("Criar novo post")),
        onTap: () {

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreatePost()));
        },
      ),
    );

  }
}
