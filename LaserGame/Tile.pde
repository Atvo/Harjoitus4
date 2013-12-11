import java.awt.Polygon;
class Tile implements Comparable {
  int x, y, z, size;
  int cx, cy, cz;
  int squareX, squareY;
  Vector3d a, b, c, d;
  Vector3d pa, pb, pc, pd;
  LaserGame laserGame;
  Side side;
  // mistä säde tulee
  int tulo1;
  // minne säde menee
  int meno1;
  // vaihtoehtoiset, jos jo yksi säde ruudussa
  Side tulo2;
  Side meno2;
  Side [] sides2D = new Side[4];
  // Onko ruudussa laserit päällä: 0 pohjoinen, 1 itä, 2 etelä, 3 länsi
  boolean [] lasers = new boolean[4];
  HashMap<Side, Boolean> lasersMap;

  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side, int squareX, int squareY, LaserGame laserGame) {
    this.a = new Vector3d(x, y, z);
    lasersMap = new HashMap <Side, Boolean>();
    lasersMap.put(Side.FRONT, false);
    lasersMap.put(Side.RIGHT, false);
    lasersMap.put(Side.BACK, false);
    lasersMap.put(Side.LEFT, false);
    lasersMap.put(Side.TOP, false);
    lasersMap.put(Side.BOTTOM, false);
    if (side == Side.FRONT || side == Side.BACK) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y+size, z);
      this.d = new Vector3d(x, y+size, z);
      this.cx = (x + size/2);
      this.cy = (y + size/2);
      this.cz = z;
    }
    if (side == Side.RIGHT || side == Side.LEFT) {
      this.b = new Vector3d(x, y+size, z);
      this.c = new Vector3d(x, y+size, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cx = x;
      this.cy = (y + size/2);
      this.cz = (z + size/2);
    }
    if (side == Side.TOP || side == Side.BOTTOM) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cx = (x + size/2);
      this.cy = y;
      this.cz = (z + size/2);
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
    boolean [] lasers = {
      false, false, false, false
    };
    if (side == Side.FRONT) {
      //TOP, RIGHT, LEFT, FRONT, BACK, BOTTOM
      sides2D[0] = Side.TOP;
      sides2D[1] = Side.RIGHT;
      sides2D[2] = Side.BOTTOM;
      sides2D[3] = Side.LEFT;
    }
    else if (side == Side.BACK) {
      sides2D[0] = Side.TOP;
      sides2D[1] = Side.LEFT;
      sides2D[2] = Side.BOTTOM;
      sides2D[3] = Side.RIGHT;
    }
    else if (side == Side.RIGHT) {
      sides2D[0] = Side.TOP;
      sides2D[1] = Side.BACK;
      sides2D[2] = Side.BOTTOM;
      sides2D[3] = Side.FRONT;
    }
    else if (side == Side.LEFT) {        
      sides2D[0] = Side.TOP;
      sides2D[1] = Side.FRONT;
      sides2D[2] = Side.BOTTOM;
      sides2D[3] = Side.BACK;
    }    
    else if (side == Side.TOP) {
      sides2D[0] = Side.BACK;
      sides2D[1] = Side.RIGHT;
      sides2D[2] = Side.FRONT;
      sides2D[3] = Side.LEFT;
    }
    else if (side == Side.BOTTOM) {
      sides2D[0] = Side.FRONT;
      sides2D[1] = Side.RIGHT;
      sides2D[2] = Side.BACK;
      sides2D[3] = Side.LEFT;
    }
  }

  public void display(boolean onlyShape) {
    if (onlyShape) {
      fill(255);
      /*MIIKA: otin pois, koska bugittaa valojen kanssa (testaa, ihan makee tietty jos käyttää oikein ja vaikka kaikille sivuille)
       if (side == side.FRONT) {
       fill(255, 0, 0);
       }
       */
      if (isCurrentTile) {
        fill(0, 0, 255);
      }
      beginShape();
      vertex(a.x, a.y, a.z);
      vertex(b.x, b.y, b.z);
      vertex(c.x, c.y, c.z);
      vertex(d.x, d.y, d.z);
      endShape(CLOSE);
    drawMyLasers2();
      return;
    }
    else {
      for (int i = 0; i<4 ; i++) {
        if (lasers[i]) {
          int x2 = this.cx;
          int y2 = this.cy;
          int z2 = this.cz;
          if (sides2D[i] == Side.RIGHT) {
            x2 = cx+(this.size/2);
          }
          else if (sides2D[i] == Side.LEFT) {
            x2 = cx-(this.size/2);
          }
          else if (sides2D[i] == Side.TOP) {
            y2 = cx-(this.size/2);
          }
          else if (sides2D[i] == Side.BOTTOM) {
            y2 = cx+(this.size/2);
          }
          else if (sides2D[i] == Side.FRONT) {
            y2 = cx+(this.size/2);
          }
          else if (sides2D[i] == Side.BACK) {
            y2 = cx-(this.size/2);
          }    
          println("drawing in " + this.side + " x: " + this.squareX + "  y: " + this.squareY + "  suunta2D: " + i);
          strokeWeight(5);
          stroke(0, 255, 0);
          //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
          line(this.cx, this.cy, this.cz, x2, y2, z2);
          stroke(100);
          strokeWeight(1);
        }
      }
    }
    println("piirron loppu!");

    //drawMyLasers();
    /*if (side == Side.FRONT || side == Side.BACK) {
     beginShape();
     vertex(x, y, z);
     vertex(x+size, y, z);
     vertex(x+size, y+size, z);
     vertex(x, y+size, z);
     endShape(CLOSE);
     }
     if (side == Side.TOP || side == Side.BOTTOM) {
     beginShape();
     vertex(x, y, z);
     vertex(x+size, y, z);
     vertex(x+size, y, z+size);
     vertex(x, y, z+size);
     endShape(CLOSE);
     }
     if (side == Side.RIGHT || side == Side.LEFT) {
     beginShape();
     vertex(x, y, z);
     vertex(x, y+size, z);
     vertex(x, y+size, z+size);
     vertex(x, y, z+size);
     endShape(CLOSE);
     }*/
  }

  void updateLaser(int tulosuunta2D) {
    //println("updating in " + this.side + " x: " + this.squareX + "  y: " + this.squareY + "  suunta2D: " + tulosuunta2D + "  suunta 3D: " + sides2D[tulosuunta2D]);
    //println("UpdateLaser: X: " + x + ", Y: " + y + ", Z: " + z);
    // piirrä omat laserit
    int lahtosuunta2D = 10;
    // TODO: MUUTETAAN JOS ON PEILI
    if (tulosuunta2D == 0) {
      lahtosuunta2D = 2;
    }
    else if (tulosuunta2D == 2) {
      lahtosuunta2D = 0;
    }
    else if (tulosuunta2D == 1) {
      lahtosuunta2D = 3;
    }
    else if (tulosuunta2D == 3) {
      lahtosuunta2D = 1;
    }
    this.lasers[lahtosuunta2D] = true;
    display(false);
    this.laserGame.moveToTileNeighbor(this, lahtosuunta2D);
  }

  void updateLaser2(Side side) {
    if(this.side == Side.FRONT){
      println("updating front tiles: " + side);
    }
    lasersMap.put(side, true);
    if(this.side == Side.FRONT){
    println("UPDATE: " + lasersMap);
    }
  }

  void drawMyLasers2() {
    int x2 = cx;
    int y2 = cy;
    int z2 = cz;
    if (this.side == Side.FRONT){
      //println(lasersMap);
    }
    
    if (lasersMap.get(Side.FRONT)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      //println("DRAW FRONT");
      z2 += size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
    if (lasersMap.get(Side.RIGHT)) {
      if(this.side == Side.FRONT){
        println("drawing front tiles from right: " + cx + cy + cz);
      }
      //println("Drawning to Right: " + cx + cy + cz);
      x2 = cx;
      y2 = cy;
      z2 = cz;
      x2 += size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
    if (lasersMap.get(Side.BACK)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      z2 -= size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
    if (lasersMap.get(Side.LEFT)) {
      
      if(this.side == Side.FRONT){
        println("drawing front tiles from left: " + cx + cy + cz);
      }
      //println("DRAWING FROM LEFT");
      x2 = cx;
      y2 = cy;
      z2 = cz;
      x2 -= size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
    if (lasersMap.get(Side.TOP)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      y2 -= size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
    if (lasersMap.get(Side.BOTTOM)) {
      x2 = cx;
      y2 = cy;
      z2 = cz;
      y2 += size;
      strokeWeight(5);
      stroke(0, 255, 0);
      //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
      line(this.cx, this.cy, this.cz, x2, y2, z2);
      stroke(100);
      strokeWeight(1);
    }
  }


  void drawMyLasers() {
    for (int i = 0; i<4 ; i++) {
      if (lasers[i]) {
        int x2 = this.cx;
        int y2 = this.cy;
        int z2 = this.cz;
        if (sides2D[i] == Side.RIGHT) {
          x2 = cx+(this.size/2);
        }
        else if (sides2D[i] == Side.LEFT) {
          x2 = cx-(this.size/2);
        }
        else if (sides2D[i] == Side.TOP) {
          y2 = cx-(this.size/2);
        }
        else if (sides2D[i] == Side.BOTTOM) {
          y2 = cx+(this.size/2);
        }
        else if (sides2D[i] == Side.FRONT) {
          y2 = cx+(this.size/2);
        }
        else if (sides2D[i] == Side.BACK) {
          y2 = cx-(this.size/2);
        }    
        println("drawing in " + this.side + " x: " + this.squareX + "  y: " + this.squareY + "  suunta2D: " + i);
        strokeWeight(5);
        stroke(0, 255, 0);
        //println("cx: " + this.cx + ", cy: " +  this.cy + ", cz: " + this.cz + ", x2: " + x2 + ", y2: " + y2 + ", z2: " + z2);
        line(this.cx, this.cy, this.cz, x2, y2, z2);
        stroke(100);
        strokeWeight(1);
      }
    }
  }


  void project() {
    pa = a.project();
    pb = b.project();
    pc = c.project();
    pd = d.project();
  }

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

  void setTulo1(Tile tile, int tulo1) {
    tile.tulo1 = tulo1;
  }

  int getSide2D (Side fromSide) {

    for (int i= 0; i<4; i++) {
      if (sides2D[i] == fromSide) {
        return i;
      }
    }
    return 0;
  }

  Side get3DSide(int side2D) {
    return sides2D[side2D];
  }

  void laserOn(int side2D) {
    lasers[side2D] = true;
  }

  void allLasersOff(int side2D) {
    for (int i= 0; i<4; i++) {
      lasers[i] = false;
    }
  }

  boolean hasVector(Vector3d v3) {

    if (this.a.x == v3.x && this.a.y == v3.y && this.a.z == v3.z) {
      return true;
    }
    else if (this.b.x == v3.x && this.b.y == v3.y && this.b.z == v3.z) {
      return true;
    }
    else if (this.c.x == v3.x && this.c.y == v3.y && this.c.z == v3.z) {
      return true;
    }
    else if (this.d.x == v3.x && this.d.y == v3.y && this.d.z == v3.z) {
      return true;
    }

    return false;
  }

  // muuttaa seuraavan tiilen Suunta tulo1 (if null tulo2)
  // ja palauttaa seuraavan tiilen 
  //laserin piirtäminen tänne
  //on metodit, joilla tiedetään mitkä on viereiset tilet
  //esim: jos laser tulee left naapurista, menee right naapuriin
}


// UPDATE:
// Getnai(this, suunta2D);
// PiirräLaser
// Getnai.update();


// PiirräLaserit();
// kutsuu LaserGamen piirrä laser(xyz, xyz);
// käyttää omaa listaa laserit, joka boolean 0 1 2 3 -suunnat

