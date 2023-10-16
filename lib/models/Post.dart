import 'User.dart';

class Post {

  late int idPost;
  late String dsPost;
  late String dsImgPost;
  late User user;
  late bool containsProduto;

  Post(this.idPost, this.dsPost, this.dsImgPost, this.user, this.containsProduto);

  static List<Post> fromJson(List<dynamic> listJson) {

    List<Post> post = [];

    for (var json in listJson) {

      post.add(Post(json['idPost'], json['dsPost'], json['dsImgPost'],
          User.fromJson(json['user']), json['containsProduto']));
    }

    return post;
  }
}