import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc/shared/LocalStorage.dart';

import '../shared/Request.dart';

class Authentication {

  static Future<UserCredential> signIn(googleUser) async {

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken);

    await LocalStorage.setToken(await getToken(googleAuth?.idToken));

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() async {

    await GoogleSignIn().signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    return googleUser;
  }

  static Future<String> getToken(idTokenGoogle) async {

    return await Requests.post(Requests.hostApi+Requests.endpointAuthToken,
        jsonEncode(<String, String>{
          'token' : idTokenGoogle
          // 'dsUser' : googleUser.displayName.toString() ?? '',
          // 'dsEmailUsuario' : googleUser.email.toString() ?? '',
          // 'dsImgUser' : googleUser.photoUrl.toString() ?? '',
        }));
  }
}