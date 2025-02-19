import 'package:flutter/foundation.dart';

import '../core/enums/local_post_state.dart';
import '../models/local_post_model.dart';
import '../repositories/local_post_repository.dart';

class LocalPostViewModel extends ChangeNotifier {
  final LocalPostRepository _localPostRepository;

  LocalPostViewModel(this._localPostRepository);

  List<LocalPostModel> _posts = [];
  List<LocalPostModel> get posts => _posts;
  LocalPostState _state = LocalPostState.initial;
  LocalPostState get state => _state;

  void restartState() {
    _state = LocalPostState.initial;
  }

  Future<void> _execute(
      Future<void> Function() action, LocalPostState successState) async {
    _state = LocalPostState.loading;
    notifyListeners();

    try {
      await action();
      _state = successState;
    } catch (e) {
      _state = LocalPostState.error;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> getPosts() async {
    await _execute(
      () async {
        await Future.delayed(const Duration(milliseconds: 800));
        _posts = await _localPostRepository.getPosts();
      },
      LocalPostState.loadSuccess,
    );
  }

  Future<void> addPost(LocalPostModel post) async {
    await _execute(
      () async {
        try {
          await _localPostRepository.addPost(post);
          await getPosts();
        } catch (e) {
          rethrow;
        }
      },
      LocalPostState.createSuccess,
    );
  }

  Future<void> addPosts(List<LocalPostModel> posts) async {
    await _execute(
      () async {
        try {
          await _localPostRepository.addPosts(posts);
          await getPosts();
        } catch (e) {
          rethrow;
        }
      },
      LocalPostState.createSuccess,
    );
  }
}
