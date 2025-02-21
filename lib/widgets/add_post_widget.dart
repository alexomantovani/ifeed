import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/styles.dart';
import '../models/post_model.dart';
import '../viewmodels/add_post_widget/add_post_widget_view_model.dart';
import '../viewmodels/post/post_bloc.dart';
import 'custom_field_widget.dart';

class AddPostWidget extends StatelessWidget {
  const AddPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPostWidgetViewModel>(
      builder: (context, addPostWidgetViewModel, child) =>
          DraggableScrollableSheet(
        initialChildSize: 0.66,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Styles.kPrimaryWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          height: context.height * 0.66,
          width: context.width,
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: context.bottomInsets,
          ),
          child: Form(
            key: addPostWidgetViewModel.formKey,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                controller: scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Text(
                          'New Post',
                          style: context.textTheme.titleLarge!.copyWith(
                            color: Styles.kPrimaryGrey,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        CustomFieldWidget(
                          controller: addPostWidgetViewModel.titleController,
                          hintText: 'Post title',
                        ),
                        const SizedBox(height: 32.0),
                        CustomFieldWidget(
                          controller: addPostWidgetViewModel.bodyController,
                          hintText: 'Post body',
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Descartar',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (addPostWidgetViewModel.formKey.currentState!
                                    .validate()) {
                                  BlocProvider.of<PostBloc>(context).add(
                                    AddPostEvent(
                                      post: PostModel(
                                        userId: Random().nextInt(10) + 1,
                                        id: 0,
                                        title: addPostWidgetViewModel
                                            .titleController.text,
                                        body: addPostWidgetViewModel
                                            .bodyController.text,
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Publicar',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
