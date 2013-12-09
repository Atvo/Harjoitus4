import java.util.Collections;
float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
ArrayList<Tile> tiles2;
Tile[][][] tiles;
Edge [] edges;
Square front, back, right, left, top, bottom;
int tileSize, cubeSize;
//kuution reunojen koordinaatit
int max;
Tile currentTile;
int picked;

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
  tiles2 = new ArrayList<Tile>();
  tiles = new Tile [6][cubeSize][cubeSize];
  max = cubeSize*tileSize/2;
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      frontTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k);
      tiles[0][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k);
      tiles2.add(new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k));
    }
  }
  println("hei: " + max);
  this.front = new Square(Side.FRONT, -max, -max, max, -max, max, max, max, -max, max, max, max, max);
  println("hei2");
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      backTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
      tiles[1][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k);
      tiles2.add(new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k));
    }
  }
  back = new Square(Side.BACK, -max, -max, -max, -max, max, -max, max, -max, -max, max, max, -max);  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      rightTiles[i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
      tiles[2][i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k);
      tiles2.add(new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k));
    }
  }
  right = new Square(Side.RIGHT, max, -max, -max, max, max, -max, max, -max, max, max, -max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      leftTiles[i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
      tiles[3][i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k);
      tiles2.add(new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k));
    }
  }
  left = new Square(Side.LEFT, -max, -max, -max, -max, max, -max, -max, -max, max, max, max, -max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      topTiles[i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
      tiles[4][i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k);
      tiles2.add(new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k));
    }
  }
  top = new Square(Side.TOP, -max, max, -max, -max, max, max, max, max, -max, max, max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      bottomTiles[i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k);
      tiles[5][i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k);
      tiles2.add(new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k));
    }
  }
  bottom = new Square(Side.TOP, -max, -max, -max, -max, -max, max, max, -max, -max, max, -max, max);
}

void draw() {
  background(0);
  noStroke(); // jotta sisällä oltavan pallon piirtoviivat eivät näy
  
  //directionalLight(51, 102, 255, 0, 0, -100); // sininen yleisvalo
  directionalLight(0, 0, 0, 0, 0, -100); // musta yleisvalo
  //pointLight(200, 200, 255, width/2, height/2, 150); // r g b -  x y z
  spotLight(200, 200, 255, width/2, height/2, 150, 0, 0, -1, PI, 2); // taustaa varten pointlight (r g b -  x y z mistä - xyz mihin - kulma - intensiteetti)
  spotLight(200, 200, 255, width/2, height/2, 1000, 0, 0, -100, PI/6, 80); // palikkaa varten pointlight

  translate(width/2.0, height/2.0, -100);
  sphere(400); // pallo, jonka sisällä ollaan (jotta taustalle piirtyy valoa)
  rotateX(rotx);
  rotateY(roty);
  println("RotX: " + rotx%PI + ", RotY: " + roty%PI);
  println("MouseX: " + mouseX + ", MouseY: " + mouseY);
  //scale(90);
  picked = getPicked();
  stroke(255);
  strokeWeight(20);
  line(0,0,0,400,0,0);
  line(0,0,0,0,400,0);
  line(0,0,0,0,0,400);
  strokeWeight(1);
  //line(mouseX-320, mouseY-180, 0, 0, 0, 300);
  stroke(100);
  //noStroke();
  /*for (int l = 0; l < 6; l++) {
    for (int i = 0; i < cubeSize; i++) {
      for (int k = 0; k < cubeSize; k++) {
        tiles[l][i][k].display();
      }
    }
  }*/
  for (int i = 0; i < tiles2.size(); i++) {
    Tile t = (Tile)tiles2.get(i);
    t.isCurrentTile = false;
    if (i == picked) {
      fill(#ff8080);
      t.isCurrentTile = true;
    }
    else {
      fill(200);
    }
    t.display();
  }
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}
int getPicked() {
  int picked = -1;
  if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    for (int i = 0; i < tiles2.size(); i++) {
      Tile t = (Tile)tiles2.get(i);
      t.project();
    }
    Collections.sort(tiles2);
    for (int i = 0; i < tiles2.size(); i++) {
      Tile t = (Tile)tiles2.get(i);
      if (t.mouseOver()) {
        picked = i;
        break;
      }
    }
  }
  //println(picked);
  return picked;
}


void alustaEdges() {
  edges = new Edge [12];
}

void checkCurrentTile() {
  if(currentTile != null){
    currentTile.isCurrentTile = false;
  }
  Tile tmpTile = null;
  //Tarkistetaan onko nykyinen laatta edelleen valittu, jos on, return

  //Jos ei niin etsitään nykyinen laatta
  float projectedX, projectedY;
  float xHypo, xAlpha, X1, X2, yHypo, yAlpha, Y1, Y2;
  for (int l = 0; l < 6; l++) {
    for (int i = 0; i < cubeSize; i++) {
      for (int k = 0; k < cubeSize; k++) {
        tmpTile = tiles[l][i][k];
        if (l == 0){
          //projectedX = (sin(roty)*100+cos(roty)*tileSize*(i-cubeSize/2)+width/2);
          //println("PX: " + projectedX);
          xHypo = (float)(Math.sqrt(Math.pow(cubeSize*tileSize/2,2)+Math.pow(tileSize*(i-cubeSize/2),2)));
          if (i > 5){
            xAlpha = roty + acos(100/xHypo);
          }
          else{
            xAlpha = roty - acos(100/xHypo);
          }
          X2 = xHypo*xHypo*cos(xAlpha)*sin(xAlpha)/(300-xHypo*cos(xAlpha));
          X1 = xHypo*sin(xAlpha);
          yHypo = (float)(Math.sqrt(Math.pow(cubeSize*tileSize/2,2)+Math.pow(tileSize*(k-cubeSize/2),2)));
          if (k > 5){
            yAlpha = rotx + acos(100/yHypo);
          }
          else{
            yAlpha = rotx - acos(100/yHypo);
          }
          Y2 = yHypo*yHypo*cos(yAlpha)*sin(yAlpha)/(300-yHypo*cos(yAlpha));
          Y1 = yHypo*sin(yAlpha);
          projectedX = width/2 + X1 + X2;
          projectedY = height/2 + Y1 + Y2;
          
          /*if(l == 0 && i == 5 && k == 5){
            //println("MouseX: " + mouseX + ", MouseY: " + mouseY + ", tmpH: " + tmpHypo + ", RotY: " + roty + ", tmpA: " + tmpAlpha + ", tmpX1: " + tmpX1 + ", tmpX2: " + tmpX2 + ", ActualX: " + tiles[0][5][5].x + ", ProjectedX: " + projectedX);
          }*/
          if (mouseX < projectedX + tileSize && mouseX > projectedX && mouseY < projectedY + tileSize && mouseY > projectedY){
            println("Current tile: Front: " + i + "/" + k + ", PX: " + projectedX + ", PY: " + projectedY);
            println("MouseX: " + mouseX + ", MouseY: " + mouseY + ", tmpH: " + xHypo + ", RotY: " + roty + ", tmpA: " + xAlpha + ", tmpX1: " + X1 + ", tmpX2: " + X2 + ", ActualX: " + tiles[0][i][k].x + ", ProjectedX: " + projectedX);
            tiles[l][i][k].isCurrentTile = true;
            currentTile = tiles[l][i][k];
          }
        }
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

