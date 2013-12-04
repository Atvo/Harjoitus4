class Tile {
  int x, y, z, size;
  Side side;
  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side) {

    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
  }

  public void display() {
    fill(255);
    if (isCurrentTile){
      fill(100);
    }
    if (side == Side.FRONT || side == Side.BACK) {
      beginShape();
      vertex(x, y, z);
      vertex(x+size, y, z);
      vertex(x+size, y+size, z);
      vertex(x, y+size, z);
      endShape(CLOSE);
    }
    if (side == Side.TOP || side == Side.BOTTOM) {
      beginShape();
      vertex(x, y, z);
      vertex(x+size, y, z);
      vertex(x+size, y, z+size);
      vertex(x, y, z+size);
      endShape(CLOSE);
    }
    if (side == Side.RIGHT || side == Side.LEFT) {
      beginShape();
      vertex(x, y, z);
      vertex(x, y+size, z);
      vertex(x, y+size, z+size);
      vertex(x, y, z+size);
      endShape(CLOSE);
    }
  }
  
  //laserin piirtäminen tänne
  //on metodit, joilla tiedetään mitkä on viereiset tilet
  //esim: jos laser tulee left naapurista, menee right naapuriin
  
}

