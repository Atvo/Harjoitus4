class Tile {
  int x, y, z, size;
  int squareX, squareY;
  Side side;
  // mistä säde tulee
  Side tulo1;
  // minne säde menee
  Side meno1;
  // vaihtoehtoiset, jos jo yksi säde ruudussa
  Side tulo2;
  Side meno2;
  Side [] sides2D;
  
  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side, int squareX, int squareY) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.squareX = squareX;
    this.squareY = squareY;
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
    if (side == Side.FRONT) {
      //TOP, RIGHT, LEFT, FRONT, BACK, BOTTOM
          Side [] sides2D= {Side.TOP, Side.RIGHT, Side.BOTTOM, Side.LEFT};
    }
    else if (side == Side.BACK) {
          Side [] sides2D= {Side.TOP, Side.LEFT, Side.BOTTOM, Side.RIGHT};
    }
    else if (side == Side.RIGHT) {
          Side [] sides2D= {Side.TOP, Side.BACK, Side.BOTTOM, Side.FRONT};
    }
    else if (side == Side.LEFT) {
          Side [] sides2D= {Side.TOP, Side.FRONT, Side.BOTTOM, Side.BACK};
    }    
    else if (side == Side.TOP) {
          Side [] sides2D= {Side.BACK, Side.RIGHT, Side.FRONT, Side.LEFT};
    }
    else if (side == Side.BOTTOM) {
          Side [] sides2D= {Side.FRONT, Side.RIGHT, Side.BACK, Side.LEFT};
    }
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
  
  // TODO: getNeiborandChanceDirectin(side Side)

  
  void setTulo1(Tile tile, Side tulo1){
    tile.tulo1 = tulo1;
  }
  
  int getSide2D (Side fromSide){
    for(int i= 0; i<4; i++){
     if(sides2D[i] == fromSide){
        return i;
     }
    }
    return 0;
  }
  // muuttaa seuraavan tiilen Suunta tulo1 (if null tulo2)
  // ja palauttaa seuraavan tiilen 
  //laserin piirtäminen tänne
  //on metodit, joilla tiedetään mitkä on viereiset tilet
  //esim: jos laser tulee left naapurista, menee right naapuriin
  
}

