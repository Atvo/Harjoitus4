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
ArrayList<Tile> tilesList;
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

//SETUP
void setup() {
  
  gameState = GameState.START;
  
  //Ladataan kuvat
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

  size(640, 360, P3D);
  tileSize = 20;
  cubeSize = 10;  
  max = cubeSize*tileSize/2;
  
  //Laatat tallennetaan kahdenlaisiin tietorakenteisiin, koska taulukoita käytetään naapurintunnistuksessa
  //ja listaa selvitettäessä valittua laattaa
  frontTiles = new Tile [cubeSize][cubeSize];
  backTiles = new Tile [cubeSize][cubeSize];
  rightTiles = new Tile [cubeSize][cubeSize];
  leftTiles = new Tile [cubeSize][cubeSize];
  topTiles = new Tile [cubeSize][cubeSize];
  bottomTiles = new Tile [cubeSize][cubeSize];
  tilesList = new ArrayList<Tile>();
  
  //Alustetaan pelin tila
  player1Won = false;
  player2Won = false;
  player1Turn = true;
  rightOrLeftMirror = true;
  
  //Luodaan uudet laatat ja tallennetaan ne listaan ja taulukoihin
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      frontTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      backTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      rightTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      leftTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      topTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      bottomTiles[i][k] = tmpTile;
      tilesList.add(tmpTile);
    }
  }
  
  //Alustetaan erikoislaatat
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
  
  //Tarkistetaan pitääkö musiikki aloittaa
  if (firstStart) {
    minim = new Minim(this);
    player = minim.loadFile("millionaire.mp3", 2048);
    player.loop();
    firstStart = false;
  }
}

void draw() {
  
  //Tarkistetaan pelin tilanne
  if (player1Won) {
    gameState = GameState.PLAYER1;
  }
  else if (player2Won) {
    gameState = GameState.PLAYER2;
  }
  if (player1Won && player2Won) {
    gameState = GameState.TIE;
  }
  
  //Piirretään joko aloitusnäyttö tai lopetusnäyttö asianmukaisella voittajalla
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
  
  //Peli on käynnissä
  else {
    background(0);
    noStroke(); // jotta sisällä oltavan pallon piirtoviivat eivät näy
    directionalLight(0, 0, 0, 0, 0, -100); // musta yleisvalo
    spotLight(200, 200, 255, width/2, height/2, 150, 0, 0, -1, PI, 1); // taustaa varten pointlight (r g b -  x y z mistä - xyz mihin - kulma - intensiteetti)
    spotLight(50, 50, 50, width/2, height/2, 150, 0, 0, -1, PI, 1); // palikkaa varten pointlight
    spotLight(50, 50, 50, mouseX, mouseY, 600, 0, 0, -1, PI/2, 600); // hiiren mukana liikkuva pieni valonlahde
    translate(width/2.0, height/2.0, -100);
    sphere(400); // pallo, jonka sisällä ollaan (jotta taustalle piirtyy valoa)
    
    //Piirretään kuva, joka ilmoittaa kumman pelaajan vuoro
    if (player1Turn) {
      image(play1, -350, -180);
    }
    else {
      image(play2, -350, -180);
    }
    
    //Käännetään näkymää
    rotateX(rotx);
    rotateY(roty);
    
    //Selvitetään valittu laatta
    picked = getPicked();
    stroke(255);
    strokeWeight(1);
    
    //Piirretään laatat
    for (int i = 0; i < tilesList.size(); i++) {
      Tile t = (Tile)tilesList.get(i);
      t.isCurrentTile = false;
      
      //Valitulle laatalle ilmoitetaan, että se on valittu
      if (i == picked) {
        t.isCurrentTile = true;
        
        //Jos valitussa laatassa ei ole mitään, käännetään sen peili vastaamaan tällä hetkellä valittua peilin suuntaa
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
  
  //Jos peliä ei ole voitettu, päivitetään laserit
  if (!player1Won && !player2Won) {
    removeAllLasers();
    this.actualLaser = true;
    moveToTileNeighbor(base2Tile, Side.LEFT);
    this.actualLaser = true;
    moveToTileNeighbor(base1Tile, Side.RIGHT);
  }
}

//Lopettaa musiikin
void stop()
{
  super.stop();
  player.close();
  minim.stop();
}

//Kääntää näkymää
void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseClicked() {
  
  //AloitusScreeni
  if (gameState == GameState.START) {
    //Tarkistetaan haluaako käyttäjä aloittaa pelin
    if (mouseX < 616  && 478<mouseX && 298<mouseY && mouseY<329) {
      gameState = GameState.GOING;
    }
  }
  
  //Peli on päättynyt
  else if (gameState == GameState.PLAYER1 || gameState == GameState.PLAYER2 || gameState == GameState.TIE) {
    //Tarkistetaan haluaako käyttäjä aloittaa pelin uudestaan
    if (mouseX < 616  && 478<mouseX && 298<mouseY && mouseY<329) {
      gameState = GameState.START;
      setup();
    }
  }
  
  //Peli käynnissä
  else { 
<<<<<<< HEAD
    
    //Jos klikataan oikealla näppäimellä, käännetään asetettavan peilin asentoa
    if (mouseButton == RIGHT) {
      rightOrLeftMirror = (rightOrLeftMirror) ? false : true;
    }
    
    //Jos klikataan vasemmalla näppäimellä ja jokin laatta on valittu, asetetaan laattaan peili
    else if (picked != -1) {
      Tile tmpTile = tilesList.get(picked);
      
      //Peilin voi asettaa vain, jos siinä ei ole alunperin peiliä ja peliä ei ole voitettu
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

/*Metodi etsii laatan, jonka päällä hiiri on. Kiitokset Tom Cardenille.
Esimerkki katsottu täältä: http://www.tom-carden.co.uk/p5/picking_with_projection/applet/
ja muokattu sopivaksi meidän ohjelmaan.

"This one projects all the triangles to screen space, depth sorts them, and checks if
any of the projected triangles contains the mouse point.  It's not 100% accurate, but
for scenes without intersecting triangles it will be fine, and it's faster than the
buffer-based method."*/
int getPicked() {
  int picked = -1;
  if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    for (int i = 0; i < tilesList.size(); i++) {
      Tile t = (Tile)tilesList.get(i);
      t.project();
    }
    Collections.sort(tilesList);
    for (int i = 0; i < tilesList.size(); i++) {
      Tile t = (Tile)tilesList.get(i);
      if (t.mouseOver()) {
        picked = i;
        break;
      }
    }
  }
  return picked;
}

//Metodi, joka etsii laatan naapurin tulosuunnasta riippuen ja kertoo seuraavalle laatalle menosuunnan
//Metodi kutsuu itse itseään ja sen tarkoitus on kulkea laserin mukaisesti

void moveToTileNeighbor(Tile prev, Side fromSide) {

  Tile neighbor = null;
  
  //Muuttuja, joka pitää kirjaa siitä, mennäänkö sivulta toiselle
  boolean overEdge = false;
  
  //Seuraavan laatan tulosuunta
  Side toSide = fromSide;

  //Jos laatassa on peili, seuraavan laatan tulosuunta muuttuu peilin mukaan
  if (prev.content == TileContent.MIRROR) {
    toSide = prev.mirror.changeLaserDirection(fromSide);
  }
  
  //Jos nykyinen laatta on valittu, mutta siinä ei ole peiliä, päivitetään tieto siitä, että jatkossa laatoissa ei kulje enää oikea laser,
  //vaan vain apu-laser.
  if (prev.isCurrentTile && prev.content == TileContent.EMPTY) {
    toSide = prev.mirror.changeLaserDirection(fromSide);
    actualLaser = false;
  }
  
  //Päivitetään nykyiselle laatalle tieto sen lasereista
  prev.updateLaser2(fromSide);
  
  //Jos laatassa on peili, päivitetään tieto, mistä päin laattaan tullaan
  if (prev.content == TileContent.MIRROR) {
    fromSide = prev.mirror.changeLaserDirection(fromSide);
  }
  
  //Muulloin jos laatta on valittu ja se on tyhjä, päivitetään tulosuunta ja päivitetään tieto apu-laserista.
  else if (prev.isCurrentTile && prev.content == TileContent.EMPTY) {
    fromSide = prev.mirror.changeLaserDirection(fromSide);
    actualLaser = false;
  }

  /*Tässä vaiheessa tarkistetaan naapuri. Naapurin tarkistus toimii näin:
  1. Tarkistetaan millä kuution sivulla ollaan
  2. Tarkistetaan mennäänkö yli reunan
  3. Tarkistetaan suunta, josta ollaan tulossa
  4. Selvitetään naapuri ja päivitetään menosuunta
  
  Tämä toistetaan jokaisella kuution sivulla ja suunnalla.*/
  
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
  //Naapuri on nyt selvillä
  
  //Jos naapurissa on Blocki, päivitetään naapurin laserit ja poistutaan metodista
  if (neighbor.content == TileContent.BLOCK) {
    neighbor.updateLaser2(toSide);
    return;
  }
  
  //Jos naapurissa on jommankumman pelaajan tukikohta, päivitetään naapurin laserit ja poistutaan metodista
  if (neighbor.content == TileContent.PLAYER1BASE) {
    neighbor.updateLaser2(toSide);
    
    //Jos ollaan seurattu oikeaa laseria eikä apulaseria, päivitetään voittomuuttuja
    if (actualLaser) {
      player2Won = true;
    }
    return;
  }
  if (neighbor.content == TileContent.PLAYER2BASE) {
    neighbor.updateLaser2(toSide);
    if (actualLaser) {
      player1Won = true;
    }
    return;
  }
  
  //Jos mennään yli reunan päivitetään vielä nykyisen laatan lasereita, jotta ne eivät katkeaisi
  if (overEdge) {
    prev.updateLaser2(neighbor.side);
  }
  
  //Kun ollaan valmiita, kutsutaan metodia uudestaan naapurille ja päivitetyllä tulosuunnalla
  moveToTileNeighbor(neighbor, toSide);
}

//Tyhjentää kaikkien laattojen laserit
void removeAllLasers() {
  for (int i = 0; i < tilesList.size(); i++) {
      Tile t = (Tile)tilesList.get(i);
      t.allLasersOff();
  }
}

