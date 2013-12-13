import java.util.Collections;
import ddf.minim.*;

PImage startScreen, endScreen1, endScreen2, endScreenTie;
PImage block, p1, p2, play1, play2;
AudioPlayer player;
Minim minim;  // pelin aani
GameState gameState;
float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
ArrayList<Tile> tiles2;
Tile[][][] tiles;
Tile base1Tile, base2Tile, blockTile;


int tileSize, cubeSize;
//kuution reunojen koordinaatit
int max;
Tile currentTile;
int picked;
int tmpCounter;
boolean player1Won, player2Won;
boolean player1Turn = true;
boolean rightOrLeftMirror;
boolean actualLaser;
boolean firstStart = true;

void setup() {
  gameState = GameState.START;
  startScreen = loadImage("Lasergame.jpg");
  endScreen1 = loadImage("Player_1.jpg");
  endScreen2 = loadImage("Player_2.jpg");
  endScreenTie = loadImage("Tie.jpg");
  p1 = loadImage("P1.jpg");
  p1.resize(20, 20);
  p2 = loadImage("P2.jpg");
  p2.resize(20, 20);
  play1 = loadImage("Play1.png");
  play2 = loadImage("Play2.png");

  block = loadImage("Block.jpg");
  block.resize(20, 20);

  tmpCounter = 0;
  size(640, 360, P3D);
  tileSize = 20;
  cubeSize = 10;  
  frontTiles = new Tile [cubeSize][cubeSize];
  backTiles = new Tile [cubeSize][cubeSize];
  rightTiles = new Tile [cubeSize][cubeSize];
  leftTiles = new Tile [cubeSize][cubeSize];
  topTiles = new Tile [cubeSize][cubeSize];
  bottomTiles = new Tile [cubeSize][cubeSize];
  tiles2 = new ArrayList<Tile>();
  tiles = new Tile [6][cubeSize][cubeSize];
  max = cubeSize*tileSize/2;
  player1Won = false;
  player2Won = false;
  player1Turn = true;
  rightOrLeftMirror = true;
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      frontTiles[i][k] = tmpTile;
      tiles[0][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      backTiles[i][k] = tmpTile;
      tiles[1][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      rightTiles[i][k] = tmpTile;
      tiles[2][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      leftTiles[i][k] = tmpTile;
      tiles[3][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      topTiles[i][k] = tmpTile;
      tiles[4][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      bottomTiles[i][k] = tmpTile;
      tiles[5][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }

  base1Tile = frontTiles[4][5];
  base1Tile.content = TileContent.PLAYER1BASE;
  base2Tile = frontTiles[5][5];
  base2Tile.content = TileContent.PLAYER2BASE;
  for (int i = 4; i < 6; i++) {
    for (int k = 4; k < 6; k++) {
      backTiles[i][k].content = TileContent.BLOCK;
    }
  }
  moveToTileNeighbor(base2Tile, Side.LEFT);
  moveToTileNeighbor(base1Tile, Side.RIGHT);
  if (firstStart) {
    minim = new Minim(this);
    player = minim.loadFile("millionaire.mp3", 2048);
    player.loop();
    firstStart = false;
  }
}
void newGame() {
  player1Won = false;
  player2Won = false;
  player1Turn = true;
  rightOrLeftMirror = true;
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < cubeSize; j++) {
      for (int k = 0; k < cubeSize; k++) {
        tiles[i][j][k].content = TileContent.EMPTY;
      }
    }
  }
  gameState = GameState.GOING;
}


void draw() {
  if (player1Won) {
    gameState = GameState.PLAYER1;
  }
  else if (player2Won) {
    gameState = GameState.PLAYER2;
  }
  if (player1Won && player2Won) {
    gameState = GameState.TIE;
  }
  if (gameState == GameState.START) {
    image(startScreen, 0, 0);
  }
  else if (gameState == GameState.PLAYER1) {
    image(endScreen1, 0, 0);
  }
  else if (gameState == GameState.PLAYER2) {
    image(endScreen2, 0, 0);
  }
  else if (gameState == GameState.TIE) {
    image(endScreenTie, 0, 0);
  }
  else {


    background(0);
    noStroke(); // jotta sisällä oltavan pallon piirtoviivat eivät näy
    directionalLight(0, 0, 0, 0, 0, -100); // musta yleisvalo
    spotLight(200, 200, 255, width/2, height/2, 150, 0, 0, -1, PI, 1); // taustaa varten pointlight (r g b -  x y z mistä - xyz mihin - kulma - intensiteetti)
    spotLight(50, 50, 50, width/2, height/2, 150, 0, 0, -1, PI, 1); // palikkaa varten pointlight
    spotLight(50, 50, 50, mouseX, mouseY, 600, 0, 0, -1, PI/2, 600); // hiiren mukana liikkuva pieni valonlahde

    translate(width/2.0, height/2.0, -100);



    sphere(400); // pallo, jonka sisällä ollaan (jotta taustalle piirtyy valoa)
    if (player1Turn) {
      println("playerii");
      image(play1, -350, -180);
    }
    else {
      image(play2, -350, -180);
    }
    rotateX(rotx);
    rotateY(roty);
    //println("RotX: " + rotx%PI + ", RotY: " + roty%PI);
    //println("MouseX: " + mouseX + ", MouseY: " + mouseY);
    //scale(90);
    picked = getPicked();
    stroke(255);
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
        if (t.content == TileContent.EMPTY) {
          t.mirror.leftOrRight = rightOrLeftMirror;
        }
      }
      else {
        fill(200);
      }
      t.display(true);
    }
  }


  //frontTiles[0][0].updateLaser(0);
}

void stop()
{
  super.stop();
  player.close();
  minim.stop();
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseMoved() {
  if (!player1Won && !player2Won) {
    removeAllLasers();
    this.actualLaser = true;
    moveToTileNeighbor(base2Tile, Side.LEFT);
    this.actualLaser = true;
    moveToTileNeighbor(base1Tile, Side.RIGHT);
  }
}

void mouseClicked() {
  //removeAllLasers();
  if (gameState == GameState.START) {
    if (mouseX < 616  && 478<mouseX && 298<mouseY && mouseY<329) {
      gameState = GameState.GOING;
    }
  }
  else if (gameState == GameState.PLAYER1 || gameState == GameState.PLAYER2 || gameState == GameState.TIE) {
    if (mouseX < 616  && 478<mouseX && 298<mouseY && mouseY<329) {
      gameState = GameState.START;
      setup();
    }
  }
  else { 
    tmpCounter = 0;
    println("Picked: " + picked);
    if (mouseButton == RIGHT) {
      rightOrLeftMirror = (rightOrLeftMirror) ? false : true;
      /*if (rightOrLeftMirror) {
       rightOrLeftMirror = false;
       }
       else {
       rightOrLeftMirror = true;
       }*/
    }
    else if (picked != -1) {
      Tile tmpTile = tiles2.get(picked);
      //tmpTile.updateLaser(1);
      //tmpTile.updateLaser2(Side.LEFT);
      if (tmpTile.content == TileContent.EMPTY && !player1Won && !player2Won) {
        removeAllLasers();
        tmpTile.mirror.leftOrRight = rightOrLeftMirror;
        tmpTile.content = TileContent.MIRROR;
        player1Turn = (player1Turn) ? false : true;
        this.actualLaser = true;
        moveToTileNeighbor(base2Tile, Side.LEFT);
        this.actualLaser = true;
        moveToTileNeighbor(base1Tile, Side.RIGHT);
      }
    }
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

  //tmpCounter++;
  //println("Move: X: " + prev.x + ", Y: " + prev.y + ", Z: " + prev.z + ", SIDE: " + prev.side + ", FROM: " + fromSide + ", SX: " + prev.squareX + ", SY: " + prev.squareY);
  Tile neighbor = null;
  boolean overEdge = false;
  Side toSide = fromSide;
  //println("fromsIde: " + fromSide);

  if (prev.content == TileContent.MIRROR) {
    toSide = prev.mirror.changeLaserDirection(fromSide);
  }
  if (prev.isCurrentTile && prev.content == TileContent.EMPTY) {
    toSide = prev.mirror.changeLaserDirection(fromSide);
    actualLaser = false;
  }
  if (prev.mirror != null) {
    //fromSide = prev.mirror.changeLaserDirection(fromSide);
  }
  prev.updateLaser2(fromSide);
  if (prev.content == TileContent.MIRROR) {
    fromSide = prev.mirror.changeLaserDirection(fromSide);
  }
  else if (prev.isCurrentTile && prev.content == TileContent.EMPTY) {
    fromSide = prev.mirror.changeLaserDirection(fromSide);
    actualLaser = false;
  }

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
        //println("OVEREDGE");
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
        neighbor = frontTiles[prev.squareX][prev.squareY-1];
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
  if (neighbor.content == TileContent.BLOCK) {
    neighbor.updateLaser2(toSide);
    return;
  }
  if (neighbor.content == TileContent.PLAYER1BASE) {
    neighbor.updateLaser2(toSide);
    if (actualLaser) {
      println("PLAYER2 WINS");
      player2Won = true;
    }
    return;
  }
  if (neighbor.content == TileContent.PLAYER2BASE) {
    neighbor.updateLaser2(toSide);
    if (actualLaser) {
      println("PLAYER1 WINS");
      player1Won = true;
    }
    return;
  }
  if (overEdge) {
    prev.updateLaser2(neighbor.side);
    prev.drawMyLasers2();
  }
  moveToTileNeighbor(neighbor, toSide);
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

