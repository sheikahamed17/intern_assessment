import 'dart:convert';
import 'dart:developer';

import 'package:bloc_practice/features/post/models/post_data_ui_model.dart';
import 'package:http/http.dart' as http;

class PostsRepo {
  static Future<List<PostDataUiModel>> fetchPosts() async {
    var client = http.Client();
    List<PostDataUiModel> posts = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos?id=1'));
      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        print(result[i]);
        PostDataUiModel post =
            PostDataUiModel.fromMap(result[i] as Map<String, dynamic>);
        posts.add(post);
      }
      print(posts);
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<bool> addPost(String title) async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/photos'),
          body: {
            "albumId": "1",
            "id": "1",
            "title": title,
            "url": "https://yahoo.com",
            "thumbnailUrl":
                "https://www.google.com/s2/favicons?sz=64&domain_url=yahoo.com"
          });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
