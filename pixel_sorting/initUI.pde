public void initUI() {
  cp5 = new ControlP5(this);
  cp5.addSlider("brightValueSlider")
    .setPosition(20, 40)
    .setSize(200, 20)
    .setRange(0, 255)
    .setValue(50)
    .setColorCaptionLabel(color(20,20,20));
    
  cp5.addSlider("darkValueSlider")
    .setPosition(20, 80)
    .setSize(200, 20)
    .setRange(0, 255)
    .setValue(200)
    .setColorCaptionLabel(color(20,20,20));
    
  cp5.addSlider("whiteValueSlider")
    .setPosition(20, 120)
    .setSize(200, 20)
    .setRange(-12345678, 0)
    .setValue(-12345678)
    .setColorCaptionLabel(color(255));
  
  cp5.addSlider("blackValueSlider")
    .setPosition(20, 160)
    .setSize(200, 20)
    .setRange(-3456789, -12345678)
    .setValue(-3456789)
    .setColorCaptionLabel(color(255));
    
  cp5.addButton("previous")
     .setValue(0)
     .setPosition(20, 360)
     .setSize(40, 20);

  cp5.addButton("next")
     .setValue(0)
     .setPosition(180, 360)
     .setSize(40, 20);
  
  r1 = cp5.addRadioButton("radioButton")
     .setPosition(40,200)
     .setSize(40, 20)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(2)
     .setSpacingColumn(50)
     .addItem("spiral", 1)
     .addItem("circle", 2);
}


void brightValueSlider(int val) { brightValue = val; applet.init(); }
void darkValueSlider(int val) {  darkValue  = val; applet.init(); }
void whiteValueSlider(int val) { whiteValue = val; applet.init(); }
void blackValueSlider(int val) { blackValue = val; applet.init(); }
void previous() { 
  if (edition > 0) {
    edition--;
    applet.init();
  } 
}
void next() {
  if(edition < editionNum-1) {
    edition++;
    applet.init();
  }
}
void keyPressed() {
  switch(key) {
    case('0'): r1.deactivateAll(); break;
    case('1'): r1.activate(0); break;
    case('2'): r1.activate(1); break;
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(r1)) {
    if (int(theEvent.getGroup().getValue()) == -1) {
      willMovePixInSpiral = false;
      willMovePixInCircle = false;
    }
    if (int(theEvent.getGroup().getValue()) == 1) {
      willMovePixInSpiral = !willMovePixInSpiral;
    }
    if (int(theEvent.getGroup().getValue()) == 2) {
      willMovePixInCircle = !willMovePixInCircle;
    }
    applet.init();
  }
}
