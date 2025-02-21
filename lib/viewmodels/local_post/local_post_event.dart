part of 'local_post_bloc.dart';

abstract class LocalPostEvent extends Equatable {
  const LocalPostEvent();

  @override
  List<Object?> get props => [];
}

class SetLocalPostsEvent extends LocalPostEvent {
  final List<LocalPostModel> localPosts;

  const SetLocalPostsEvent({required this.localPosts});

  @override
  List<Object?> get props => [localPosts];
}

class SetLocalPostEvent extends LocalPostEvent {
  final LocalPostModel localPost;

  const SetLocalPostEvent({required this.localPost});

  @override
  List<Object?> get props => [localPost];
}

class DeleteLocalPostEvent extends LocalPostEvent {
  final int localPostId;

  const DeleteLocalPostEvent({required this.localPostId});

  @override
  List<Object?> get props => [localPostId];
}

class EditLocalPostEvent extends LocalPostEvent {
  final int localPostId;
  final LocalPostModel localPost;

  const EditLocalPostEvent(
      {required this.localPostId, required this.localPost});

  @override
  List<Object?> get props => [localPostId, localPost];
}

class GetLocalPostsEvent extends LocalPostEvent {
  const GetLocalPostsEvent();
}
