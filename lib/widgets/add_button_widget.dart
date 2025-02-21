import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/core_utils.dart';
import '../viewmodels/add_post_widget/add_post_widget_view_model.dart';
import 'add_post_widget.dart';
import '../core/services/styles.dart';

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<AddPostWidgetViewModel>().initTitleController('');
        context.read<AddPostWidgetViewModel>().initBodyController('');
        context.read<AddPostWidgetViewModel>().initPostId(null);
        context.read<AddPostWidgetViewModel>().initUserId(null);
        CoreUtils.openModal(
          context: context,
          child: AddPostWidget(),
          action: () => context.read<AddPostWidgetViewModel>().disposeAll(),
        );
      },
      backgroundColor: Styles.kPrimaryBlueLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.add,
        color: Styles.kPrimaryWhite,
        size: 32.0,
      ),
    );
  }
}
