import 'package:tcc/repositories/PostRepository.dart';


class PostService {

  static List getPost = [];
  static int page = 0;

  static Future<bool> findPost({bool update = false}) async {

    if (update) {

      page = page + 1;

    } else {

      page = 0;
      getPost.clear();
      getPost.add('');
    }

    getPost.addAll(await PostsRepository.findPost(page));

    return true;
  }
}