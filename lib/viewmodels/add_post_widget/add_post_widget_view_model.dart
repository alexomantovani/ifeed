import 'package:flutter/material.dart';

class AddPostWidgetViewModel extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;

  final TextEditingController _bodyController = TextEditingController();
  TextEditingController get bodyController => _bodyController;

  final GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> get formKey => _formKey;

  int? _postId;
  int? get postId => _postId;

  int? _userId;
  int? get userId => _userId;

  void initPostId(int? id) {
    _postId = id;
    notifyListeners();
  }

  void initUserId(int? id) {
    _userId = id;
    notifyListeners();
  }

  void clearIds() {
    _postId = null;
    _userId = null;
  }

  void initTitleController(String value) {
    _titleController.text = value;
    notifyListeners();
  }

  void initBodyController(String value) {
    _bodyController.text = value;
    notifyListeners();
  }

  void clearControllers() {
    _titleController.clear();
    _bodyController.clear();
  }

  void disposeAll() {
    clearControllers();
    clearIds();
    notifyListeners();
  }
}
