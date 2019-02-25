import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import java.util.Collection;
import java.io.File;


ToxiclibsSupport gfx;
String img_url;
PImage bg;
float Y_SPEED = -0.025;
int CAMERA_ROTATION = 0;
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
  
  prints = new ArrayList<Print>();
  // fetch all stl files on the folder 
  ArrayList<String> filenames = get_stl_filenames();
  for (String filename : filenames){
    Print new_print = load_print(filename);
    
    for (Print fixed_print : prints){
}

public void draw() {
  directionalLight(255, 255, 255, 1, 1, 1);
  directionalLight(255, 255, 255, -1, -1, 1);
  directionalLight(255, 255, 255, -1, -1, -1);
  directionalLight(255, 255, 255, 1, 1, -1);
  
  background(bg);
  
  float orbitRadius = 300;
  float ypos = height/3;
  float xpos = cos(radians(CAMERA_ROTATION))*orbitRadius;
  float zpos = sin(radians(CAMERA_ROTATION))*orbitRadius;
  camera(xpos, ypos, zpos, 0, 0, 0, 0, -1, 0);

  scale(1.25);
  gfx.origin(100);
  
  for (Print print : prints) {
    print.draw();  
  }
  
  if (frameCount % (BACKGROUND_REFRESH_TIME*60) == 0) {
    thread("reload_background");
  }
  CAMERA_ROTATION++;
}

void mouseClicked(){
  if (mouseButton == RIGHT){
    setup_prints();
  }
}

public void reload_background() {
  bg = loadImage(img_url, "jpg");
}

public ArrayList<String> get_stl_filenames() {
  ArrayList<String> filenames = new ArrayList<String>();
  
  File directory = new File(sketchPath());
  File files[] = directory.listFiles();
  
  Arrays.sort(files, new Comparator<File>() {
    public int compare(File f1, File f2) {
      return -Long.compare(f1.length(), f2.length());
    }
  });
  
  for (File file : files)
    if (file.getName().endsWith((".stl")))
      filenames.add(file.getName());
  return filenames;
}

public color randomColor(){
  return color(random(255), random(255), random(255));
}

public Print load_print(String filename){
  color print_color = randomColor();
  Print print = new Print(filename, print_color);
  return print;
}

public Print arrange_print(Print print, Print fixed_print){
  while(print.getBoundingBox().intersectsBox(fixed_print.getBoundingBox())){
    float inc = 50.0;
    float x_inc = random(-inc, inc);
    float y_inc = random(-inc, inc);
    float z_inc = random(-inc, inc);
    print.update_x(print.x+x_inc);
    print.update_y(print.y+y_inc);
    print.update_z(print.z+z_inc);
  }
  return print;
}
