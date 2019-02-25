import toxi.geom.*;
import toxi.geom.mesh.*;
//import toxi.processing.*;
import java.util.Comparator;
import java.util.Collection;
import java.io.File;
import java.util.Arrays;

//ToxiclibsSupport gfx;
String img_url;
PImage bg;
float Y_SPEED = -0.025;
int CAMERA_ROTATION = 0;
int BACKGROUND_REFRESH_TIME = 15;
int FOLDER_REFRESH_TIME = 60;
ArrayList<Print> prints;
FileManagement file_management;

public void setup() {
  size(600, 600, P3D);
  
  // Load image from unsplash
  img_url = "https://source.unsplash.com/collection/923267/"+width+"x"+height;
  bg = loadImage(img_url, "jpg");
  String stl_directory = sketchPath() + "/stl";
  
  //gfx = new ToxiclibsSupport(this);
  
  file_management = new FileManagement(stl_directory);
  setup_prints();
}

public void setup_prints() {
  // fetch all stl files on the folder 
  ArrayList<String> filenames = file_management.get_stl_filenames();
  prints = new ArrayList<Print>();
  for (String filename : filenames){
    color print_color = randomColor();
    Print new_print = new Print(filename, print_color);
    
    for (Print fixed_print : prints){
      new_print = arrange_print(new_print, fixed_print);
    }
    prints.add(new_print);
  }
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
  
  rotateX(radians(-90));
  scale(1.5);
  //gfx.origin(100);
  
  for (Print print : prints) {
    print.draw();  
  }
  
  if (frameCount % (BACKGROUND_REFRESH_TIME*60) == 0) 
    thread("reload_background");
  
  if (frameCount % (FOLDER_REFRESH_TIME*60) == 0) 
    if (file_management.directoryHasChanged())
      setup_prints();
  
  CAMERA_ROTATION++;
}

void mouseClicked(){
  if (mouseButton == RIGHT){
    setup_prints();
  }
}

public void reload_background() {
  PImage new_bg = loadImage(img_url, "jpg");
  if (new_bg != null){
    bg = new_bg;
  }
}

public color randomColor(){
  return color(random(255), random(255), random(255));
}

public Print arrange_print(Print print, Print fixed_print){
  for(int attempts=0; print.getBoundingBox().intersectsBox(fixed_print.getBoundingBox()); attempts++){
    if (attempts==200)
      break;
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
