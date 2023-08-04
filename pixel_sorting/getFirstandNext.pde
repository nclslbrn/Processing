
// white x
int getFirstNoneWhiteX(int x, int y) {
  while (imgs[edition].pixels[x + y * imgs[edition].width] < whiteValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;
  while (imgs[edition].pixels[x + y * imgs[edition].width] > whiteValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// black x
int getFirstNoneBlackX(int x, int y) {
  while (imgs[edition].pixels[x + y * imgs[edition].width] > blackValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  while (imgs[edition].pixels[x + y * imgs[edition].width] < blackValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// bright x
int getFirstNoneBrightX(int x, int y) {
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < brightValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextBrightX(int x, int y) {
  x++;
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > brightValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// dark x
int getFirstNoneDarkX(int x, int y) {
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > darkValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextDarkX(int x, int y) {
  x++;
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < darkValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// white y
int getFirstNoneWhiteY(int x, int y) {
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] < whiteValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] > whiteValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}


// black y
int getFirstNoneBlackY(int x, int y) {
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] > blackValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextBlackY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] < blackValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}

// bright y
int getFirstNoneBrightY(int x, int y) {
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < brightValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextBrightY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > brightValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}

// dark y
int getFirstNoneDarkY(int x, int y) {
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > darkValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextDarkY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < darkValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}
