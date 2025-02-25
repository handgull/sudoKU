// This methods are repeated and not imported from the source
// tests should not dependend on the source code

int tfindCellRow(int quadrant, int index) => (quadrant ~/ 3) * 3 + (index ~/ 3);

int tfindCellCol(int quadrant, int index) => (quadrant % 3) * 3 + (index % 3);
