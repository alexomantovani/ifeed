import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/local_post_model.dart';
import '../../viewmodels/local_post/local_post_bloc.dart';
import '../../viewmodels/post/post_bloc.dart';
import '../errors/exceptions.dart';

class CoreUtils {
  const CoreUtils._();

  static bool containsRequiredKeys(
      Map<String, dynamic> map, List<String> requiredKeys) {
    return requiredKeys.every((key) => map.containsKey(key));
  }

  static throwsSerializationException(
      {required Map<String, dynamic> map, required List<String> requiredKeys}) {
    if (!containsRequiredKeys(map, requiredKeys)) {
      throw SerializationException(
        error:
            'One or more required fields are missing: ${requiredKeys.where((key) => !map.containsKey(key)).join(', ')}.',
      );
    }
  }

  static void openModal({
    required BuildContext context,
    required Widget child,
    void Function()? action,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => child,
    );
  }

  static void postBlocListener(BuildContext context, PostState state) {
    if (state is PostsLoaded) {
      if (state.posts.isNotEmpty) {
        BlocProvider.of<LocalPostBloc>(context).add(
          SetLocalPostsEvent(
            localPosts: state.posts
                .map(
                  (post) => LocalPostModel(
                    userId: post.userId.toDouble(),
                    id: post.id.toDouble(),
                    title: post.title,
                    body: post.body,
                  ),
                )
                .toList(),
          ),
        );
      }
    } else if (state is PostLoaded) {
      BlocProvider.of<LocalPostBloc>(context).add(
        SetLocalPostEvent(
          localPost: LocalPostModel(
            userId: state.post.userId.toDouble(),
            id: state.post.id.toDouble(),
            title: state.post.title,
            body: state.post.body,
          ),
        ),
      );
    }
  }

  static void localPostBlocListener(
      BuildContext context, LocalPostState state) {
    if (state is LocalPostLoaded) {
      if (state.localPosts.isEmpty) {
        BlocProvider.of<PostBloc>(context).add(LoadPostsEvent());
      }
    }
  }
}
