class SelectionState {
  final int count;
  final int favoriteCount;

  bool get isMultiSelect => count > 0;

  const SelectionState({this.count = 0, this.favoriteCount = 0});
}
