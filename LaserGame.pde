float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
Tile[][][] tiles;
int tileSize, cubeSize;
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
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      frontTiles[i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, cubeSize*tileSize/2, tileSize, Side.FRONT);
      tiles[0][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, cubeSize*tileSize/2, tileSize, Side.FRONT);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      backTiles[i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2, tileSize, Side.BACK);
      tiles[1][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2, tileSize, Side.BACK);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      rightTiles[i][k] = new Tile(cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.RIGHT);
      tiles[2][i][k] = new Tile(cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.RIGHT);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      leftTiles[i][k] = new Tile(-cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.LEFT);
      tiles[3][i][k] = new Tile(-cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.LEFT);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      topTiles[i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.TOP);
      tiles[4][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.TOP);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      bottomTiles[i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.BOTTOM);
      tiles[5][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.BOTTOM);
    }
  }
}

void draw() {
  background(0);
  //noStroke();
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

