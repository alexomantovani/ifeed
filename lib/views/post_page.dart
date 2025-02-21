import 'package:flutter/material.dart';
import 'package:ifeed/core/services/styles.dart';
import 'package:ifeed/widgets/post_widget.dart';

class PostPage extends StatelessWidget {
  const PostPage({
    super.key,
    required this.title,
    required this.body,
    required this.userId,
    required this.id,
  });

  final String title;
  final String body;
  final int userId;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.kPrimaryBlack,
      appBar: AppBar(
        backgroundColor: Styles.kPrimaryBlack,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Styles.kPrimaryWhite,
          ),
        ),
      ),
      body: PostWidget(
        title: title,
        body: body,
        userId: userId,
        id: id,
        footerWidget: true,
      ),
    );
  }
}
