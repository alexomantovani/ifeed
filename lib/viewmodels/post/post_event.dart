part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostEvent {}

class AddPostEvent extends PostEvent {
  final PostModel post;

  const AddPostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}
