extension StringExt on String {
  String get firstToUpper {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
