import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/local_post_model.dart';
import 'package:ifeed/repositories/local_post_repository.dart';

void main() {
  late Box<LocalPostModel> localPostModelBox;
  late LocalPostRepository localPostRepository;

  setUpAll(() {
    Hive.registerAdapter(LocalPostModelAdapter());
  });

  setUp(() async {
    await setUpTestHive();
    localPostModelBox = await Hive.openBox<LocalPostModel>('local_posts');
    localPostRepository = LocalPostRepository(localPostModelBox);
  });

  tearDown(() async {
    await localPostModelBox.clear();
    await localPostModelBox.close();
  });

  group('Case success', () {
    test(
        'Should add a new [LocalPostModel] to an existing [List<LocalPostModel>] to [Hive]',
        () async {
      final localPosts = [
        LocalPostModel(
            userId: 99, id: 99, title: 'New Title', body: 'New Body'),
        LocalPostModel(userId: 99, id: 100, title: 'Title 2', body: 'Body 2'),
        LocalPostModel(userId: 99, id: 101, title: 'Title 3', body: 'Body 3'),
      ];

      await localPostRepository.addPosts(localPosts);

      final localPost = LocalPostModel(
        userId: 99,
        id: 102,
        title: 'New Title',
        body: 'New Body',
      );

      await localPostRepository.addPost(localPost);
      final localPostsList = await localPostRepository.getPosts();
      final retrievedLocalPost =
          await localPostRepository.getPostById(localPostsList.length - 1);

      expect(retrievedLocalPost, isNotNull);
      expect(retrievedLocalPost!.id, localPostsList.length - 1);
      expect(retrievedLocalPost.title, 'New Title');
    });

    test('Should add a [List<LocalPostModel>] to [Hive]', () async {
      final localPosts = [
        LocalPostModel(
            userId: 99, id: 99, title: 'New Title', body: 'New Body'),
        LocalPostModel(userId: 99, id: 100, title: 'Title 2', body: 'Body 2'),
        LocalPostModel(userId: 99, id: 101, title: 'Title 3', body: 'Body 3'),
      ];

      await localPostRepository.addPosts(localPosts);
      final retrievedLocalPosts = await localPostRepository.getPosts();

      expect(retrievedLocalPosts, isNotNull);
      expect(retrievedLocalPosts.length, 3);
      expect(retrievedLocalPosts.map((e) => e.id), containsAll([99, 100, 101]));
    });

    test('Should get all saved Posts', () async {
      final localPosts = [
        LocalPostModel(userId: 99, id: 99, title: 'Title 1', body: 'Body 1'),
        LocalPostModel(userId: 99, id: 100, title: 'Title 2', body: 'Body 2'),
      ];

      await localPostRepository.addPosts(localPosts);
      final localPostsRetrieved = await localPostRepository.getPosts();

      expect(localPostsRetrieved.length, 2);
      expect(localPostsRetrieved.map((e) => e.id), containsAll([99, 100]));
    });

    test('Should edit an existing LocalPost', () async {
      await localPostRepository.addPosts([
        LocalPostModel(userId: 99, id: 99, title: 'Title', body: 'Body'),
      ]);

      final updatedPost = LocalPostModel(
          userId: 99, id: 99, title: 'Updated Title', body: 'Updated Body');
      await localPostRepository.editPost(0, updatedPost);

      final retrievedLocalPost = await localPostRepository.getPostById(0);
      expect(retrievedLocalPost, isNotNull);
      expect(retrievedLocalPost!.title, 'Updated Title');
      expect(retrievedLocalPost.body, 'Updated Body');
    });

    test('Should delete an existing LocalPost', () async {
      await localPostRepository.addPosts([
        LocalPostModel(userId: 99, id: 99, title: 'Title', body: 'Body'),
      ]);

      await localPostRepository.deletePost(0);

      final retrievedLocalPost = await localPostRepository.getPostById(0);
      expect(retrievedLocalPost, isNull);
    });
  });

  group('Case failure', () {
    test('Should return [null] when getting a post that does not exist',
        () async {
      final retrievedLocalPost = await localPostRepository.getPostById(999);
      expect(retrievedLocalPost, isNull);
    });

    test('Should throw an error when editing a non-existing LocalPost',
        () async {
      final updatedPost = LocalPostModel(
          userId: 99, id: 999, title: 'Updated Title', body: 'Updated Body');

      expect(() async => await localPostRepository.editPost(999, updatedPost),
          throwsA(isA<CacheException>()));
    });

    test('Should throw an error when deleting a non-existing LocalPost',
        () async {
      expect(() async => await localPostRepository.deletePost(999),
          throwsA(isA<CacheException>()));
    });
  });
}
