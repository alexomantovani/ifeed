import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ifeed/viewmodels/post/post_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ifeed/core/errors/exceptions.dart';
import 'package:ifeed/models/post_model.dart';
import 'package:ifeed/repositories/post_repository.dart';

import 'post_bloc_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late PostBloc postBloc;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    postBloc = PostBloc(postRepository: mockPostRepository);
  });

  tearDown(() {
    postBloc.close();
  });

  final List<PostModel> mockPosts = [
    PostModel(userId: 1, id: 1, title: 'Post 1', body: 'Body 1'),
    PostModel(userId: 2, id: 2, title: 'Post 2', body: 'Body 2'),
  ];

  final PostModel newPost =
      PostModel(userId: 3, id: 3, title: 'New Post', body: 'New Body');

  group('LoadPostsEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostsLoaded] when loading posts is successful',
      build: () {
        when(mockPostRepository.getPosts()).thenAnswer((_) async => mockPosts);
        return postBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        PostLoading(),
        PostsLoaded(posts: mockPosts),
      ],
      verify: (_) {
        verify(mockPostRepository.getPosts()).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when loading posts throws ServerException',
      build: () {
        when(mockPostRepository.getPosts()).thenThrow(
          ServerException(
            message: 'Server error',
            statusCode: 500,
          ),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        PostLoading(),
        PostError(message: 'Server error'),
      ],
      verify: (_) {
        verify(mockPostRepository.getPosts()).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when loading posts throws SerializationException',
      build: () {
        when(mockPostRepository.getPosts()).thenThrow(
          SerializationException(error: 'Error deserializing model from map.'),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        PostLoading(),
        PostError(message: 'Error deserializing model from map.'),
      ],
      verify: (_) {
        verify(mockPostRepository.getPosts()).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when loading posts throws UnknownException',
      build: () {
        when(mockPostRepository.getPosts()).thenThrow(
          UnknownException(exception: 'Unknown error'),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        PostLoading(),
        PostError(message: 'Unknown error'),
      ],
      verify: (_) {
        verify(mockPostRepository.getPosts()).called(1);
      },
    );
  });

  group('AddPostEvent', () {
    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostLoaded] when adding a post is successful',
      build: () {
        when(mockPostRepository.addPost(post: anyNamed('post')))
            .thenAnswer((_) async => newPost);
        return postBloc;
      },
      act: (bloc) => bloc.add(AddPostEvent(post: newPost)),
      expect: () => [
        PostLoading(),
        PostLoaded(post: newPost),
      ],
      verify: (_) {
        verify(mockPostRepository.addPost(post: newPost)).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when adding a post throws ServerException',
      build: () {
        when(mockPostRepository.addPost(post: anyNamed('post'))).thenThrow(
          ServerException(
            message: 'Server error',
            statusCode: 500,
          ),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(AddPostEvent(post: newPost)),
      expect: () => [
        PostLoading(),
        PostError(message: 'Server error'),
      ],
      verify: (_) {
        verify(mockPostRepository.addPost(post: newPost)).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when adding a post throws SerializationException',
      build: () {
        when(mockPostRepository.addPost(post: anyNamed('post'))).thenThrow(
          SerializationException(error: 'Error deserializing model from map.'),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(AddPostEvent(post: newPost)),
      expect: () => [
        PostLoading(),
        PostError(message: 'Error deserializing model from map.'),
      ],
      verify: (_) {
        verify(mockPostRepository.addPost(post: newPost)).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'should emit [PostLoading, PostError] when adding a post throws UnknownException',
      build: () {
        when(mockPostRepository.addPost(post: anyNamed('post'))).thenThrow(
          UnknownException(exception: 'Unknown error'),
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(AddPostEvent(post: newPost)),
      expect: () => [
        PostLoading(),
        PostError(message: 'Unknown error'),
      ],
      verify: (_) {
        verify(mockPostRepository.addPost(post: newPost)).called(1);
      },
    );
  });
}
