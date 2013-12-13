/*Luokasta kunnia kuuluu Tom Cardenille.
  Kopioitu suoraan: täältä http://www.tom-carden.co.uk/p5/picking_with_projection/applet/*/
class Vector3d {

  float x,y,z;

  Vector3d(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  // default constructor makes a random point in a box in front of the camera.  not great, but simple
  Vector3d() {
    float boxsize = (width+height)/3.0;
    this.x = random(-boxsize,boxsize)+width/2;
    this.y = random(-boxsize,boxsize)+height/2;
    this.z = -random(-boxsize,boxsize)-(width+height)/2;
  }

  //Luo uuden vektorin, joka on projisoitu ruudulle
  Vector3d project() {
    return new Vector3d(screenX(x,y,z),screenY(x,y,z),screenZ(x,y,z));
  }

}


