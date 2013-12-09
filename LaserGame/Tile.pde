import java.awt.Polygon;
class Tile implements Comparable {
  int x, y, z, size;
  int squareX, squareY;
  Vector3d a, b, c, d;
  Vector3d pa, pb, pc, pd;
  Side side;
  // mistä säde tulee
  int tulo1;
  // minne säde menee
  int meno1;
  // vaihtoehtoiset, jos jo yksi säde ruudussa
  Side tulo2;
  Side meno2;
  Side [] sides2D;
  
  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side, int squareX, int squareY) {
    this.a = new Vector3d(x, y, z);
    if (side == Side.FRONT || side == Side.BACK) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y+size, z);
      this.d = new Vector3d(x, y+size, z);
    }
    if (side == Side.RIGHT || side == Side.LEFT) {
      this.b = new Vector3d(x, y+size, z);
      this.c = new Vector3d(x, y+size, z+size);
      this.d = new Vector3d(x, y, z+size);
    }
    if (side == Side.TOP || side == Side.BOTTOM) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y, z+size);
      this.d = new Vector3d(x, y, z+size);
    }
    this.x = x;
    this.y = y;
    this.z = z;
    this.squareX = squareX;
    this.squareY = squareY;
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
    if (side == Side.FRONT) {
      //TOP, RIGHT, LEFT, FRONT, BACK, BOTTOM
          Side [] sides2D= {Side.TOP, Side.RIGHT, Side.BOTTOM, Side.LEFT};
    }
    else if (side == Side.BACK) {
          Side [] sides2D= {Side.TOP, Side.LEFT, Side.BOTTOM, Side.RIGHT};
    }
    else if (side == Side.RIGHT) {
          Side [] sides2D= {Side.TOP, Side.BACK, Side.BOTTOM, Side.FRONT};
    }
    else if (side == Side.LEFT) {
          Side [] sides2D= {Side.TOP, Side.FRONT, Side.BOTTOM, Side.BACK};
    }    
    else if (side == Side.TOP) {
          Side [] sides2D= {Side.BACK, Side.RIGHT, Side.FRONT, Side.LEFT};
    }
    else if (side == Side.BOTTOM) {
          Side [] sides2D= {Side.FRONT, Side.RIGHT, Side.BACK, Side.LEFT};
    }
  }

  public void display() {
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
  // TODO: getNeiborandChanceDirectin(side Side)

  
  void setTulo1(Tile tile, int tulo1){
    tile.tulo1 = tulo1;
  }
  
  int getSide2D (Side fromSide){
    for(int i= 0; i<4; i++){
     if(sides2D[i] == fromSide){
        return i;
     }
    }
    return 0;
  }
 
 // TODO: get3DSide(); LAURI
  
  
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


