class ToggleGroup {
  String value; //the string contents of the selected button
  List<RectToggleButton> filterButtons;
  String label;
  int x,y;
  int width;
  int height;
  ToggleGroup(String label, int x, int y, int width, int height) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    value = "All";
    filterButtons = new ArrayList<RectToggleButton>();
  }
  
  void addButton(RectToggleButton a){
    filterButtons.add(a);
  }
  
  void addButton(String a){
    //add button automagically with this label!
    addButton(new RectToggleButton(x + width*filterButtons.size(), y, width, height, buttoncolor, highlight, a));
  }

  void draw() {
    //draw label first
    fill(axesColor);
    stroke(axesColor);
    textAlign(RIGHT, CENTER);
    text(label+"  ",x,y+height/2);
    for (RectToggleButton a: filterButtons) {
      a.update();
      if (mousePressed && a.over()) {
        if (a.value) { //turning on!
          //println("Found update!");
          value = a.label;
          //unset all the others!
          for (RectToggleButton b: filterButtons) {
            if (a!=b) b.value = false;
          }
        }
        else {
          value = "All";
        }
        updateTargets();
      }
      a.display();
    }
  }
}

