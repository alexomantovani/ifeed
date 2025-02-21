import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ifeed/views/post_page.dart';

import '../core/extensions/context_ext.dart';
import '../core/utils/core_utils.dart';
import '../viewmodels/local_post/local_post_bloc.dart';
import 'post_widget.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalPostBloc, LocalPostState>(
      listener: (context, state) =>
          CoreUtils.localPostBlocListener(context, state),
      builder: (context, state) {
        if (state is LocalPostLoaded) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: SizedBox(
              width: context.width,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.localPosts.reversed.toList().length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                          id: state.localPosts.reversed
                              .toList()[index]
                              .id
                              .toInt(),
                          title:
                              state.localPosts.reversed.toList()[index].title,
                          body: state.localPosts.reversed.toList()[index].body,
                          userId: state.localPosts.reversed
                                  .toList()[index]
                                  .userId
                                  .toInt() -
                              1),
                    ),
                  ),
                  child: PostWidget(
                    id: state.localPosts.reversed.toList()[index].id.toInt(),
                    userId: state.localPosts.reversed
                            .toList()[index]
                            .userId
                            .toInt() -
                        1,
                    title: state.localPosts.reversed.toList()[index].title,
                    body: state.localPosts.reversed.toList()[index].body,
                  ),
                ),
              ),
            ),
          );
        } else if (state is LocalPostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocalPostError) {
          return Center(
            child: Text(
              state.message,
              style: context.textTheme.titleLarge,
            ),
          );
        } else {
          return Center(
            child: Text(
              'No posts available yet',
              style: context.textTheme.titleLarge,
            ),
          );
        }
      },
    );
  }
}
