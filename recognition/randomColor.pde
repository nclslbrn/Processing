color randomColor() {

  color[] colors = {
    #1abc9c,
    #16a085,
    #2ecc71,
    #27ae60,
    #3498db,
    #2980b9,
    #9b59b6,
    #f1c40f,
    #f39c12,
    #e67e22,
    #d35400,
    #e74c3c,
  };

  int colorID = (int)random( 0, colors.length );
  color choosenColor = color( colors[ colorID ] );

  return choosenColor;
}
