int findCellRow(int quadrant, int index) => (quadrant ~/ 3) * 3 + (index ~/ 3);

int findCellCol(int quadrant, int index) => (quadrant % 3) * 3 + (index % 3);
