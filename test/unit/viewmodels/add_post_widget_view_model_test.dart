import 'package:flutter_test/flutter_test.dart';

import 'package:ifeed/viewmodels/add_post_widget/add_post_widget_view_model.dart';

void main() {
  late AddPostWidgetViewModel viewModel;

  setUp(() {
    viewModel = AddPostWidgetViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('ID Management', () {
    test('Should initialize postId correctly', () {
      viewModel.initPostId(10);
      expect(viewModel.postId, 10);
    });

    test('Should initialize userId correctly', () {
      viewModel.initUserId(5);
      expect(viewModel.userId, 5);
    });

    test('Should clear postId and userId', () {
      viewModel.initPostId(10);
      viewModel.initUserId(5);

      viewModel.clearIds();

      expect(viewModel.postId, isNull);
      expect(viewModel.userId, isNull);
    });
  });

  group('Title and Body Controller', () {
    test('Should initialize titleController correctly', () {
      viewModel.initTitleController("Test Title");
      expect(viewModel.titleController.text, "Test Title");
    });

    test('Should initialize bodyController correctly', () {
      viewModel.initBodyController("Test Body");
      expect(viewModel.bodyController.text, "Test Body");
    });

    test('Should clear titleController and bodyController', () {
      viewModel.initTitleController("Test Title");
      viewModel.initBodyController("Test Body");

      viewModel.clearControllers();

      expect(viewModel.titleController.text, isEmpty);
      expect(viewModel.bodyController.text, isEmpty);
    });
  });

  group('DisposeAll', () {
    test('Should clear all controllers and IDs', () {
      viewModel.initPostId(10);
      viewModel.initUserId(5);
      viewModel.initTitleController("Test Title");
      viewModel.initBodyController("Test Body");

      viewModel.disposeAll();

      expect(viewModel.postId, isNull);
      expect(viewModel.userId, isNull);
      expect(viewModel.titleController.text, isEmpty);
      expect(viewModel.bodyController.text, isEmpty);
    });
  });

  group('Notify Listeners', () {
    test('Should notify listeners when postId is updated', () {
      bool wasNotified = false;
      viewModel.addListener(() {
        wasNotified = true;
      });

      viewModel.initPostId(10);

      expect(wasNotified, isTrue);
    });

    test('Should notify listeners when userId is updated', () {
      bool wasNotified = false;
      viewModel.addListener(() {
        wasNotified = true;
      });

      viewModel.initUserId(5);

      expect(wasNotified, isTrue);
    });

    test('Should notify listeners when titleController is updated', () {
      bool wasNotified = false;
      viewModel.addListener(() {
        wasNotified = true;
      });

      viewModel.initTitleController("Test Title");

      expect(wasNotified, isTrue);
    });

    test('Should notify listeners when bodyController is updated', () {
      bool wasNotified = false;
      viewModel.addListener(() {
        wasNotified = true;
      });

      viewModel.initBodyController("Test Body");

      expect(wasNotified, isTrue);
    });

    test('Should notify listeners when disposeAll is called', () {
      bool wasNotified = false;
      viewModel.addListener(() {
        wasNotified = true;
      });

      viewModel.disposeAll();

      expect(wasNotified, isTrue);
    });
  });
}
