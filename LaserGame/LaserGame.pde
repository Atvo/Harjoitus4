import java.util.Collections;
float rotx = PI/4;
float roty = PI/4;
ArrayList<Tile> tiles2;
Tile[][][] tiles;
int tileSize, cubeSize;
Tile currentTile;
int picked;

void setup() {
  size(640, 360, P3D);
  this.tileSize = 20;
  this.cubeSize = 10;
  tiles2 = new ArrayList<Tile>();
  tiles = new Tile [6][cubeSize][cubeSize];
  /*float fov = PI/3.0; 
  float cameraZ = (height/2.0) / tan(fov/2.0); 
  perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);*/
  camera(320.0, 180.0, 210.0, 320.0, 180.0, 0.0, 0.0, 1.0, 0.0);
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[0][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, cubeSize*tileSize/2, tileSize, Side.FRONT);
      tiles2.add(new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, cubeSize*tileSize/2, tileSize, Side.FRONT));
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[1][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2, tileSize, Side.BACK);
      tiles2.add(new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2, tileSize, Side.BACK));
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[2][i][k] = new Tile(cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.RIGHT);
      tiles2.add(new Tile(cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.RIGHT));
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[3][i][k] = new Tile(-cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.LEFT);
      tiles2.add(new Tile(-cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, -cubeSize*tileSize/2 + i * tileSize, tileSize, Side.LEFT));
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[4][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.TOP);
      tiles2.add(new Tile(-cubeSize*tileSize/2 + i * tileSize, cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.TOP));
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      tiles[5][i][k] = new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.BOTTOM);
      tiles2.add( new Tile(-cubeSize*tileSize/2 + i * tileSize, -cubeSize*tileSize/2, -cubeSize*tileSize/2 + k * tileSize, tileSize, Side.BOTTOM));
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
  println("RotX: " + rotx%PI + ", RotY: " + roty%PI);
  println("MouseX: " + mouseX + ", MouseY: " + mouseY);
  //scale(90);
  picked = getPicked();
  stroke(255);
  line(0,0,0,400,0,0);
  line(0,0,0,0,400,0);
  line(0,0,0,0,0,400);
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

