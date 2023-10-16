import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc/modules/Dashboard.dart';
import 'package:tcc/service/Authentication.dart';
import 'package:tcc/shared/LocalStorage.dart';

import '../shared/Request.dart';
import '../shared/ResponseRequest.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool logging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Expanded(
                child: Container(
                    alignment: const AlignmentDirectional(0, 0.5),
                    child: Image.asset(
                      "assets/logo.png",
                    ))),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white10,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(children: [
                        Image.asset(
                          "assets/logoGoogle.png",
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 6),
                        logging
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 105.0, right: 10.0),
                                child: Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              )
                            : const Text("Continuar com Google",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                      ]),
                      onPressed: () async {

                        await realizaLogin();

                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  realizaLogin() async {

    try {

      GoogleSignInAccount? acountUser =
          await Authentication.signInWithGoogle();

      if (acountUser != null) {

        setState(() {
          logging = true;
        });

        await Authentication.signIn(acountUser);

        ResponseRequest dadosUsuario = await Requests.getUsingToken(
            "${Requests.hostApi}user/userEmail?dsEmailUser=${acountUser.email}");

        if (dadosUsuario.body.isNotEmpty) {

          await LocalStorage.getInstance()
              .then((value) => value.setString("User", dadosUsuario.body));

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard()));
        }
      }

    } catch (e) {

      setState(() {
        logging = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Center(
                child: Text(
                'Verifique seus dados e tente novamente',
                style: TextStyle(
                    color: Colors.red),
              ),)));
    }
  }
}
