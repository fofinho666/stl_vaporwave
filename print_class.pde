class Print extends Coordinates{
  Mesh3D mesh;
  PShape shape;
  color filament;
  
  Print(String stl_path, color filament) {
    super(0,0,0);
    this.mesh = new STLReader().loadBinary(stl_path, STLReader.TRIANGLEMESH);
    this.filament= filament;
    this.sync_center();
  }
  
  private void buildPshape() {
    this.mesh.computeVertexNormals();
    Collection<Face> triangles = this.mesh.getFaces();

    this.shape = createShape();
    this.shape.setStroke(false);
    this.shape.beginShape(TRIANGLES);
    this.shape.textureMode(NORMAL);

    for (final Face t : triangles) {
      this.shape.normal(t.a.normal.x, t.a.normal.y, t.a.normal.z);
      this.shape.vertex(t.a.x, t.a.y, t.a.z);

      this.shape.normal(t.b.normal.x, t.b.normal.y, t.b.normal.z);
      this.shape.vertex(t.b.x, t.b.y, t.b.z);
      
      this.shape.normal(t.c.normal.x, t.c.normal.y, t.c.normal.z);
      this.shape.vertex(t.c.x, t.c.y, t.c.z);
    }
    this.shape.endShape();
    this.shape.setShininess(100);
  }
  
  public AABB getBoundingBox(){
    return this.mesh.getBoundingBox();
  }
  
  private void sync_center(){
    this.mesh.center(new Vec3D(this.x, this.y, this.z));
    this.buildPshape();
    this.shape.setFill(filament);
  }

  public void update_x(float x){
    this.x=x;
    this.sync_center();
  }
  
  public void update_y(float y){
    this.y=y;
    this.sync_center();
  }
  
  public void update_z(float z){
    this.z=z;
    this.sync_center();
  }
  
  public void draw(){
    pushMatrix();
    shape(this.shape);
    popMatrix();
  }
}
