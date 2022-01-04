import 'dart:ui';

/// Details of the searched text
class MatchedItem {
  //Constructor
  MatchedItem(String text, Rect bounds, int pageIndex){
    this.text = text;
    this.bounds = bounds;
    this.pageIndex = pageIndex;
  }

  //Fields
  /// The searched text.
  late String text;

  /// Rectangle bounds of the searched text.
  late Rect bounds;

  /// Page number of the searched text.
  late int pageIndex;
}

// ignore: avoid_classes_with_only_static_members
/// [MatchedItem] helper
class MatchedItemHelper {
  /// internal method
  static MatchedItem initialize(String text, Rect bounds, int pageIndex) {
    return new MatchedItem(text, bounds, pageIndex);
  }
}
