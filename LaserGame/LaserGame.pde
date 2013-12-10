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
      frontTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      tiles[0][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      tiles2.add(new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this));
    }
  }
  println("hei: " + max);
  this.front = new Square(Side.FRONT, -max, -max, max, -max, max, max, max, -max, max, max, max, max);
  println("hei2");
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      backTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      tiles[1][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      tiles2.add(new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this));
    }
  }
  back = new Square(Side.BACK, -max, -max, -max, -max, max, -max, max, -max, -max, max, max, -max);  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      rightTiles[i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      tiles[2][i][k] = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      tiles2.add(new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this));
    }
  }
  right = new Square(Side.RIGHT, max, -max, -max, max, max, -max, max, -max, max, max, -max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      leftTiles[i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      tiles[3][i][k] = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      tiles2.add(new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this));
    }
  }
  left = new Square(Side.LEFT, -max, -max, -max, -max, max, -max, -max, -max, max, max, max, -max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      topTiles[i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      tiles[4][i][k] = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      tiles2.add(new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k, this));
    }
  }
  top = new Square(Side.TOP, -max, max, -max, -max, max, max, max, max, -max, max, max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      bottomTiles[i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      tiles[5][i][k] = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      tiles2.add(new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this));
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
  //println("RotX: " + rotx%PI + ", RotY: " + roty%PI);
  //println("MouseX: " + mouseX + ", MouseY: " + mouseY);
  //scale(90);
  picked = getPicked();
  stroke(255);
  strokeWeight(10);
  line(0, 0, 0, 400, 0, 0);
  line(0, 0, 0, 0, 400, 0);
  line(0, 0, 0, 0, 0, 400);
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
  //frontTiles[0][0].updateLaser(0);
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseClicked() {
  println("Picked: " + picked);
  if (picked != -1) {
    Tile tmpTile = tiles2.get(picked);
    tmpTile.updateLaser(1);
  }
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
  if (currentTile != null) {
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
        if (l == 0) {
          //projectedX = (sin(roty)*100+cos(roty)*tileSize*(i-cubeSize/2)+width/2);
          //println("PX: " + projectedX);
          xHypo = (float)(Math.sqrt(Math.pow(cubeSize*tileSize/2, 2)+Math.pow(tileSize*(i-cubeSize/2), 2)));
          if (i > 5) {
            xAlpha = roty + acos(100/xHypo);
          }
          else {
            xAlpha = roty - acos(100/xHypo);
          }
          X2 = xHypo*xHypo*cos(xAlpha)*sin(xAlpha)/(300-xHypo*cos(xAlpha));
          X1 = xHypo*sin(xAlpha);
          yHypo = (float)(Math.sqrt(Math.pow(cubeSize*tileSize/2, 2)+Math.pow(tileSize*(k-cubeSize/2), 2)));
          if (k > 5) {
            yAlpha = rotx + acos(100/yHypo);
          }
          else {
            yAlpha = rotx - acos(100/yHypo);
          }
          Y2 = yHypo*yHypo*cos(yAlpha)*sin(yAlpha)/(300-yHypo*cos(yAlpha));
          Y1 = yHypo*sin(yAlpha);
          projectedX = width/2 + X1 + X2;
          projectedY = height/2 + Y1 + Y2;

          /*if(l == 0 && i == 5 && k == 5){
           //println("MouseX: " + mouseX + ", MouseY: " + mouseY + ", tmpH: " + tmpHypo + ", RotY: " + roty + ", tmpA: " + tmpAlpha + ", tmpX1: " + tmpX1 + ", tmpX2: " + tmpX2 + ", ActualX: " + tiles[0][5][5].x + ", ProjectedX: " + projectedX);
           }*/
          if (mouseX < projectedX + tileSize && mouseX > projectedX && mouseY < projectedY + tileSize && mouseY > projectedY) {
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

void moveToTileNeighbor(Tile tile, int side2Dto) {
  Tile [][] neiTiles = new Tile [cubeSize][cubeSize];
  boolean overEdge = false;

  // tarkistetaan ollaanko menossa reunan yli 
  if (tile.squareY == 0 && side2Dto==0) {
    overEdge = true;
  }
  else if (tile.squareY == (cubeSize-1) && side2Dto==2) {
    overEdge = true;
  }
  else if (tile.squareX == (cubeSize-1) && side2Dto==1) {
    overEdge = true;
  }
  else if (tile.squareX == 0 && side2Dto==3) {
    overEdge = true;
  }    

  if ((overEdge == false && tile.side == Side.FRONT) || (overEdge && tile.sides2D[side2Dto] == Side.FRONT)) {
    neiTiles = frontTiles;
  }
  else if ((overEdge == false && tile.side == Side.BACK) || (overEdge && tile.sides2D[side2Dto] == Side.BACK)) {
    neiTiles = backTiles;
  }
  else if ((overEdge == false && tile.side == Side.RIGHT) || (overEdge && tile.sides2D[side2Dto] == Side.RIGHT)) {
    neiTiles = rightTiles;
  }
  else if ((overEdge == false && tile.side == Side.LEFT) || (overEdge && tile.sides2D[side2Dto] == Side.LEFT)) {
    neiTiles = leftTiles;
  }    
  else if ((overEdge == false && tile.side == Side.TOP) || (overEdge && tile.sides2D[side2Dto] == Side.TOP)) {
    neiTiles = topTiles;
  }
  else if ((overEdge == false && tile.side == Side.BOTTOM) || (overEdge && tile.sides2D[side2Dto] == Side.BOTTOM)) {
    neiTiles = bottomTiles;
  }


  if (overEdge) {

    // tarkistetaanko, onko viereisessä puolessa jollain 2 samaa kulmaa == on naapuri
    for (int i = 0; i < cubeSize; i++) {
      for (int k = 0; k < cubeSize; k++) {

        int l = 0;
        if (neiTiles[i][k].hasVector(tile.a)) {
          l++;
        }
        if (neiTiles[i][k].hasVector(tile.b)) {
          l++;
        }
        if (neiTiles[i][k].hasVector(tile.c)) {
          l++;
        }
        if (neiTiles[i][k].hasVector(tile.d)) {
          l++;
        }

        // Jos kaksi samaa kulmaa muutetaan naapurin listaa 
        if (l>1) {

          neiTiles[tile.squareX][tile.squareY-1].laserOn(neiTiles[i][k].getSide2D(tile.side));
          neiTiles[i][k].updateLaser(neiTiles[i][k].getSide2D(tile.side));
        }
      }
    }
  }


  // Jos ei olla reunalla, palautetaan saman listan viereinen, y kasvaa "alas päin" x oikealle
  // palauttaa naapurin sekä muuttaa naapurin tulolaserin
  if (!overEdge) {

    if (side2Dto == 0) {
      neiTiles[tile.squareX][tile.squareY-1].laserOn(2);
      neiTiles[tile.squareX][tile.squareY-1].updateLaser(2);
    }
    else if (side2Dto == 1) {
      neiTiles[tile.squareX+1][tile.squareY].laserOn(3);
      neiTiles[tile.squareX+1][tile.squareY].updateLaser(3);
    }
    else if (side2Dto == 2) {
      neiTiles[tile.squareX][tile.squareY+1].laserOn(0);
      neiTiles[tile.squareX][tile.squareY+1].updateLaser(0);
    }
    else if (side2Dto == 3) {
      neiTiles[tile.squareX-1][tile.squareY].laserOn(1);
      neiTiles[tile.squareX-1][tile.squareY].updateLaser(1);
    }
  }
  //println("ERROR LaserGame CheckNeighbourg: side:  " + side2Dto );
}

