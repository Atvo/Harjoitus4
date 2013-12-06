class Square{
  
  Edge edgeNorth;
  Edge edgeSouth;
  Edge edgeWest;
  Edge edgeEast;
  Tile [][] squareTiles;
  int [] northWest, northEast, southEast, southWest = new int[3];
  Array [4] corners;
  
  Square(Side side, int nwX, int nwY, int nwZ, int neX, int neY, int neZ, int seX, int seY, int seZ, int swX, int swY, int swZ){
    northWest [0] = nwX;
    northWest [1] = nwY;
    northWest [2] = nwZ;
    northEast [0] = neX;
    northEast [1] = neY;
    northEast [2] = neZ;
    southWest [0] = swX;
    southWest [1] = swY;
    southWest [2] = swZ;
    southEast [0] = seX;
    southEast [1] = seY;
    southEast [2] = seZ;
    corners [0] = northWest;
    corners [1] = northEast;
    corners [2] = southEast;
    corners [3] = southWest;

    
    // etsi LaserGame pelimoottorista Edge-lista, josta löydä oma edge päätepisteiden perusteella
  }
  
  Side2D whatBorder(int x1, int y1, int z1, int x2, int y2, int z2){
    int start;
    int end;
    for(int i=0; i<4; i++){
       if(corners[i][0] == x1; corners[i][1]== y1; corners[i][2]== z1){
          int start = i;
            for(int j=0; j<4; j++){
                if(corners[i][0]== x2; corners[i][1]== y2; corners[i][2]== z2){
                  int end = j;
                }
            }
       }
    }
    if(i != null && j != null){
        if(start == 0 && end == 1 || start == 1 && end == 0){
           return NORTH; 
        }
        else if(start == 1 && end == 2 || start == 2 && end == 1){
           return EAST; 
        }
        else if(start == 3 && end == 2 || start == 2 && end == 3){
           return SOUTH; 
        }
        else if(start == 0 && end == 4 || start == 4 && end == 0){
           return WEST; 
        }
    }
    else{
       //println("Ei naapureita")
       return null; 
    }
  } 
}
