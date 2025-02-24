// Utility methods to get the position of the cell in the global matrix
// given the indexes from the quadrant

int findCellRow(int quadrant, int index) => (quadrant ~/ 3) * 3 + (index ~/ 3);

int findCellCol(int quadrant, int index) => (quadrant % 3) * 3 + (index % 3);
