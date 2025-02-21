import 'package:hive/hive.dart';

import 'package:ifeed/core/errors/exceptions.dart';
import '../models/local_post_model.dart';

class LocalPostRepository {
  final Box<LocalPostModel> _localPostsBox;
  LocalPostRepository(this._localPostsBox);

  Future<void> addPost(LocalPostModel localPost) async {
    await _localPostsBox.put(_localPostsBox.length,
        localPost.copyWith(id: _localPostsBox.length.toDouble() + 1));
  }

  Future<void> addPosts(List<LocalPostModel> localPosts) async {
    List<LocalPostModel> uniqueLocalPosts = [];

    if (_localPostsBox.values.toList().isNotEmpty) {
      final Set<int> postIds =
          localPosts.map((post) => post.id.toInt()).toSet();
      uniqueLocalPosts = _localPostsBox.values
          .toList()
          .where((localPost) => !postIds.contains(localPost.id.toInt()))
          .toList();
      await _localPostsBox.addAll(uniqueLocalPosts);
    } else {
      await _localPostsBox.addAll(localPosts);
    }
  }

  Future<List<LocalPostModel>> getPosts() async {
    return Future.value(_localPostsBox.values.toList());
  }

  Future<LocalPostModel?> getPostById(int id) async {
    return _localPostsBox.get(id);
  }

  Future<void> deletePost(int id) async {
    if (!_localPostsBox.containsKey(id)) {
      throw CacheException(
        error: 'Post with ID $id not found',
        message: 'Post with ID $id not found',
      );
    }
    await _localPostsBox.delete(id);
  }

  Future<void> editPost(int id, LocalPostModel localPost) async {
    if (!_localPostsBox.containsKey(id)) {
      throw CacheException(
        error: 'Post with ID $id not found',
        message: 'Post with ID $id not found',
      );
    }
    await _localPostsBox.put(id, localPost);
  }
}
