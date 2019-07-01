class SelectionState {
  final int count;
  final int favoriteCount;

  bool get isSelecting => count > 0;

  const SelectionState({this.count = 0, this.favoriteCount = 0});
}
