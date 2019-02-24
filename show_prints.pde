import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import processing.opengl.*;
import java.util.Collection;

ToxiclibsSupport gfx;
String img_url;
PImage bg;
float Y_SPEED = -0.025;
int BACKGROUND_REFRESH_TIME = 60;
ArrayList<Print> prints;

public void setup() {
  size(600, 600, P3D);

  // Load image from unsplash
  img_url = "https://source.unsplash.com/collection/923267/"+width+"x"+height;
  bg = loadImage(img_url, "jpg");
  
  gfx = new ToxiclibsSupport(this);
  prints = new ArrayList<Print>();
  setup_prints();
}

public void setup_prints() {
  color print_color; 
  Print print;

  print_color = color(255,0,0);
  print = new Print("test.stl", print_color);
  //print.rotate_x(180);
  print.y = 180;
  prints.add(print);

  print_color = color(0,255,0);
  print = new Print("climbing.stl", print_color);
  //print.rotate_x(180);
  prints.add(print);

  print_color = color(0,0,255);
  print = new Print("Peeking1_fillets.stl", print_color);
  //print.rotate_x(180);
  print.y = 180;
  prints.add(print);
 
  print_color = color(255, 204, 0);
  print = new Print("Caesar_With_Supports.stl", print_color);
  print.rotate_x(90);
  print.y = 60;
  //prints.add(print);
}

public void draw() {
  background(bg);
  directionalLight(255, 255, 255, 1, 1, 1);
  directionalLight(255, 255, 255, -1, -1, 1);
  
  translate(width/2, height);
  rotateY(Y_SPEED*frameCount);

  scale(2);
  gfx.origin(100);
  for (Print print : prints) {
    print.draw_print();  
  }
  
  if (frameCount % (BACKGROUND_REFRESH_TIME*60) == 0) {
    thread("reload_background");
  }
}

void mouseClicked(){
  if (mouseButton == RIGHT){
    // Function goes here.
  }
}

public void reload_background() {
  bg = loadImage(img_url, "jpg");
}


class Print extends Coordinates{
  PShape shape;
  Mesh3D mesh;
  Angles rotation = new Angles();
  
  Print(String stl_path, color tempfilament) {
    super();
    
    Mesh3D mesh = new STLReader().loadBinary(sketchPath(stl_path), STLReader.TRIANGLEMESH);
    this.mesh = mesh;
    this.sync_mesh_center();
    this.shape = this.mesh3D_to_pshape(this.mesh);
    this.shape.setFill(tempfilament);
  }
  
  private PShape mesh3D_to_pshape(final Mesh3D m) {
    m.computeVertexNormals();
    PShape shp;
    Collection<Face> triangles = m.getFaces();

    shp = createShape();
    shp.setStroke(false);
    shp.beginShape(PConstants.TRIANGLES);
    shp.textureMode(PConstants.NORMAL);

    for (final Face t : triangles) {
      shp.normal(t.a.normal.x, t.a.normal.y, t.a.normal.z);
      shp.vertex(t.a.x, t.a.y, t.a.z);

      shp.normal(t.b.normal.x, t.b.normal.y, t.b.normal.z);
      shp.vertex(t.b.x, t.b.y, t.b.z);
      
      shp.normal(t.c.normal.x, t.c.normal.y, t.c.normal.z);
      shp.vertex(t.c.x, t.c.y, t.c.z);
    }
    shp.endShape();
    shp.setShininess(100);
    return shp;
  }
  
  private void sync_mesh_center(){
    this.mesh.center(new Vec3D(this.x, this.y, this.z));
  }
  
  public void move_x(float x){
    this.x=x;
    this.sync_mesh_center();
  }
  
  public void move_y(float y){
    this.y=y;
    this.sync_mesh_center();
  }
  
  public void move(float z){
    this.z=z;
    this.sync_mesh_center();
  }
  
  public void move(float x, float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
    this.sync_mesh_center();
  }
  
  public void rotate_x(float rotation_x) {
    this.rotation.set_x(rotation_x);
  }
  
  public void rotate_y(float rotation_y) {
    this.rotation.set_y(rotation_y);
  }
  
  public void rotate_z(float rotation_z) {
    this.rotation.set_y(rotation_z);
  }
  
  public void draw_print(){
    pushMatrix();
    
    rotateX(this.rotation.x);
    rotateY(this.rotation.y);
    rotateZ(this.rotation.z);
    
    translate(this.x, -this.y, this.z);
  
    shape(this.shape);
    
    popMatrix();
  }
}
