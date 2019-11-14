class Block {

  PVector position;
  float rW,rH;
  boolean direction;
  int colorId;

  Block() {}

  Block(
    float w,
    float h,
    int minWidth,
    int maxWidth,
    int minHeight,
    int maxHeight
  ) {

    this();
    this.position = new PVector( random(1) * w , random(1) * h);
    this.direction = random(1) < 0.5;
    this.rW = direction ? random(minWidth, maxWidth) : random(minHeight, maxHeight);
    this.rH = direction ? random(minHeight, maxHeight) : random(minWidth, maxWidth);

  }

}