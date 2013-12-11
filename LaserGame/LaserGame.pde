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
int tmpCounter;

void setup() {
  tmpCounter = 0;
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
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      backTiles[i][k] = tmpTile;
      tiles[1][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  back = new Square(Side.BACK, -max, -max, -max, -max, max, -max, max, -max, -max, max, max, -max);  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      rightTiles[i][k] = tmpTile;
      tiles[2][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  right = new Square(Side.RIGHT, max, -max, -max, max, max, -max, max, -max, max, max, -max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      leftTiles[i][k] = tmpTile;
      tiles[3][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  left = new Square(Side.LEFT, -max, -max, -max, -max, max, -max, -max, -max, max, max, max, -max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      topTiles[i][k] = tmpTile;
      tiles[4][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  top = new Square(Side.TOP, -max, max, -max, -max, max, max, max, max, -max, max, max, max);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      bottomTiles[i][k] = tmpTile;
      tiles[5][i][k] = tmpTile;
      tiles2.add(tmpTile);
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
  /*stroke(100);
    strokeWeight(5);
          stroke(0, 255, 0);
          line(-100, 5, 100, 100, 5, 100);
          stroke(100);
          strokeWeight(1);*/
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
    t.display(true);
  }
  //frontTiles[0][0].updateLaser(0);
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseClicked() {
  //removeAllLasers();
  tmpCounter = 0;
  println("Picked: " + picked);
  if (picked != -1) {
    Tile tmpTile = tiles2.get(picked);
    //tmpTile.updateLaser(1);
    //tmpTile.updateLaser2(Side.LEFT);
    moveToTileNeighbor(tmpTile, Side.LEFT);
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
void moveToTileNeighbor(Tile prev, Side fromSide) {

  if (tmpCounter > 40) {
    return;
  }
  tmpCounter++;
  println("Move: X: " + prev.x + ", Y: " + prev.y + ", Z: " + prev.z + ", SIDE: " + prev.side + ", FROM: " + fromSide + ", SX: " + prev.squareX + ", SY: " + prev.squareY);
  Tile neighbor = null;
  boolean overEdge = false;
  Side toSide = fromSide;
  prev.updateLaser2(fromSide);
  if (prev.side == Side.FRONT) {
    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX+1][prev.squareY];
      }
      else {
        println("OVEREDGE");
        toSide = prev.side;
        neighbor = rightTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[prev.squareX][cubeSize-1];
      }
    }
  }

  if (prev.side == Side.RIGHT) {

    if (prev.squareX == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[cubeSize-1][prev.squareX];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[cubeSize-1][prev.squareX];
      }
    }
  }

  if (prev.side == Side.BACK) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[prev.squareX][0];
      }
    }
  }

  if (prev.side == Side.LEFT) {

    if (prev.squareX == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[0][prev.squareX];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[0][prev.squareX];
      }
    }
  }

  if (prev.side == Side.TOP) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[prev.squareY][0];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[prev.squareY][0];
      }
    }
  }

  if (prev.side == Side.BOTTOM) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[prev.squareY][cubeSize-1];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[prev.squareY][cubeSize-1];
      }
    }
  }
  if (overEdge) {
    prev.updateLaser2(neighbor.side);
  }
  if (prev.side == Side.FRONT && toSide == Side.RIGHT) {
    println("PREV: " + prev.lasersMap);
    println("NEIGHBOR: " +neighbor.lasersMap);
  }
  prev.drawMyLasers2();
  moveToTileNeighbor(neighbor, toSide);
}

void moveToTileNeighbor(Tile tile, int side2Dto) {
  println("moveTo:  x: " + tile.squareX + "  y: " + tile.squareY + " to: " + side2Dto + "  side: " + tile.side);
  Tile [][] neiTiles = new Tile [cubeSize][cubeSize];
  boolean overEdge = false;
  if (tmpCounter > 40) {
    return;
  }
  tmpCounter++;
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
    //println("reunan yli");
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
          // println("naapuri löydetty i:" + i  + "  k: " + k + " squareY: " + tile.squareY);


          neiTiles[i][k].laserOn(neiTiles[i][k].getSide2D(tile.side));
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

void removeAllLasers() {
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < cubeSize; j++) {
      for (int k = 0; k < cubeSize; k++) {
        tiles[i][j][k].allLasersOff();
      }
    }
  }
}


