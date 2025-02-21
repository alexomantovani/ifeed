import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/repositories/post_repository.dart';

import '../../models/post_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<AddPostEvent>(_onAddPost);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());

    try {
      final posts = await postRepository.getPosts();
      emit(PostsLoaded(posts: posts));
    } on ServerException catch (e) {
      emit(PostError(message: e.message));
    } on SerializationException catch (e) {
      emit(PostError(message: e.message));
    } on UnknownException catch (e) {
      emit(PostError(message: e.exception!));
    }
  }

  Future<void> _onAddPost(
    AddPostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());

    try {
      final post = await postRepository.addPost(post: event.post);
      emit(PostLoaded(post: post));
    } on ServerException catch (e) {
      emit(PostError(message: e.message));
    } on SerializationException catch (e) {
      emit(PostError(message: e.message));
    } on UnknownException catch (e) {
      emit(PostError(message: e.exception!));
    }
  }
}
