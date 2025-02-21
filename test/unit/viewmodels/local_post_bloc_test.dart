import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ifeed/viewmodels/local_post/local_post_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/local_post_model.dart';
import 'package:ifeed/repositories/local_post_repository.dart';

import 'local_post_bloc_test.mocks.dart';

@GenerateMocks([LocalPostRepository])
void main() {
  late LocalPostBloc localPostBloc;
  late MockLocalPostRepository mockLocalPostRepository;

  setUp(() {
    mockLocalPostRepository = MockLocalPostRepository();
    localPostBloc = LocalPostBloc(localPostRepository: mockLocalPostRepository);
  });

  tearDown(() {
    localPostBloc.close();
  });

  final List<LocalPostModel> mockLocalPosts = [
    LocalPostModel(userId: 1, id: 1, title: 'Post 1', body: 'Body 1'),
    LocalPostModel(userId: 2, id: 2, title: 'Post 2', body: 'Body 2'),
  ];

  final LocalPostModel newLocalPost =
      LocalPostModel(userId: 3, id: 3, title: 'New Post', body: 'New Body');

  group('GetLocalPostsEvent', () {
    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostLoaded] when loading local posts is successful',
      build: () {
        when(mockLocalPostRepository.getPosts())
            .thenAnswer((_) async => mockLocalPosts);
        return localPostBloc;
      },
      act: (bloc) => bloc.add(GetLocalPostsEvent()),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostLoaded(localPosts: mockLocalPosts),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.getPosts()).called(1);
      },
    );

    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostError] when loading posts throws CacheException',
      build: () {
        when(mockLocalPostRepository.getPosts()).thenThrow(
            CacheException(error: 'Error deserializing model from map.'));
        return localPostBloc;
      },
      act: (bloc) => bloc.add(GetLocalPostsEvent()),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostError(message: 'Error deserializing model from map.'),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.getPosts()).called(1);
      },
    );
  });

  group('SetLocalPostEvent', () {
    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostLoaded] when adding a local post is successful',
      build: () {
        when(mockLocalPostRepository.addPost(any))
            .thenAnswer((_) async => Future.value());
        when(mockLocalPostRepository.getPosts())
            .thenAnswer((_) async => [newLocalPost]);
        return localPostBloc;
      },
      act: (bloc) => bloc.add(SetLocalPostEvent(localPost: newLocalPost)),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostLoaded(localPosts: [newLocalPost]),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.addPost(newLocalPost)).called(1);
        verify(mockLocalPostRepository.getPosts()).called(1);
      },
    );
  });

  group('EditLocalPostEvent', () {
    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostLoaded] when editing a local post is successful',
      build: () {
        when(mockLocalPostRepository.editPost(any, any))
            .thenAnswer((_) async => Future.value());
        when(mockLocalPostRepository.getPosts())
            .thenAnswer((_) async => [newLocalPost]);
        return localPostBloc;
      },
      act: (bloc) =>
          bloc.add(EditLocalPostEvent(localPostId: 3, localPost: newLocalPost)),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostLoaded(localPosts: [newLocalPost]),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.editPost(3, newLocalPost)).called(1);
        verify(mockLocalPostRepository.getPosts()).called(1);
      },
    );

    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostError] when editing a post throws CacheException',
      build: () {
        when(mockLocalPostRepository.editPost(any, any)).thenThrow(
            CacheException(error: 'Error deserializing model from map.'));
        return localPostBloc;
      },
      act: (bloc) =>
          bloc.add(EditLocalPostEvent(localPostId: 3, localPost: newLocalPost)),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostError(message: 'Error deserializing model from map.'),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.editPost(3, newLocalPost)).called(1);
      },
    );
  });

  group('DeleteLocalPostEvent', () {
    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostLoaded] when deleting a local post is successful',
      build: () {
        when(mockLocalPostRepository.deletePost(any))
            .thenAnswer((_) async => Future.value());
        when(mockLocalPostRepository.getPosts()).thenAnswer((_) async => []);
        return localPostBloc;
      },
      act: (bloc) => bloc.add(DeleteLocalPostEvent(localPostId: 1)),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostLoaded(localPosts: []),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.deletePost(1)).called(1);
        verify(mockLocalPostRepository.getPosts()).called(1);
      },
    );

    blocTest<LocalPostBloc, LocalPostState>(
      'should emit [LocalPostLoading, LocalPostError] when deleting a post throws CacheException',
      build: () {
        when(mockLocalPostRepository.deletePost(any)).thenThrow(
            CacheException(error: 'Error deserializing model from map.'));
        return localPostBloc;
      },
      act: (bloc) => bloc.add(DeleteLocalPostEvent(localPostId: 1)),
      wait: const Duration(milliseconds: 1600),
      expect: () => [
        LocalPostLoading(),
        LocalPostError(message: 'Error deserializing model from map.'),
      ],
      verify: (_) {
        verify(mockLocalPostRepository.deletePost(1)).called(1);
      },
    );
  });
}
