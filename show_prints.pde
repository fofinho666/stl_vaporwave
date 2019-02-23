import toxi.geom.*;
import toxi.geom.mesh.*;
import processing.opengl.*;
import java.util.Collection;

String img_url;
PImage bg;
float y_speed;
ArrayList<Print> prints;

public void setup() {
  size(800, 600, P3D);

  // Load image from unsplash
  img_url = "https://source.unsplash.com/collection/923267/"+width+"x"+height;
  bg = loadImage(img_url, "jpg");

  y_speed = 0.025f;

  prints = new ArrayList<Print>();
  setup_prints();
}

public void setup_prints() {
  color print_color; 
  Print print;

  print_color = color(255,0,0);
  print = new Print("test.stl", print_color);
  prints.add(print);

  print_color = color(0,255,0);
  print = new Print("climbing.stl", print_color);
  prints.add(print);

  print_color = color(0,0,255);
  print = new Print("Peeking1_fillets.stl", print_color);
  print.x = -10;
  print.y = -180;
  prints.add(print);
 
  print_color = color(255, 204, 0);
  print = new Print("Caesar_With_Supports.stl", print_color);
  print.y = -60;
  print.rotate_x(90);
  prints.add(print);
}

public void draw() {
  background(bg);
  directionalLight(255, 255, 255, -width, -height, 500);
  translate(width/2, height);
  rotateY(y_speed*frameCount);

  scale(2);
  for (Print print : prints) {
    print.draw_print();  
  }
  
  if (frameCount % 500 == 0) {
    thread("reload_background");
  }
}

public void reload_background() {
  bg = loadImage(img_url, "jpg");
}


class Print extends Coordinates{
  PShape shape;
  Angles rotation = new Angles();
  
  Print(String stl_path, color tempfilament) {
    super();
    Mesh3D mesh = new STLReader().loadBinary(sketchPath(stl_path), STLReader.TRIANGLEMESH);
    this.shape = this.Mesh3DToPShapeSmooth(mesh);
    this.shape.setFill(tempfilament);
  }
  
  private PShape Mesh3DToPShapeSmooth(final Mesh3D m) {
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
    shp.setSpecular(0xFFFFFFFF);
    shp.setShininess(100);
    return shp;
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
  
    translate(this.x, this.y, this.z);
  
    rotateX(this.rotation.x);
    rotateY(this.rotation.y);
    rotateZ(this.rotation.z);

    shape(this.shape);
    
    popMatrix();
  }
}
