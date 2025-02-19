import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ifeed/core/environments/environments.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/post_model.dart';
import 'package:ifeed/repositories/post_repository.dart';

import 'post_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late PostRepository repository;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    repository = PostRepository(client: mockClient);
  });

  final List<PostModel> postModelList = [PostModel.empty()];

  final String url = '${Environments.prod}/posts';

  group('getPosts', () {
    test(
        'Should return a [List<PostModel>] when the call is successful and the data is valid',
        () async {
      when(mockClient.get(Uri.parse(url))).thenAnswer((_) async =>
          http.Response(
              jsonEncode(postModelList.map((m) => m.toMap()).toList()), 200));

      final result = await repository.getPosts();

      expect(result, isA<List<PostModel>>());
      expect(result.length, 1);
      expect(result.first.title, 'title');
    });

    test('Should throw [ServerException] when data is missing', () async {
      when(mockClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response(jsonEncode({}), 200));

      expect(() => repository.getPosts(), throwsA(isA<ServerException>()));
    });

    test('Should throw [ServerException] when data is null', () async {
      when(mockClient.get(Uri.parse(url))).thenAnswer(
          (_) async => http.Response(jsonEncode({"data": null}), 200));

      expect(() => repository.getPosts(), throwsA(isA<ServerException>()));
    });

    test('Should throw [ServerException] when data is empty', () async {
      when(mockClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response(jsonEncode([]), 200));

      expect(() => repository.getPosts(), throwsA(isA<ServerException>()));
    });

    test('Should throw [ServerException] when call is unsuccessful', () async {
      when(mockClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      expect(() => repository.getPosts(), throwsA(isA<ServerException>()));
    });

    test('Should throw [UnknownException] in case of unexpected error',
        () async {
      when(mockClient.get(Uri.parse(url)))
          .thenThrow(Exception('Unknown error'));

      expect(() => repository.getPosts(), throwsA(isA<UnknownException>()));
    });
  });
  group('addPost', () {
    final post = PostModel.empty();
    test(
        'Should return a [PostModel] when the call is successful and the data is valid',
        () async {
      when(mockClient.post(Uri.parse(url), body: post.toMap())).thenAnswer(
          (_) async => http.Response(
              jsonEncode(postModelList.map((m) => m.toMap()).first), 201));

      final result = await repository.addPost(post: post);

      expect(result, isA<PostModel>());
      expect(result.title, 'title');
    });

    test('Should throw [ServerException] when data is missing', () async {
      when(mockClient.post(Uri.parse(url), body: post.toMap()))
          .thenAnswer((_) async => http.Response(jsonEncode({}), 201));

      expect(() => repository.addPost(post: post),
          throwsA(isA<ServerException>()));
    });

    test('Should throw [ServerException] when data is null', () async {
      when(mockClient.post(Uri.parse(url), body: post.toMap()))
          .thenAnswer((_) async => http.Response(jsonEncode(null), 201));

      expect(() => repository.addPost(post: post),
          throwsA(isA<ServerException>()));
    });

    test('Should throw [ServerException] when call is unsuccessful', () async {
      when(mockClient.post(Uri.parse(url), body: post.toMap()))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      expect(() => repository.addPost(post: post),
          throwsA(isA<ServerException>()));
    });

    test('Should throw [UnknownException] in case of unexpected error',
        () async {
      when(mockClient.post(Uri.parse(url), body: post.toMap()))
          .thenThrow(Exception('Unknown error'));

      expect(() => repository.addPost(post: post),
          throwsA(isA<UnknownException>()));
    });
  });
}
