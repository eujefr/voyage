import 'dart:core';

class User {

  late int idUser;
  late String dsUser;
  late String dsEmailUsuario;
  late String dsImgUser;

   User.fromJson(Map json)
       : idUser = json['idUser'],
         dsUser = json['dsUser'],
         dsEmailUsuario = json['dsEmailUsuario'],
         dsImgUser = json['dsImgUser'];

   Map<String, dynamic> toJson() =>
       {
         "dsUser" : dsUser,
         "dsEmailUsuario" : dsEmailUsuario,
         "dsImgUser" : dsImgUser,
       };
}