enum CellStates {
  notAvailable,
  empty,
  taken;

  int get value {
    switch (this) {
      case CellStates.notAvailable:
        return 2;
      case CellStates.empty:
        return 0;
      case CellStates.taken:
        return 1;
    }
  }
}
