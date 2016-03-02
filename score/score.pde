// Eric Heep

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PFont f;
float[] pitch;

void setup() {
  size(500, 500);

  pitch = new float[5];

  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  // create the font
  printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(f);
  textAlign(CENTER, CENTER);

  colorMode(HSB, 360);
  noCursor();
}

// native osc function
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/pitch") == true) {
    pitch[msg.get(0).intValue()] = msg.get(1).floatValue();
  }
}

void draw() {
  rect(0, 0, width, height);
  for (int i = 0; i < 5; i++) {
    text(pitch[i], width/6.0 * i + width/6.0, height/2.0);
  }
}
