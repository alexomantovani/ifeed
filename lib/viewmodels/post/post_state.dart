part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final PostModel post;

  const PostLoaded({required this.post});

  @override
  List<Object?> get props => [post];
}

class PostsLoaded extends PostState {
  final List<PostModel> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}
