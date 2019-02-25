class Coordinates {
  float x=0;
  float y=0;
  float z=0;

  Coordinates() { 
  }
  Coordinates(float x) { 
    this.x=x;
  }
  
  Coordinates(float x, float y) { 
    this.x=x;
    this.y=y;
  }
  
  Coordinates(float x, float y, float z) { 
    this.x=x;
    this.y=y;
    this.z=z;
  }
  
  public String toString() {
    return "{ x: "+this.x+", y: "+this.y+", z: "+this.z+"}";
  }
}
