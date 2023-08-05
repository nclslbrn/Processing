void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xEnd = 0;
  
  while (xEnd < imgs[edition].width - 1) {
    switch (mode) {
      case 0:
        x = getFirstNoneWhiteX(x, y);
        xEnd = getNextWhiteX(x, y);
        break;
      case 1:
        x = getFirstNoneBlackX(x, y);
        xEnd = getNextBlackX(x, y);
        break;
      case 2:
        x = getFirstNoneBrightX(x, y);
        xEnd = getNextBrightX(x, y);
        break;
      case 3:
        x = getFirstNoneDarkX(x, y);
        xEnd = getNextDarkX(x, y);
        break;
      default:
        break;
    }
    
    if (x < 0) break;
    
    int sortingLength = xEnd-x;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      if( willMovePixInSpiral) {
        unsorted[i] = spiralImage.pixels[x + i + y * imgs[edition].width];
      } else if (willMovePixInCircle) {
        unsorted[i] = polarImage.pixels[x + i + y * imgs[edition].width];
      } else {
        unsorted[i] = imgs[edition].pixels[x + i + y * imgs[edition].width];
      }
    }
    
    sorted = sort(unsorted);
    
    if(sortInverse) {
      sorted = reverse(sorted);
    }

    for (int i = 0; i < sortingLength; i++) {
      if (useNoiseDisplacement) {
         noiseDisplacement(x+i, y, sorted[i]); 
      }
      imgs[edition].pixels[x + i + y * imgs[edition].width] = sorted[i];      
    }
    
    x = xEnd+1;
    updateBand(x);
  }
}
