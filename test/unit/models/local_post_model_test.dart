import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:ifeed/models/local_post_model.dart';

void main() {
  setUpAll(() {
    Hive.registerAdapter(LocalPostModelAdapter());
  });

  group('Case sucess', () {
    test('Should create a [LocalPostModel] correctly', () {
      final localPost = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'title Test',
        body: 'body Test',
      );

      expect(localPost.userId, 99);
      expect(localPost.id, 99);
      expect(localPost.title, 'title Test');
      expect(localPost.body, 'body Test');
    });

    test('Should convert [LocalPostModel] to [JSON] correctly', () {
      final localPost = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'title Test',
        body: 'body Test',
      );

      final json = localPost.toJson();

      expect(json, {
        'userId': 99,
        'id': 99,
        'title': 'title Test',
        'body': 'body Test',
      });
    });

    test('Should convert [JSON] to [LocalPostModel] correctly', () {
      final json = {
        'userId': 99,
        'id': 99,
        'title': 'title Test',
        'body': 'body Test',
      };

      final localPost = LocalPostModel.fromJson(json);

      expect(localPost.userId, 99);
      expect(localPost.id, 99);
      expect(localPost.title, 'title Test');
      expect(localPost.body, 'body Test');
    });

    test('Should create a new [LocalPostModel] applying copyWith', () {
      final localPost = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'title Test',
        body: 'body Test',
      );

      final updatedLocalPost = localPost.copyWith(
        title: 'Uptaded Title',
        body: 'Uptaded Body',
      );

      expect(updatedLocalPost.userId, 99);
      expect(updatedLocalPost.id, 99);
      expect(updatedLocalPost.title, 'Uptaded Title');
      expect(updatedLocalPost.body, 'Uptaded Body');
    });

    test('Should save and retrieve a [LocalPostModel] from [Hive]', () async {
      await setUpTestHive();
      var box = await Hive.openBox<LocalPostModel>('test_local_post');

      final localPost = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'title Test',
        body: 'body Test',
      );

      await box.put(99, localPost);

      final retrievedLocalPost = box.get(99);

      expect(retrievedLocalPost, isNotNull);
      expect(retrievedLocalPost!.id, 99);
      expect(retrievedLocalPost.title, 'title Test');
      expect(retrievedLocalPost.body, 'body Test');

      await box.close();
    });
  });
  group('Case failure', () {
    test(
        'Should throw an [ArgumentError] when converting invalid JSON to LocalPostModel',
        () {
      final json = {
        'userId': 99,
        'id': 99,
        'title': null,
        'body': 'body Test',
      };

      expect(
          () => LocalPostModel.fromJson(json),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Invalid JSON data for LocalPostModel')));
    });

    test('Should throw an [TypeError] when JSON is missing required fields',
        () {
      final json = {
        'userId': 'wrong_type',
        'id': 99,
        'title': 'title Test',
        'body': 'body Test',
      };

      expect(() => LocalPostModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test(
        'Should throw an [TypeError] when retrieving a corrupted LocalPostModel from Hive',
        () async {
      await setUpTestHive();
      var box = await Hive.openBox('test_local_posts');

      await box.put(99, {'invalid': 'data'});

      expect(() => box.get(99) as LocalPostModel, throwsA(isA<TypeError>()));

      await box.close();
    });
  });
}
