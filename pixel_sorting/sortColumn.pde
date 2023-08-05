void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yEnd = 0;
  
  while (yEnd < imgs[edition].height - 1) {
    switch (mode) {
      case 0:
        y = getFirstNoneWhiteY(x, y);
        yEnd = getNextWhiteY(x, y);
        break;
      case 1:
        y = getFirstNoneBlackY(x, y);
        yEnd = getNextBlackY(x, y);
        break;
      case 2:
        y = getFirstNoneBrightY(x, y);
        yEnd = getNextBrightY(x, y);
        break;
      case 3:
        y = getFirstNoneDarkY(x, y);
        yEnd = getNextDarkY(x, y);
        break;
      default:
        break;
    }
    
    if (y < 0) break;
    
    int sortingLength = yEnd-y;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      if (willMovePixInSpiral) { 
        unsorted[i] = spiralImage.pixels[x + (y+i) * imgs[edition].width];
      } else if (willMovePixInCircle) {
        unsorted[i] = polarImage.pixels[x + (y+i) * imgs[edition].width];
      } else {
        unsorted[i] = imgs[edition].pixels[x + (y+i) * imgs[edition].width];
      }
    }
    
    sorted = sort(unsorted);
    if(sortInverse) {
      sorted = reverse(sorted);
    }

    for (int i = 0; i < sortingLength; i++) {
      if (useNoiseDisplacement) {
         noiseDisplacement(x, y+i, sorted[i]); 
      }
      imgs[edition].pixels[x + (y+i) * imgs[edition].width] = sorted[i];
    }
    
    y = yEnd+1;
    updateBand(y);
  }
}
