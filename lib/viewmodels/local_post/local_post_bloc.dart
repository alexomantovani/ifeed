import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/local_post_model.dart';
import 'package:ifeed/repositories/local_post_repository.dart';

part 'local_post_event.dart';
part 'local_post_state.dart';

class LocalPostBloc extends Bloc<LocalPostEvent, LocalPostState> {
  final LocalPostRepository localPostRepository;

  LocalPostBloc({required this.localPostRepository})
      : super(LocalPostInitial()) {
    on<SetLocalPostsEvent>(_setLocalPosts);
    on<SetLocalPostEvent>(_setLocalPost);
    on<GetLocalPostsEvent>(_getLocalPosts);
    on<DeleteLocalPostEvent>(_deleteLocalPosts);
    on<EditLocalPostEvent>(_editLocalPosts);
  }

  Future<void> _setLocalPosts(
    SetLocalPostsEvent event,
    Emitter<LocalPostState> emit,
  ) async {
    emit(LocalPostLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await localPostRepository.addPosts(event.localPosts);
      final localPostsLoaded = await localPostRepository.getPosts();

      emit(LocalPostLoaded(localPosts: localPostsLoaded));
    } on CacheException catch (e) {
      emit(LocalPostError(message: e.message));
    } on SerializationException catch (e) {
      emit(LocalPostError(message: e.message));
    } on UnknownException catch (e) {
      emit(LocalPostError(message: e.exception!));
    }
  }

  Future<void> _deleteLocalPosts(
    DeleteLocalPostEvent event,
    Emitter<LocalPostState> emit,
  ) async {
    emit(LocalPostLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await localPostRepository.deletePost(event.localPostId);
      final localPostsLoaded = await localPostRepository.getPosts();

      emit(LocalPostLoaded(localPosts: localPostsLoaded));
    } on CacheException catch (e) {
      emit(LocalPostError(message: e.message));
    } on SerializationException catch (e) {
      emit(LocalPostError(message: e.message));
    } on UnknownException catch (e) {
      emit(LocalPostError(message: e.exception!));
    }
  }

  Future<void> _editLocalPosts(
    EditLocalPostEvent event,
    Emitter<LocalPostState> emit,
  ) async {
    emit(LocalPostLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await localPostRepository.editPost(event.localPostId, event.localPost);
      final localPostsLoaded = await localPostRepository.getPosts();

      emit(LocalPostLoaded(localPosts: localPostsLoaded));
    } on CacheException catch (e) {
      emit(LocalPostError(message: e.message));
    } on SerializationException catch (e) {
      emit(LocalPostError(message: e.message));
    } on UnknownException catch (e) {
      emit(LocalPostError(message: e.exception!));
    }
  }

  Future<void> _setLocalPost(
    SetLocalPostEvent event,
    Emitter<LocalPostState> emit,
  ) async {
    emit(LocalPostLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await localPostRepository.addPost(event.localPost);
      final localPostsLoaded = await localPostRepository.getPosts();

      emit(LocalPostLoaded(localPosts: localPostsLoaded));
    } on CacheException catch (e) {
      emit(LocalPostError(message: e.message));
    } on SerializationException catch (e) {
      emit(LocalPostError(message: e.message));
    } on UnknownException catch (e) {
      emit(LocalPostError(message: e.exception!));
    }
  }

  Future<void> _getLocalPosts(
    GetLocalPostsEvent event,
    Emitter<LocalPostState> emit,
  ) async {
    emit(LocalPostLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    try {
      final localPostsLoaded = await localPostRepository.getPosts();

      emit(LocalPostLoaded(localPosts: localPostsLoaded));
    } on CacheException catch (e) {
      emit(LocalPostError(message: e.message));
    } on SerializationException catch (e) {
      emit(LocalPostError(message: e.message));
    } on UnknownException catch (e) {
      emit(LocalPostError(message: e.exception!));
    }
  }
}
