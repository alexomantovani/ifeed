import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/styles.dart';
import '../core/utils/core_utils.dart';
import '../viewmodels/local_post/local_post_bloc.dart';
import '../viewmodels/post/post_bloc.dart';
import '../widgets/add_button_widget.dart';
import '../widgets/feed_widget.dart';
import '../widgets/header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocalPostBloc>(context).add(GetLocalPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) => CoreUtils.postBlocListener(context, state),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Styles.kPrimaryBlack,
          appBar: HeaderWidget(),
          body: FeedWidget(),
          floatingActionButton: AddButtonWidget(),
        ),
      ),
    );
  }
}
