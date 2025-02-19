import 'package:hive/hive.dart';

part 'local_post_model.g.dart';

@HiveType(typeId: 2)
class LocalPostModel extends HiveObject {
  @HiveField(0)
  final double userId;

  @HiveField(1)
  final double id;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  LocalPostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  LocalPostModel copyWith({
    double? userId,
    double? id,
    String? title,
    String? body,
  }) {
    return LocalPostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory LocalPostModel.fromJson(Map<String, dynamic> map) {
    if (map['userId'] == null ||
        map['id'] == null ||
        map['title'] == null ||
        map['body'] == null) {
      throw ArgumentError('Invalid JSON data for LocalPostModel');
    }

    if (map['userId'] is! num ||
        map['id'] is! num ||
        map['title'] is! String ||
        map['body'] is! String) {
      throw TypeError();
    }

    return LocalPostModel(
      userId: (map['userId'] as num).toDouble(),
      id: (map['id'] as num).toDouble(),
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }
}
