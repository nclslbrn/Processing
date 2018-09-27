color randomColor() {

  color[] colors = {
    #1abc9c,
    #16a085,
    #2ecc71,
    #27ae60,
    #3498db,
    #2980b9,
    #9b59b6,
    #8e44ad,
    #34495e,
    #f1c40f,
    #f39c12,
    #e67e22,
    #d35400,
    #e74c3c,
    #c0392b,
    #ecf0f1,
    #bdc3c7,
    #95a5a6,
    #7f8c8d
  };

  int colorID = (int)random( 0, colors.length );
  println( colorID );
  color choosenColor = color( colors[ colorID ] );

  return choosenColor;
}
