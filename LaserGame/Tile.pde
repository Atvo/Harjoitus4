import java.awt.Polygon;
class Tile implements Comparable {
  int x, y, z, size; //Laatan koordinaatit ja sivun pituus
  float cx, cy, cz; //Laatan keskipisteen koordinaatit, jotka on kohotettu kuution pinnasta
  int squareX, squareY; //Laatan koordinaatit yksittäisellä kuution sivulla
  Vector3d a, b, c, d; //Laatan vektorit piirtämistä varten
  Vector3d pa, pb, pc, pd; //Laatan projisoidut vektorit
  LaserGame laserGame;
  Side side; //Kuution sivu, jolla laatta on
  HashMap<Side, Boolean> lasersMap; //Laatalla on sanakirja, jossa avaimena suunnat laatan keskipisteestä ja arvona totuusarvo siitä, onko laser päällä
  Mirror mirror;
  TileContent content;
  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side, int squareX, int squareY, LaserGame laserGame) {
    //Laatoille asetetaan peilit valmiiksi, mutta laattojen sisältö pysyy silti alussa tyhjänä
    //Tämä on apulaserin piirrosta johtuvaa
    this.mirror = new Mirror(true, side);
    this.content = TileContent.EMPTY;

    lasersMap = new HashMap <Side, Boolean>();
    lasersMap.put(Side.FRONT, false);
    lasersMap.put(Side.RIGHT, false);
    lasersMap.put(Side.BACK, false);
    lasersMap.put(Side.LEFT, false);
    lasersMap.put(Side.TOP, false);
    lasersMap.put(Side.BOTTOM, false);

    this.a = new Vector3d(x, y, z);
    //Lasketaan laatan piirtovektorit ja keskipiste riippuen kuution sivusta, jolla ollaan
    if (side == Side.FRONT || side == Side.BACK) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y+size, z);
      this.d = new Vector3d(x, y+size, z);
      this.cx = (x + size/2);
      this.cy = (y + size/2);
      //Keskipisteen koordinaatit kohotetaan kuution pinnasta
      if (side == Side.FRONT) {
        this.cz = z+size/2.5;
      }
      else {
        this.cz = z-size/2.5;
      }
    }

    if (side == Side.RIGHT || side == Side.LEFT) {
      this.b = new Vector3d(x, y+size, z);
      this.c = new Vector3d(x, y+size, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cy = (y + size/2);
      this.cz = (z + size/2);
      if (side == Side.RIGHT) {
        this.cx = x+size/2.5;
      }
      else {
        this.cx = x-size/2.5;
      }
    }

    if (side == Side.TOP || side == Side.BOTTOM) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cx = (x + size/2);
      this.cz = (z + size/2);
      if (side == Side.TOP) {
        this.cy = y - size/2.5;
      }
      else {
        this.cy = y + size/2.5;
      }
    }

    this.x = x;
    this.y = y;
    this.z = z;
    this.squareX = squareX;
    this.squareY = squareY;
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
    this.laserGame = laserGame;
  }

  public void display() {
    
    //Piirretään ensin valkoinen laatta
    fill(255);
    beginShape();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    vertex(d.x, d.y, d.z);
    endShape(CLOSE);

    stroke(0);
    //Piirretään laserit
    drawMyLasers();
    
    // jos ruudussa jotain sisältöä piirretään kuutio
    if (content == TileContent.BLOCK || content == TileContent.PLAYER1BASE || content == TileContent.PLAYER2BASE) {
      float xAup, yAup, zAup, xBup, yBup, zBup, xCup, yCup, zCup, xDup, yDup, zDup;
      float up = 20;
      float big = 10;
      float pic = 20;
      PImage pattern = laserGame.p1;
      xAup = a.x;
      yAup = a.y;
      zAup = a.z;
      xBup = b.x;
      yBup = b.y;
      zBup = b.z;
      xCup = c.x;
      yCup = c.y;
      zCup = c.z;  
      xDup = d.x;
      yDup = d.y;
      zDup = d.z;         

      // vastakkaisella puolella z-koordinaatti vähenee 
      if (side == Side.BACK) {
        up = -20;
      } 
      if (side == Side.BACK || side == Side.FRONT) {
        zAup = a.z +up;
        zBup = b.z +up;
        zCup = c.z +up;  
        zDup = d.z +up;
      }
      if (content == TileContent.PLAYER1BASE) {
        pattern = laserGame.p1;
      }
      else if (content == TileContent.PLAYER2BASE) {
        pattern = laserGame.p2;
      }
      else if (content == TileContent.BLOCK ) {
        pattern = laserGame.block;
      }
      beginShape(QUADS);
      texture(pattern);
      vertex(a.x, a.y, a.z, pic, pic);
      vertex(b.x, b.y, b.z, 0, pic);
      vertex(xBup, yBup, zBup, 0, 0);
      vertex(xAup, yAup, zAup, pic, 0);

      vertex(b.x, b.y, b.z, pic, pic);
      vertex(c.x, c.y, c.z, 0, pic);
      vertex(xCup, yCup, zCup, 0, 0);
      vertex(xBup, yBup, zBup, pic, 0);

      vertex(c.x, c.y, c.z, pic, pic);
      vertex(d.x, d.y, d.z, 0, pic);
      vertex(xDup, yDup, zDup, 0, 0);
      vertex(xCup, yCup, zCup, pic, 0);

      vertex(a.x, a.y, a.z, pic, pic);
      vertex(d.x, d.y, d.z, 0, pic);
      vertex(xDup, yDup, zDup, 0, 0);
      vertex(xAup, yAup, zAup, pic, 0);

      vertex(xAup, yAup, zAup, 0, 0); 
      vertex(xBup, yBup, zBup, pic, 0);
      vertex(xCup, yCup, zCup, pic, pic);
      vertex(xDup, yDup, zDup, 0, pic);  
      endShape(CLOSE);
      fill(0);
    }
    // jos ruudussa mirror, piirreetään se seuraavasti
    if (content == TileContent.MIRROR || isCurrentTile) {
      float x1, y1, z1, x2, y2, z2;
      if (!mirror.leftOrRight) {
        x1 = a.x;
        y1 = a.y;
        z1 = a.z;
        x2 = c.x;
        y2 = c.y;
        z2 = c.z;
      }
      else {
        x1 = b.x;
        y1 = b.y;
        z1 = b.z;
        x2 = d.x;
        y2 = d.y;
        z2 = d.z;
      }

      fill(255);
      stroke(255);
      beginShape();
      stroke(0);
      // piirretään yksi sivu kerrallaan
      if (side == Side.FRONT) {
        vertex(x1+1, y1+1, z1);
        vertex(x2 -1, y2-1, z2);  
        vertex(x2 -1, y2 -1, z2+20);
        vertex(x1+1, y1 +1, z1+20);
      } 
      else if (side == Side.BACK) {
        vertex(x1+1, y1+1, z1);
        vertex(x2 -1, y2-1, z2);  
        vertex(x2 -1, y2 -1, z2-20);
        vertex(x1+1, y1 +1, z1-20);
      }

      else if (side == Side.LEFT) {
        vertex(x1+1, y1, z1+1);
        vertex(x2 -1, y2, z2-1);  
        vertex(x2 -20, y2-1, z2-1);
        vertex(x1-20, y1+1, z1+1);
      }
      else if (side == Side.RIGHT) {
        vertex(x1+1, y1, z1+1);
        vertex(x2 -1, y2, z2-1);  
        vertex(x2 +20, y2 -1, z2-1);
        vertex(x1+20, y1 +1, z1+1);
      }
      else if (side == Side.TOP) {
        vertex(x1, y1+1, z1+1);
        vertex(x2, y2-1, z2-1);  
        vertex(x2 -1, y2 -20, z2-1);
        vertex(x1 +1, y1 -20, z1+1);
      }
      else if (side == Side.BOTTOM) {
        vertex(x1, y1+1, z1+1);
        vertex(x2, y2-1, z2-1);  
        vertex(x2 -1, y2 +20, z2-1);
        vertex(x1 +1, y1 +20, z1+1);
      }
      endShape(CLOSE);
      fill(0, 0, 0);
    }
  }


  //Pistää Laserin päälle
  void updateLaser(Side side) {
    lasersMap.put(side, true);
  }
  
  //Kutsuu tarvittaessa laserin piirtoa laatan sivuille oikeilla arvoilla
  void drawMyLasers() {
    float x2 = cx;
    float y2 = cy;
    float z2 = cz;
    color [] laserColors = {
      color(0, 255, 0), color(50, 255, 50), color(100, 255, 100), color(150, 255, 150), color(255, 255, 255)
    };

    if (lasersMap.get(Side.FRONT)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      z2 += size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
    if (lasersMap.get(Side.RIGHT)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      x2 += size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
    if (lasersMap.get(Side.BACK)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      z2 -= size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
    if (lasersMap.get(Side.LEFT)) {

      x2 = cx;
      y2 = cy;
      z2 = cz;
      x2 -= size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
    if (lasersMap.get(Side.TOP)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      y2 -= size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
    if (lasersMap.get(Side.BOTTOM)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      y2 += size;
      drawLaser(this.cx, this.cy, this.cz, x2, y2, z2, laserColors);
    }
  }
  
  //Metodi, jolla laser piirretään
  void drawLaser(float x1, float y1, float z1, float x2, float y2, float z2, color[] laserColors) {
    
    //Piirretään ensin viisi päällekkäistä viivaa, joista jokainen on hieman ohuempi ja kirkkaampi kuin edellinen
    //Tällä saadaan viiva näyttämään kolmiulotteisemmalta ja hehkuvalta
    for (int i = 0; i < 5; i++) {
      strokeWeight(5-i);
      stroke(laserColors[i]);
      line(x1, y1, z1, x2, y2, z2);
    }
    
    //Piirretään pieniä pisteitä säteen ympärille, jotta säde näyttäisi hehkuvan
    float range = 7; //Pisteiden maksimietäisyys säteestä
    float tmpX, tmpY, tmpZ;
    stroke(laserColors[0]); //Pisteiden väri
    //Riippuen säteen suunnasta, piirretään sattumanvaraisesti ja tasaisesti säteen ympärille
    if (x1 == x2 && z1 == z2) {
      for (int i = 0; i < 20; i++) {
        tmpX = (float)((Math.random()-0.5)*range);
        tmpZ = (float)((Math.random()-0.5)*range);
        point(x1+tmpX, (float)(y1+i), z1+tmpZ);
      }
    }
    if (x1 == x2 && y1 == y2) {
      for (int i = 0; i < 20; i++) {
        tmpX = (float)((Math.random()-0.5)*range);
        tmpY = (float)((Math.random()-0.5)*range);
        point(x1+tmpX, y1+tmpY, (float)(z1+i));
      }
    }
    if (y1 == y2 && z1 == z2) {
      for (int i = 0; i < 20; i++) {
        tmpY = (float)((Math.random()-0.5)*range);
        tmpZ = (float)((Math.random()-0.5)*range);
        point((float)(x1+i), y1+tmpY, z1+tmpZ);
      }
    }

    stroke(100);
    strokeWeight(1);
  }
  
  //Sammutetaan laatan kaikki laserit
  void allLasersOff() {

    lasersMap.put(Side.FRONT, false);
    lasersMap.put(Side.RIGHT, false);
    lasersMap.put(Side.BACK, false);
    lasersMap.put(Side.LEFT, false);
    lasersMap.put(Side.TOP, false);
    lasersMap.put(Side.BOTTOM, false);
  }

  //Metodi, jolla lasketaan laatan projisoidut koordinaatit
  void project() {
    pa = a.project();
    pb = b.project();
    pc = c.project();
    pd = d.project();
  }

  /*Luokan lopuista metodeista kunnia kuuluu Tom Cardenille.
  Esimerkki katsottu täältä: http://www.tom-carden.co.uk/p5/picking_with_projection/applet/
  ja muokattu sopimaan projektiimme.*/
  
  //Tarkistaa onko hiiri projisoidun laatan päällä
  boolean mouseOver() {
    // "cheating" using Java's generic polygon class instead of writing my own triangle intersection routine, which probably would be faster
    Polygon p = new Polygon( new int [] { 
      (int)pa.x, (int)pb.x, (int)pc.x
    }
    , new int [] { 
      (int)pa.y, (int)pb.y, (int)pc.y
    }
    , 3);
    return p.inside(mouseX, mouseY);
  }

  //compareTo tarvitaan, jotta laatat voidaan järjestää syvyysjärjestykseen
  int compareTo(Object other) {
    // compare average depth
    float d1 = pa.z+pb.z+pc.z+pd.z;
    Tile t2 = (Tile)other;
    float d2 = t2.pa.z+t2.pb.z+t2.pc.z+t2.pd.z;
    if (d1>d2) {
      return 1;
    }
    else if (d1==d2) {
      return 0;
    }
    else {
      return -1;
    }
  }
}

