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
    test('Should add a new [LocalPostModel] to [Hive]', () async {
      final localPost = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      await localPostRepository.addPost(localPost);
      final retrievedLocalPost = await localPostRepository.getPostById(99);

      expect(retrievedLocalPost, isNotNull);
      expect(retrievedLocalPost!.id, 99);
      expect(retrievedLocalPost.title, 'New Title');
    });
    test('Should add a [List<LocalPostModel>] to [Hive]', () async {
      final localPosts = [
        LocalPostModel(
          userId: 99,
          id: 99,
          title: 'New Title',
          body: 'New Body',
        ),
        LocalPostModel(
          userId: 99,
          id: 100,
          title: 'New Title',
          body: 'New Body',
        ),
        LocalPostModel(
          userId: 99,
          id: 101,
          title: 'New Title',
          body: 'New Body',
        )
      ];

      await localPostRepository.addPosts(localPosts);
      final retrievedLocalPost = await localPostRepository.getPosts();

      expect(retrievedLocalPost, isNotNull);
      expect(retrievedLocalPost.length, 3);
      expect(retrievedLocalPost[0].id, 99);
      expect(retrievedLocalPost[1].id, 100);
      expect(retrievedLocalPost[2].id, 101);
    });

    test('Should get all saved Tasks', () async {
      await localPostRepository.addPost(LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      ));

      await localPostRepository.addPost(LocalPostModel(
        userId: 99,
        id: 100,
        title: 'New Title',
        body: 'New Body',
      ));

      final localPosts = await localPostRepository.getPosts();

      expect(localPosts.length, 2);
      expect(localPosts[0].id, 99);
      expect(localPosts[1].id, 100);
    });

    group('Case failure', () {
      test('Should not add a LocalPost with a duplicate ID', () async {
        final post1 = LocalPostModel(
          userId: 99,
          id: 99,
          title: 'New Title',
          body: 'New Body',
        );

        final post2 = LocalPostModel(
          userId: 99,
          id: 99,
          title: 'New Title',
          body: 'New Body',
        );

        await localPostRepository.addPost(post1);

        expect(() async => await localPostRepository.addPost(post2),
            throwsA(isA<CacheException>()));
      });

      test('Should return [null] when getting a Task that does not exist',
          () async {
        final retrievedLocalPost = await localPostRepository.getPostById(999);

        expect(retrievedLocalPost, isNull);
      });
    });
  });
}
