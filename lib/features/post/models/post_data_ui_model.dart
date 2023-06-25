import 'dart:convert';

class PostDataUiModel {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  PostDataUiModel(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  Map<String, dynamic> toMap() {
    return {
      "albumId": albumId,
      "id": id,
      "title": title,
      "url": url,
      "thumbnailUrl": thumbnailUrl,
    };
  }

  factory PostDataUiModel.fromMap(Map<String, dynamic> map) {
    return PostDataUiModel(
      albumId: map["albumId"],
      id: map["id"],
      title: map["title"],
      url: map["url"],
      thumbnailUrl: map["thumbnailUrl"],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostDataUiModel.fromJson(String source) =>
      PostDataUiModel.fromMap(json.decode(source));
}
