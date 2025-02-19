import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final num userId;
  final num id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  const Post.empty()
      : this(
          userId: 8,
          id: 80,
          title: 'title',
          body: 'body',
        );

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }

  @override
  List<Object> get props => [userId, id, title, body];
}
