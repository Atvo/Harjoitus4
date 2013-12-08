import java.awt.Polygon;
class Tile implements Comparable {
  int x, y, z, size;
  Vector3d a, b, c, d;
  Vector3d pa, pb, pc, pd;
  Side side;
  // side tulo1
  // Side meno1
  // side tulo1
  // Side meno1

  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side) {

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
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
  }

  public void display() {
    fill(255);
    if (side == side.FRONT) {
      fill(255, 0, 0);
    }
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
  // muuttaa seuraavan tiilen Suunta tulo1 (if null tulo2)
  // ja palauttaa seuraavan tiilen 
  //laserin piirtäminen tänne
  //on metodit, joilla tiedetään mitkä on viereiset tilet
  //esim: jos laser tulee left naapurista, menee right naapuriin
}

