import 'package:flutter_test/flutter_test.dart';
import 'package:ifeed/core/enums/post_state.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/post_model.dart';
import 'package:ifeed/repositories/post_repository.dart';
import 'package:ifeed/viewmodels/post_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_view_model_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository mockPostRepository;
  late PostViewModel postViewModel;

  setUp(() {
    mockPostRepository = MockPostRepository();
    postViewModel = PostViewModel(mockPostRepository);
  });

  group('Case success', () {
    test('Should load Posts correctly', () async {
      final posts = [
        PostModel(
          userId: 99,
          id: 99,
          title: 'New Title',
          body: 'New Body',
        ),
        PostModel(
          userId: 99,
          id: 100,
          title: 'New Title',
          body: 'New Body',
        ),
      ];

      when(mockPostRepository.getPosts()).thenAnswer((_) async => posts);

      await postViewModel.loadPosts();

      expect(postViewModel.posts.length, 2);
      expect(postViewModel.posts.first.id, 99);
      expect(postViewModel.posts.last.id, 100);
    });

    test('Should add a new Post and update the current List', () async {
      final post = PostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockPostRepository.addPost(post: post))
          .thenAnswer((_) async => post);
      when(mockPostRepository.getPosts()).thenAnswer((_) async => [post]);

      await postViewModel.addPost(post);

      expect(postViewModel.posts.length, 1);
      expect(postViewModel.posts.first.id, 99);
      verify(mockPostRepository.addPost(post: post)).called(1);
    });
  });

  group('Case Failure', () {
    test('Should handle failure when loading posts due to server error',
        () async {
      when(mockPostRepository.getPosts()).thenThrow(ServerException(
        message: 'Server error',
        statusCode: 500,
      ));

      try {
        await postViewModel.loadPosts();
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when loading posts due to invalid response',
        () async {
      when(mockPostRepository.getPosts()).thenThrow(ServerException(
        message: 'Missing required data from server',
        statusCode: 1,
      ));

      try {
        await postViewModel.loadPosts();
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when loading posts due to invalid response',
        () async {
      when(mockPostRepository.getPosts()).thenThrow(ServerException(
        message: 'Missing required data from server',
        statusCode: 1,
      ));

      try {
        await postViewModel.loadPosts();
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when loading posts due to unknown error',
        () async {
      when(mockPostRepository.getPosts()).thenThrow(Exception('Unknown error'));

      try {
        await postViewModel.loadPosts();
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to server error',
        () async {
      final post = PostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockPostRepository.addPost(post: post)).thenThrow(ServerException(
        message: 'Server error',
        statusCode: 500,
      ));

      try {
        await postViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to invalid response',
        () async {
      final post = PostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockPostRepository.addPost(post: post)).thenThrow(ServerException(
        message: 'Invalid response',
        statusCode: 400,
      ));

      try {
        await postViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to unknown error',
        () async {
      final post = PostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockPostRepository.addPost(post: post))
          .thenThrow(Exception('Unknown error'));

      try {
        await postViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(postViewModel.state, PostState.error);
      expect(postViewModel.posts, isEmpty);
    });
  });
}
