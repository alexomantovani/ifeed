import 'package:flutter/foundation.dart';
import 'package:ifeed/core/enums/post_state.dart';
import 'package:ifeed/models/post_model.dart';
import 'package:ifeed/repositories/post_repository.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository _postRepository;

  PostViewModel(this._postRepository);

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  PostState _state = PostState.initial;
  PostState get state => _state;

  void restartState() {
    _state = PostState.initial;
  }

  Future<void> _execute(
      Future<void> Function() action, PostState successState) async {
    _state = PostState.loading;
    notifyListeners();

    try {
      await action();
      _state = successState;
    } catch (e) {
      _state = PostState.error;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> loadPosts() async {
    await _execute(
      () async {
        await Future.delayed(const Duration(milliseconds: 800));
        _posts = await _postRepository.getPosts();
      },
      PostState.loadSuccess,
    );
  }

  Future<void> addPost(PostModel post) async {
    await _execute(
      () async {
        try {
          await _postRepository.addPost(post: post);
          await loadPosts();
        } catch (e) {
          rethrow;
        }
      },
      PostState.createSuccess,
    );
  }
}
