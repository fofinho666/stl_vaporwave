class FileManagement {
  // TUDO IMPROVE I know it's not great. 
  String path;
  File directory;
  File files[]; 
  int number_of_files;
  long directory_modification;
  
  FileManagement(String path){
    this.path = path;
    this.directory = new File(path);
    this.files = this.directory.listFiles();
    this.number_of_files = this.files.length;
  }
  
  private void updateDirectoryAndFiles(){
    this.directory = new File(path);
    this.files = this.directory.listFiles();
  }
  private long lastModification(){
    updateDirectoryAndFiles();
    
    long last_modification=0;
    for(File file : this.files){
        if (file.isFile()){
          long new_last_modification = file.lastModified();
          if(new_last_modification>last_modification){
            last_modification = new_last_modification;
          }
        }
    }
    return last_modification;
  }
  
  public boolean directoryHasChanged(){
    if (this.files.length != this.directory.listFiles().length){
      return true;
    }
    long new_last_modification = this.lastModification();
    if(new_last_modification>this.directory_modification){
      this.directory_modification = new_last_modification;
      return true;      
    } 
    return false;
  }
  
  public ArrayList<String> get_stl_filenames() {
    ArrayList<String> filenames = new ArrayList<String>();
    updateDirectoryAndFiles();
    try{
      Arrays.sort(this.files, new Comparator<File>() {
        public int compare(File f1, File f2) {
          return -Long.compare(f1.length(), f2.length());
        }
      });
  
      for (File file : this.files){
        if (file.getName().toLowerCase().endsWith(".stl")){
          String filename = this.directory + "/" + file.getName();
          filenames.add(filename);
        }
      }
    } 
    catch(NullPointerException e){
      filenames = new ArrayList<String>();
    }
    return filenames;
  }
}
