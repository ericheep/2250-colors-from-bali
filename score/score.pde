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

void setup() {
  size(800, 800);

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

  ellipseMode(CENTER);

  upcomingPitch = new String[10];
  currentPitch = new String[10];
  collection = new String[2250][10];

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
  chuckFrameCount++;
  fadeScale = chuckFrameCount/float(fadeFrames) * 360.0;

  int inc = 0;
  topAlpha = fadeScale;
  botAlpha = (360 - fadeScale);

  if (fadeDir == 0) {
    topOffset = -1;
    botOffset = 1;
  } else {
    topOffset = 1;
    botOffset = -1;
  }

  fill(0, 0, 0);
  rect(-1, -1, width + 1, height + 1);
  for (int i = 0; i < 10; i++) {
    fill(0, 0, 360, topAlpha);
    text(upcomingPitch[i], width/15.0 * inc + width/16.0, height/2.0 + 50 * topOffset);

    fill(0, 0, 360, botAlpha);
    text(currentPitch[i], width/15.0 * inc + width/16.0, height/2.0 + 50 * botOffset);
    inc++;
    if (i == 1 || i == 3 || i == 5 || i == 7) {
      inc++;
    }
  }
  fill (0, 0, 360);
  ellipse(width/9.0 * metronome + width/9.0, height/2.0, 10, 10);
}