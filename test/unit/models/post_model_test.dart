import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/core/utils/typedefs.dart';
import 'package:ifeed/entities/post.dart';
import 'package:ifeed/models/post_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tPostModel = PostModel.empty();

  test(
    'should be a subclass of [Post] entity',
    () => expect(tPostModel, isA<Post>()),
  );

  final tMap = jsonDecode(fixture('post.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [PostModel] from the map', () {
      final result = PostModel.fromMap(tMap);
      expect(result, isA<PostModel>());
      expect(result, tPostModel);
    });

    test('should throw an [SerializationException] when the map is invalid',
        () {
      final map = DataMap.from(tMap)..remove('id');

      const methodCall = PostModel.fromMap;

      expect(() => methodCall(map), throwsA(isA<SerializationException>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from PostModel', () {
      final result = tPostModel.toMap();

      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [PostModel] with updated values', () {
      final result = tPostModel.copyWith(title: 'New Title');

      expect(result, isA<PostModel>());
      expect(result.title, 'New Title');
    });
  });

  group('toString', () {
    test('should have correct toString implementation', () {
      expect(
        tPostModel.toString(),
        'PostModel(userId: 8, id: 80, title: title, body: body)',
      );
    });
  });

  group('fromEntity toEntity', () {
    test('should convert from Post entity correctly', () {
      const postEntity = Post(userId: 99, id: 99, title: 'title', body: 'body');

      final postModel = PostModel.fromEntity(postEntity);

      expect(postModel.userId, postEntity.userId);
      expect(postModel.id, postEntity.id);
      expect(postModel.title, postEntity.title);
      expect(postModel.body, postEntity.body);
    });

    test('should convert to Post entity correctly', () {
      final postModel = PostModel.empty();
      final postEntity = postModel.toEntity();

      expect(postEntity.userId, postModel.userId);
      expect(postEntity.id, postModel.id);
      expect(postEntity.title, postModel.title);
      expect(postEntity.body, postModel.body);
    });
  });
}
