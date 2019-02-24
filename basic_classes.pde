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
}

class Angles {
  float x=0;
  float y=0;
  float z=0;

  Angles(){
  }
  Angles(float x) { 
    this.x=radians(x);
  }
  Angles(float x, float y) { 
    this.x=radians(x);
    this.y=radians(y);
  }
  Angles(float x, float y, float z) { 
    this.x=radians(x);
    this.y=radians(y);
    this.z=radians(z);
  }
  public void set_x(float x){
    this.x=radians(x);
  }
  public void set_y(float y){
    this.y=radians(y);
  }
  public void set_z(float z){
    this.z=radians(z);
  }
}
