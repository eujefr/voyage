import 'dart:convert';

import 'package:tcc/models/Post.dart';

import '../shared/Request.dart';

class PostsRepository {

  static Future<List<Post>> findPost(int page) async {

    return Post.fromJson(jsonDecode(await Requests
        .getUsingToken('${Requests.hostApi}post/posts?page=$page')));
  }
}