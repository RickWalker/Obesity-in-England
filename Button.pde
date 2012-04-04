
class Button
{
  int x, y;
  int width;
  int height;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;  
  boolean locked = false;
  String label = "";

  void update() 
  {
    if (over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }

    if (mousePressed && over() && !locked) {
      locked = true;
    }

    if (!mousePressed) {
      locked = false;
    }
  }

  boolean pressed() 
  {
    if (!mousePressed) { 
      return false;
    }

    if (over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }
  }

  boolean over() 
  { 
    return true;
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, int iheight, color icolor, color ihighlight, String l) 
  {
    x = ix;
    y = iy;
    width = isize;
    height = iheight;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
    label = l;
  }

  boolean over() 
  {
    if ( overRect(x, y, width, height) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display(boolean textBefore) 
  {
    fill(255);   
    if (textBefore) {
      text(label, x - label.length() * 8.3, y+height);
    } 
    else {
      text(label, x + width + 9, y+height);
    }

    stroke(255);
    fill(currentcolor);
    rect(x, y, width, height);
  }
}


class RectToggleButton extends ToggleButton
{
  RectToggleButton(int ix, int iy, int isize, int iheight, color icolor, color ihighlight, String l) 
  {
    x = ix;
    y = iy;
    width = isize;
    height = iheight;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
    label = l;
  }

  boolean over() 
  {
    if ( overRect(x, y, width, height) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    if (!value) {
      if (!over()) {
        fill(currentcolor);
      }else{
        fill(highlight);
      }
    } 
    else fill(selected);
    rect(x, y, width, height);

    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x +width/2, y+height/2);
  }
}


class ToggleButton extends Button {
  boolean value = false;

  void update() 
  {
    if (over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }

    if (mousePressed && over() && !locked) {
      locked = true;
      value = !value;
      //     println(value);
    }

    if (!mousePressed) {
      locked = false;
    }
  }
}

