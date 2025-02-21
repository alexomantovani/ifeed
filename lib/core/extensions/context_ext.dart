import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  TextTheme get textTheme => TextTheme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get width => size.width;

  double get height => size.height;

  double get bottomInsets => mediaQuery.viewInsets.bottom;
}
