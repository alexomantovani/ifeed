part of 'local_post_bloc.dart';

abstract class LocalPostState extends Equatable {
  const LocalPostState();

  @override
  List<Object?> get props => [];
}

class LocalPostInitial extends LocalPostState {}

class LocalPostLoading extends LocalPostState {}

class LocalPostLoaded extends LocalPostState {
  final List<LocalPostModel> localPosts;

  const LocalPostLoaded({required this.localPosts});

  @override
  List<Object?> get props => [localPosts];
}

class LocalPostError extends LocalPostState {
  final String message;

  const LocalPostError({required this.message});

  @override
  List<Object?> get props => [message];
}
