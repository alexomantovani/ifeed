import 'package:flutter_test/flutter_test.dart';
import 'package:ifeed/core/enums/local_post_state.dart';
import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/local_post_model.dart';

import 'package:ifeed/repositories/local_post_repository.dart';
import 'package:ifeed/viewmodels/local_post_view_model.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_post_view_model_test.mocks.dart';

@GenerateMocks([LocalPostRepository])
void main() {
  late MockLocalPostRepository mockLocalPostRepository;
  late LocalPostViewModel localPostViewModel;

  setUp(() {
    mockLocalPostRepository = MockLocalPostRepository();
    localPostViewModel = LocalPostViewModel(mockLocalPostRepository);
  });

  group('Case success', () {
    test('Should get [List<LocalPostModel>] correctly', () async {
      final posts = [
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
      ];

      when(mockLocalPostRepository.getPosts()).thenAnswer((_) async => posts);

      await localPostViewModel.getPosts();

      expect(localPostViewModel.posts.length, 2);
      expect(localPostViewModel.posts.first.id, 99);
      expect(localPostViewModel.posts.last.id, 100);
    });

    test('Should add a new [LocalPost] and update the current List', () async {
      final post = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockLocalPostRepository.addPost(post)).thenAnswer((_) async => post);
      when(mockLocalPostRepository.getPosts()).thenAnswer((_) async => [post]);

      await localPostViewModel.addPost(post);

      expect(localPostViewModel.posts.length, 1);
      expect(localPostViewModel.posts.first.id, 99);
      verify(mockLocalPostRepository.addPost(post)).called(1);
    });

    test('Should add a [List<LocalPostModel>] and update the current List',
        () async {
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
        ),
      ];

      when(mockLocalPostRepository.addPosts(localPosts))
          .thenAnswer((_) async => {});
      when(mockLocalPostRepository.getPosts())
          .thenAnswer((_) async => localPosts);

      await localPostViewModel.addPosts(localPosts);

      expect(localPostViewModel.posts.length, 3);
      expect(localPostViewModel.posts[0].id, 99);
      expect(localPostViewModel.posts[1].id, 100);
      expect(localPostViewModel.posts[2].id, 101);
    });
  });

  group('Case Failure', () {
    test('Should handle failure when loading posts due to unknown error',
        () async {
      when(mockLocalPostRepository.getPosts())
          .thenThrow(Exception('Unknown error'));

      try {
        await localPostViewModel.getPosts();
      } catch (e) {
        // Exceção esperada
      }

      expect(localPostViewModel.state, LocalPostState.error);
      expect(localPostViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to server error',
        () async {
      final post = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockLocalPostRepository.addPost(post)).thenThrow(CacheException(
          message: 'Local cache error', error: 'Local cache error'));

      try {
        await localPostViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(localPostViewModel.state, LocalPostState.error);
      expect(localPostViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to invalid response',
        () async {
      final post = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockLocalPostRepository.addPost(post)).thenThrow(CacheException(
          message: 'Local cache error', error: 'Local cache error'));

      try {
        await localPostViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(localPostViewModel.state, LocalPostState.error);
      expect(localPostViewModel.posts, isEmpty);
    });

    test('Should handle failure when adding a post due to unknown error',
        () async {
      final post = LocalPostModel(
        userId: 99,
        id: 99,
        title: 'New Title',
        body: 'New Body',
      );

      when(mockLocalPostRepository.addPost(post))
          .thenThrow(UnknownException(exception: 'Unknown error'));

      try {
        await localPostViewModel.addPost(post);
      } catch (e) {
        // Exceção esperada
      }

      expect(localPostViewModel.state, LocalPostState.error);
      expect(localPostViewModel.posts, isEmpty);
    });
  });
}
