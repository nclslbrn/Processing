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
    .setRange(0, 255)
    .setValue(50)
    .setColorCaptionLabel(color(255));

  cp5.addSlider("blackValueSlider")
    .setPosition(20, 160)
    .setSize(200, 20)
    .setRange(0, 255)
    .setValue(200)
    .setColorCaptionLabel(color(255));

  willSortRowToggle = cp5.addToggle("willSortRow")
    .setPosition(20, 220)
    .setSize(60, 20);

  willSortColumnToggle = cp5.addToggle("willSortColumn")
    .setPosition(140, 220)
    .setSize(60, 20);

  radioButton = cp5.addRadioButton("interpolation")
    .setPosition(20, 280)
    .setSize(60, 40)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(3)
    .setSpacingColumn(20)
    .addItem("spiral", 1)
    .addItem("circle", 2)
    .addItem("bitwise", 3);

  useNoiseDisplacementToggle = cp5.addToggle("useNoiseDisplacement")
    .setPosition(20, 340)
    .setSize(180, 20);

  cp5.addButton("previous")
    .setValue(0)
    .setPosition(20, 380)
    .setSize(40, 20);

  cp5.addButton("next")
    .setValue(0)
    .setPosition(180, 380)
    .setSize(40, 20);

  textLabel = cp5.addTextlabel("label")
    .setText("Edition #" + edition)
    .setPosition(90, 385)
    .setColorValue(#FFFFFF);
}

void brightValueSlider(int val) { brightValue = val; applet.init(); }

void darkValueSlider(int val) {  darkValue  = val; applet.init(); }

void whiteValueSlider(int val) { whiteValue = val*val*val*-1; applet.init(); }

void blackValueSlider(int val) { blackValue = val*val*val*-1; applet.init(); }

void previous() {
  if (edition > 0) {
    edition--;
    if (textLabel != null) textLabel.setText("Edition #" + edition);
    applet.init();
  }
}

void next() {
  if(edition < editionNum-1) {
    edition++;
    if (textLabel != null) textLabel.setText("Edition #" + edition);
    applet.init();
  }
}

void toggle() { println("toggle"); applet.init(); }

void keyPressed() {
  switch(key) {
    case('0'): radioButton.deactivateAll(); break;
    case('1'): radioButton.activate(0); break;
    case('2'): radioButton.activate(1); break;
  }
  println(key);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(radioButton)) {
    if (int(theEvent.getGroup().getValue()) == -1) {
      willMovePixInSpiral = false;
      willMovePixInCircle = false;
      willMovePixBitwise = false;
      println("deactivate willMovePixInSpiral & willMovePixInCircle");

    }
    if (int(theEvent.getGroup().getValue()) == 1) {
      willMovePixInSpiral = !willMovePixInSpiral;
      willMovePixInCircle = false;
      willMovePixBitwise = false;
      println("toggle willMovePixInSpiral");
    }
    if (int(theEvent.getGroup().getValue()) == 2) {
      willMovePixInCircle = !willMovePixInCircle;
      willMovePixInSpiral = false;
      willMovePixBitwise = false;
      println("toggle willMovePixInCircle");
    }
    if (int(theEvent.getGroup().getValue()) == 3) {
      willMovePixBitwise = !willMovePixBitwise;
      willMovePixInSpiral = false;
      willMovePixInCircle = false;
    }
    applet.init();
  }

  if (
    theEvent.isFrom(willSortColumnToggle) ||
    theEvent.isFrom(willSortRowToggle) ||
    theEvent.isFrom(useNoiseDisplacementToggle)
  ) {
    applet.init();
  }
}
