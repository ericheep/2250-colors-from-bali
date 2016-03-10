// Eric Heep

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PFont f;
String[] upcomingPitch;
String[] currentPitch;
String[][] collection;

int metronome, chuckFrameCount, fadeDir;
float fadeScale, topAlpha, botAlpha, topOffset, botOffset;
int fadeFrames = -1;
int inc = 0;


void setup() {
  //size(800, 800);
  fullScreen();
  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  // create the font
  // printArray(PFont.list());
  f = createFont("Menlo-Regular", 24, true);
  textFont(f);
  textAlign(CENTER, CENTER);
  textSize(45);

  colorMode(HSB, 360);
  noCursor();

  ellipseMode(CENTER);

  upcomingPitch = new String[10];
  currentPitch = new String[10];
  collection = new String[2250][10];
  for (int i = 0; i < collection.length; i++) {
    for (int j = 0; j < 10; j++) {
      collection[i][j] = int(random(9)) + "";
    }
  }

  for (int i = 0; i < currentPitch.length; i++) {
    upcomingPitch[i] = "_";
    currentPitch[i] = "_";
  }
  frameRate(60);
}

// native osc function
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/fadeData") == true) {
    fadeFrames = msg.get(0).intValue();
    fadeDir = msg.get(1).intValue();
    chuckFrameCount = 0;
  }
  if (msg.checkAddrPattern("/upcomingPitches") == true) {
    for (int i = 0; i < 10; i++) {
      currentPitch[i] = upcomingPitch[i];
      upcomingPitch[i] = msg.get(i).stringValue();
    }
  }
  if (msg.checkAddrPattern("/metronome") == true) {
    metronome = msg.get(0).intValue();
  }
}

void draw() {
  fill(0, 0, 360);
  rect(-1, -1, width + 1, height + 1);

  /*
  textSize(10);
   fill(0, 0, 360);
   inc = 0;
   for (int i = 0; i < 10; i++) {
   text(collection[0][i], width/100.0 + inc * width/101, 30);
   inc++;
   if (i == 1 || i == 3 || i == 5 || i == 7) {
   inc++;
   }
   }
   */

  chuckFrameCount++;
  fadeScale = chuckFrameCount/float(fadeFrames) * 360.0;

  topAlpha = fadeScale/2.0;
  botAlpha = (360 - fadeScale * 2);

  if (fadeDir == 0) {
    topOffset = -1;
    botOffset = 1;
  } else {
    topOffset = 1;
    botOffset = -1;
  }

  float h = height/4.0 * 3 + 35;

  for (int i = 0; i < 4; i++) {
    //stroke(0, 0, 0);
    //line((i + 1) * width/4.0, 0, height, height);
  }

  inc = 0;
  for (int i = 0; i < 10; i++) {
    fill(0, 0, 0, topAlpha);
    text(upcomingPitch[i], width/15.0 * inc + width/16.0, h + 55 * topOffset);

    fill(0, 0, 0, botAlpha);
    text(currentPitch[i], width/15.0 * inc + width/16.0, h + 55 * botOffset);
    inc++;
    if (i == 1 || i == 3 || i == 5 || i == 7) {
      inc++;
    }
  }
  fill (0, 0, 360);
  ellipse(width/9.0 * metronome + width/9.0, h + 10, 10, 10);
}