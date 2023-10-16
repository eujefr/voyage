import 'package:flutter/material.dart';
import 'package:tcc/models/User.dart';
import 'package:tcc/shared/LocalStorage.dart';

class PerfilUser extends StatefulWidget {
  const PerfilUser({Key? key}) : super(key: key);

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {

  List<String> list = <String>['null'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: LocalStorage.getUser(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            User? user = snapshot.data;

            if (user != null) {

              return Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(user.dsImgUser),
                      )
                    ],),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.dsUser)
                    ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.dsEmailUsuario)
                    ],),
                  ],
                ),
              );
            }
          }

          return Center(child: CircularProgressIndicator(),);

      },)
    );
  }
}
