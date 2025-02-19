import 'package:hive/hive.dart';
import 'package:ifeed/core/errors/exceptions.dart';

import '../models/local_post_model.dart';

class LocalPostRepository {
  final Box<LocalPostModel> _localPostsBox;
  LocalPostRepository(this._localPostsBox);

  Future<void> addPost(LocalPostModel localPost) async {
    if (_localPostsBox.containsKey(localPost.id.toInt())) {
      throw CacheException(
        message: 'Local cache error',
        error: 'LocalPost with ID ${localPost.id.toInt()} already exists',
      );
    }
    await _localPostsBox.put(localPost.id.toInt(), localPost);
  }

  Future<void> addPosts(List<LocalPostModel> localPosts) async {
    for (var localPost in localPosts) {
      if (_localPostsBox.containsKey(localPost.id)) {
        throw CacheException(
          message: 'Local cache error',
          error: 'LocalPost with ID ${localPost.id.toInt()} already exists',
        );
      }
    }

    await _localPostsBox.addAll(localPosts);
  }

  Future<List<LocalPostModel>> getPosts() async {
    return Future.value(_localPostsBox.values.toList());
  }

  Future<LocalPostModel?> getPostById(int id) async {
    return _localPostsBox.get(id);
  }
}
