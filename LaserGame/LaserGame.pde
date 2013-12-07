float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
Tile[][][] tiles;
Edge [] edges;
Square front, back, right, left, top, bottom;
int tileSize, cubeSize;
//kuution reunojen koordinaatit
int max;
Tile currentTile;

void setup() {
  size(640, 360, P3D);
  this.tileSize = 20;
  this.cubeSize = 10;
  frontTiles = new Tile [cubeSize][cubeSize];
  backTiles = new Tile [cubeSize][cubeSize];
  rightTiles = new Tile [cubeSize][cubeSize];
  leftTiles = new Tile [cubeSize][cubeSize];
  topTiles = new Tile [cubeSize][cubeSize];
  bottomTiles = new Tile [cubeSize][cubeSize];
  tiles = new Tile [6][cubeSize][cubeSize];
  int max = cubeSize*tileSize/2;
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      frontTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k);
      tiles[0][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k);
    }
  }
  front = new Square(Side.FRONT, -max, -max, max, -max, max, max, max, -max, max, max, max, max);

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      backTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
      tiles[1][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
    }
  }
  back = new Square(Side.BACK, -max, -max, -max, -max, max, -max, max, -max, -max, max, max, -max);  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      rightTiles[i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
      tiles[2][i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
    }
  }
  right = new Square(Side.RIGHT, max, -max, -max, max, max, -max, max, -max, max, max, -max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      leftTiles[i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
      tiles[3][i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
    }
  }
  left = new Square(Side.LEFT, -max, -max, -max, -max, max, -max, -max, -max, max, max, max, -max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      topTiles[i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
      tiles[4][i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
    }
  }
  top = new Square(Side.TOP, -max, max, -max, -max, max, max, max, max, -max, max, max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      bottomTiles[i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k);
      tiles[5][i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k);
    }
  }
  bottom = new Square(Side.TOP, -max, -max, -max, -max, -max, max, max, -max, -max, max, -max, max);
}

void draw() {
  background(0);
  //noStroke();

  directionalLight(51, 102, 126, -1, 0, 0);  
  directionalLight(51, 102, 126, 0, -1, 0);
  pointLight(51, 102, 126, 35, 40, 36);
  spotLight(51, 102, 126, 80, 20, 40, -1, 0, 0, PI/2, 2); 

  translate(width/2.0, height/2.0, -100);
  rotateX(rotx);
  rotateY(roty);
  //scale(90);
  checkCurrentTile();
  for (int l = 0; l < 6; l++) {
    for (int i = 0; i < cubeSize; i++) {
      for (int k = 0; k < cubeSize; k++) {
        tiles[l][i][k].display();
      }
    }
  }
  /*for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   frontTiles[i][k].display();
   }
   }
   for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   backTiles[i][k].display();
   }
   }
   for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   rightTiles[i][k].display();
   }
   }
   for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   leftTiles[i][k].display();
   }
   }
   for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   topTiles[i][k].display();
   }
   }
   for(int i = 0; i < cubeSize; i++){
   for(int k = 0; k < cubeSize; k++){
   bottomTiles[i][k].display();
   }
   }*/
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}


void alustaEdges() {
  edges = new Edge [12];
}

void checkCurrentTile() {
  Tile tmpTile = null;
  //Tarkistetaan onko nykyinen laatta edelleen valittu, jos on, return

  //Jos ei niin etsitään nykyinen laatta
  for (int l = 0; l < 6; l++) {
    for (int i = 0; i < cubeSize; i++) {
      for (int k = 0; k < cubeSize; k++) {
        tmpTile = tiles[l][i][k];
        // Jotenkin tarkistetaan hiiren, kameran ja laatan koordinaattien avulla, onko hiiri laatan päällä
        // Huom kuutiota ollaan voitu pyörittää!
      }
    }
  }
}

//TOP, RIGHT, LEFT, FRONT, BACK, BOTTOM

Tile getTileNeighbor(Tile tile, int side2Dto) {
  Tile [][] myTiles = new Tile [cubeSize][cubeSize];
  boolean overEdge = false;
  // mentäessä kulman yli reunan pääte ja alkupiste
  int x1, y1, z1;
  int x2, y2, z2;
  int side2D = 10 ;
  // tarkistetaan ollaanko menossa reunan yli 
  if (tile.squareY == 0 && side2D==0) {
    overEdge = true;
  }
  else if (tile.squareY == (cubeSize-1) && side2D==2) {
    overEdge = true;
  }
  else if (tile.squareX == (cubeSize-1) && side2D==1) {
    overEdge = true;
  }
  else if (tile.squareX == 0 && side2D==3) {
    overEdge = true;
  }    

  if ((overEdge == false && tile.side == Side.FRONT) || (overEdge && tile.sides2D[side2D] == Side.FRONT)) {
    myTiles = frontTiles;
  }
  else if ((overEdge == false && tile.side == Side.BACK) || (overEdge && tile.sides2D[side2D] == Side.BACK)) {
    myTiles = backTiles;
  }
  else if ((overEdge == false && tile.side == Side.RIGHT) || (overEdge && tile.sides2D[side2D] == Side.RIGHT)) {
    myTiles = rightTiles;
  }
  else if ((overEdge == false && tile.side == Side.LEFT) || (overEdge && tile.sides2D[side2D] == Side.LEFT)) {
    myTiles = leftTiles;
  }    
  else if ((overEdge == false && tile.side == Side.TOP) || (overEdge && tile.sides2D[side2D] == Side.TOP)) {
    myTiles = topTiles;
  }
  else if ((overEdge == false && tile.side == Side.BOTTOM) || (overEdge && tile.sides2D[side2D] == Side.BOTTOM)) {
    myTiles = bottomTiles;
  }

  if(overEdge){
    side2D = myTiles[0][0].getSide2D(tile.side); 
  }
  // Jos ei olla reunalla, palautetaan saman listan viereinen, y kasvaa "alas päin" x oikealle
  if (side2D == 0) {
    return myTiles[tile.squareX][tile.squareY-1];
  }
  else if (side2D == 1) {
    return myTiles[tile.squareX+1][tile.squareY];
  }
  else if (side2D == 2) {
    return myTiles[tile.squareX][tile.squareY+1];
  }
  else if (side2D == 3) {
    return myTiles[tile.squareX-1][tile.squareY];
  }
  // OTA POIS KUN VALMIS
  return tile;
}

