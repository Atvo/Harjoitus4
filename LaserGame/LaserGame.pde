float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
Tile[][][] tiles;
Edge [] edges;
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
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      backTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
      tiles[1][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      rightTiles[i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
      tiles[2][i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      leftTiles[i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
      tiles[3][i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      topTiles[i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
      tiles[4][i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      bottomTiles[i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k);
      tiles[5][i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i,k);
    }
  }
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


void alustaEdges(){
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

void getTileNeighbor(Tile tile, Side side) {
   
  // tarkistetaan jos reunalla
 
  
}
