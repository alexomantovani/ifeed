import 'package:ifeed/core/utils/core_utils.dart';
import 'package:ifeed/core/utils/typedefs.dart';
import 'package:ifeed/entities/post.dart';

import '../core/errors/exceptions.dart';
import '../core/utils/constants.dart';

class PostModel extends Post {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
  });

  const PostModel.empty()
      : this(
          userId: 8,
          id: 80,
          title: 'title',
          body: 'body',
        );

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      userId: post.userId,
      id: post.id,
      title: post.title,
      body: post.body,
    );
  }

  Post toEntity() {
    return Post(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }

  PostModel copyWith({
    num? userId,
    num? id,
    String? title,
    String? body,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromMap(DataMap map) {
    try {
      CoreUtils.throwsSerializationException(
        map: map,
        requiredKeys: Constants.keysList,
      );

      return PostModel(
        userId: map['userId'] as num,
        id: map['id'] as num,
        title: map['title'] as String,
        body: map['body'] as String,
      );
    } catch (e) {
      throw SerializationException(
        error: e.toString(),
      );
    }
  }

  @override
  String toString() {
    return 'PostModel(userId: $userId, id: $id, title: $title, body: $body)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.id == id &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ id.hashCode ^ title.hashCode ^ body.hashCode;
  }
}
