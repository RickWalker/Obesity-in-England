//Rick Walker 20111004
//Integrator and Table from Ben Fry's Visualizing Data
//Button based roughly on something I found. But it works differently now.
Table obesityData;
float data_max, data_min;
float all_max, all_min;
int minX, maxX, minY, maxY;
Integrator maxVal, minVal;
int yearRange = 16;
int selectedRow = -1;
int selectedCol = -1;
int majorRow = -1;
color axesColor = color(70);
ToggleGroup ages, sex;
PFont font;
PFont titleFont;

color buttoncolor = color(255);
color selected = color(125);
color highlight = color(190); 

void setup() {
  size(800, 500);
  smooth();
  //load data
  minX = 50;
  maxX = width-20;
  minY = 100;
  maxY = height-70;
  obesityData = new Table("obesity_data.tsv");
  setMaxMin();
  maxVal = new Integrator(data_max, 0.5, 0.05);
  minVal = new Integrator(data_min, 0.5, 0.05);
  font = loadFont("Univers-Bold-12.vlw");
  titleFont = loadFont("MyriadWebPro-Bold-24.vlw");////createFont("MyriadWebPro-Bold", 24);
  textFont(font);

  int buttonHeight = int(textAscent()+15);
  //setup GUI
  ages = new ToggleGroup("Age", 400, 25, 50, buttonHeight);
  String [] agesToAdd = {
    "16-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75+"
  };
  for (String a: agesToAdd)
    ages.addButton(a);

  sex = new ToggleGroup("Sex", 400, 49, 50, buttonHeight);
  sex.addButton("Men");
  sex.addButton("Women");
  updateTargets();
}

void setMaxMin() {
  data_max = 0.0;
  data_min = 110;
  for (int i = 1; i<obesityData.getRowCount();i++) {
    for (int j = 3; j<yearRange+3; j++) {
      //println(obesityData.getString(i, j));
      data_max = max(data_max, obesityData.getFloat(i, j));
      data_min= min(data_min, obesityData.getFloat(i, j));
    }
  }
  all_max = data_max;
  all_min = data_min;
  //println("Max is " + data_max + " and min is " + data_min);
  //data_min = 0; //better for graphs?
}

void draw() {
  background(255);
  textFont(font);
  update();
  drawData();
  drawAxes();
  drawGUI();
  drawTitle();
}

void drawTitle() {
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  text("Overweight and Obesity\n Statistics For England", 200, minY/2);
}

void cleanupEdges() {
  //cleanup the edges!
  rectMode(CORNERS);
  fill(255);
  noStroke();
  rect(0, 0, minX, height);
  rect(0, maxY, width, height);
  rect(0, 0, width, minY);
  rect(width, height, 0, maxX);
  rectMode(CORNER);
}

void updateTargets() {
  //special: all should show all lines!
  if (ages.value.equals("All") && sex.value.equals("All")) {
    data_max = all_max;
    data_min = all_min;
    maxVal.target(data_max);
    minVal.target(data_min);
    majorRow = obesityData.rowCount-1; //such a hack? last row is all/all
    //print("Using all values");
  }
  else {
    //find the min and max only for this selection!
    data_min = 110.0;
    data_max = 0;
    //println("Only using rows that match " + ages.value);
    for (int i = 1; i<obesityData.getRowCount();i++) {
      for (int j = 3; j<=yearRange+3; j++) {
        if (passesFilter(i)) {//obesityData.getString(i, 1).equals(ages.value)) {
          majorRow = i;
          //println(obesityData.getString(i, j));
          data_max = max(data_max, obesityData.getFloat(i, j));
          data_min = min(data_min, obesityData.getFloat(i, j));
        }
      }
    }
  }
  maxVal.target(data_max);
  minVal.target(data_min);
}

boolean passesFilter(int row) {
  if (obesityData.getString(row, 1).equals(ages.value) || ages.value.equals("All")) {
    if (obesityData.getString(row, 0).equals(sex.value) || sex.value.equals("All")) {
      return true;
    }
  }
  return false;
}


void update() {
  maxVal.update();
  minVal.update();
  data_min = minVal.value;
  data_max = maxVal.value;
}

void drawGUI() {
  ages.draw();
  sex.draw();
}

void drawData() {
  int yearStart = obesityData.getInt(0, 3);
  int yearEnd = obesityData.getInt(0, yearRange+3);
  //rely on max and min being set elsewhere
  selectedRow = -1;
  selectedCol = -1;
  for (int i = 1; i<obesityData.getRowCount();i++) {
    //row 1 is headers
    //columns 3 to yearRange+3 are the data for years

    strokeWeight(2);
    if (i!=majorRow) {
      stroke(128, 128);
    }
    else {
      stroke(#ec5166);
    }
    noFill();
    beginShape();
    for (int j = 3; j<=yearRange+3; j++) {
      //float dataValue = obesityData.getFloat(i, j);
      float x = map(j, 3, yearRange+3, minX, maxX);
      float y = map(obesityData.getFloat(i, j), data_min, data_max, maxY, minY);
      vertex(x, y);
      if (j<yearRange+3) {
        float nextX = map(j+1, 3, yearRange+3, minX, maxX);
        float nextY = map(obesityData.getFloat(i, j+1), data_min, data_max, maxY, minY);

        if (getDistance(x, y, nextX, nextY, mouseX, mouseY).z<3) {
          selectedRow = i;
          if (dist(mouseX, mouseY, x, y) < dist(mouseX, mouseY, nextX, nextY)) {
            //pick the nearest point to be selected
            //selectedRow = i;
            selectedCol = j;
          }
          else {
            selectedCol = j+1;
            //println("Near row!");
          }
        }
      }
    }
    endShape();
  }

  stroke(#333366);
  if (selectedRow !=-1) {
    if ( selectedRow != majorRow) {
      //println("Drawing selected row!");
      //redraw selected row for highlight!
      beginShape();
      for (int j = 3; j<=yearRange+3; j++) {
        //float dataValue = obesityData.getFloat(i, j);
        float x = map(j, 3, yearRange+3, minX, maxX);
        float y = map(obesityData.getFloat(selectedRow, j), data_min, data_max, maxY, minY);
        vertex(x, y);
      }
      endShape();
    }
  }

  cleanupEdges();
  if (selectedRow != -1) {
    if (selectedRow == majorRow) {
      stroke(#ec5166);
    }
    else {
      stroke(#333366);
    }
    //now draw the point highlight!
    drawPointHighlight();
  }
}

void drawPointHighlight() {
  strokeWeight(5);
  fill(0);
  float x = map(obesityData.getFloat(0, selectedCol), 1993, 2009, minX, maxX);
  float y = map(obesityData.getFloat(selectedRow, selectedCol), data_min, data_max, maxY, minY);
  if (y>=minY && y<=maxY &&x<=maxX && x>=minX ) {

    //println("Point at: " + map(obesityData.getFloat(0, selectedCol), 1993, 2008, minX, maxX) + ", " + map(obesityData.getFloat(selectedRow, selectedCol), data_min, data_max, maxY, minY));
    point(x, y);
    textAlign(LEFT, BOTTOM);
    String toDraw = " " + obesityData.getString(selectedRow, 0)+ " "+ obesityData.getString(selectedRow, 1)+ ": " + nf(obesityData.getFloat(selectedRow, selectedCol), 1, 1) + "% ";
    if (textWidth(toDraw) + x > maxX) {
      textAlign(RIGHT, BOTTOM);
    }
    text(toDraw, x, y);
  }
}

void drawAxes() {
  strokeWeight(3);
  stroke(axesColor);
  line(minX, maxY, maxX, maxY);
  line(minX, maxY, minX, minY);
  drawXAxisLabels();
  drawYLabels();
}

void drawXAxisLabels() {
  for (int j = 3; j<=yearRange+3; j++) {
    int dataValue = obesityData.getInt(0, j); //value to draw
    float x = map(j, 3, yearRange+3, minX, maxX);
    fill(axesColor);
    textAlign(CENTER, TOP);
    text(dataValue, x, maxY+textAscent());
  }
}

void drawYLabels() {
  fill(axesColor);
  //textSize(width/60); //guess an appropriate label size based on width
  textAlign(RIGHT);

  stroke(axesColor);
  strokeWeight(1);

  //actually draw ticks and labels
  for (int i =0; i<5; i++) {
    float val = (data_max - data_min)/4.0 *i + data_min;
    //float tickY = map( val, data_min, data_max, maxY, minY);  // y pos of this tick mark
    float tickY = maxY - i*(maxY-minY)/4.0; //work in pixels so that it doesn't move around!
    textAlign(RIGHT, CENTER);
    text(int(val)+"%", minX - 10, tickY); //draw label
    line(minX - 4, tickY, minX, tickY);     // Draw major tick
  }
}

/**
 * Returns a point on the line (x1,y1) -> (x2,y2) 
 * that is closest to the point (x,y)
 * 
 * The result is a PVector. 
 * result.x and result.y are points on the line. 
 * The result.z variable contains the distance from (x,y) to the line, 
 * just in case you need it :) 
 * courtesy of http://processing.org/discourse/yabb2/YaBB.pl?num=1276644884
 * (which is nicer than the way I used to do it)
 */
PVector getDistance( float x1, float y1, float x2, float y2, float x, float y ) {
  PVector result = new PVector(); 

  float dx = x2 - x1; 
  float dy = y2 - y1; 
  float d = sqrt( dx*dx + dy*dy ); 
  float ca = dx/d; // cosine
  float sa = dy/d; // sine 

  float mX = (-x1+x)*ca + (-y1+y)*sa; 

  if ( mX <= 0 ) {
    result.x = x1; 
    result.y = y1;
  }
  else if ( mX >= d ) {
    result.x = x2; 
    result.y = y2;
  }
  else {
    result.x = x1 + mX*ca; 
    result.y = y1 + mX*sa;
  }

  dx = x - result.x; 
  dy = y - result.y; 
  result.z = sqrt( dx*dx + dy*dy ); 

  return result;
}

