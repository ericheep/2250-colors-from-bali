// Eric Heep

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PFont f;
String[] pitch;

void setup() {
  size(500, 500);

  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  // create the font
  // printArray(PFont.list());
  f = createFont("Menlo-Regular", 24, true);
  textFont(f);
  textAlign(CENTER, CENTER);
  textSize(32);

  colorMode(HSB, 360);
  noCursor();

  pitch = new String[5];
  
  for (int i = 0; i < pitch.length; i++) {
     pitch[i] = "_"; 
  }
}

// native osc function
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/pitch") == true) {
    pitch[msg.get(0).intValue()] = msg.get(1).stringValue();
  }
}

void draw() {
  //noStroke();
  fill(0, 0, 0);
  rect(-1, -1, width + 1, height + 1);
  for (int i = 0; i < 5; i++) {
    fill(0, 0, 360);
    text(pitch[i], width/6.0 * i + width/6.0, height/2.0);
  }
}