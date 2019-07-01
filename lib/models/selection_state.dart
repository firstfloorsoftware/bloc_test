class SelectionState {
  final int count;
  final int favoriteCount;
  final bool allSelected;

  bool get isSelecting => count > 0;

  const SelectionState({this.count = 0, this.favoriteCount = 0, this.allSelected});
}
