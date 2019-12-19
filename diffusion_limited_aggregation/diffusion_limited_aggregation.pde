/**
 * Based on Daniel Shiffman p5 sketch 
 * https://thecodingtrain.com/CodingChallenges/034-dla.html
 * and it transcription to processing by
 * Chuck England
 */

import java.util.*;

List<Walker> tree = new ArrayList<Walker>();
List<Walker> walkers = new ArrayList<Walker>();
List<Branch> branches = new ArrayList<Branch>();

//float r = 4;
int maxWalkers = 75;
int iterations = 1000;
float radius = 6;
float hue = 0;
float shrink = 0.999;

void setup() {
  size(1080, 1080);

  tree.add(new Walker(width / 2, height / 2));
  radius *= shrink;
  for (int i = 0; i < maxWalkers; i++) {
    walkers.add(new Walker());
    radius *= shrink;
  }
}

void draw() {
  background(0);
 
  for( Branch b : branches) {
    b.show();
  }
 
  for (int n = 0; n < iterations; n++) {
    for (int i = walkers.size() - 1; i >= 0; i--) {
      Walker walker = walkers.get(i);
      walker.walk();
      int branchId = walker.closeTreeID(tree);
      if ( branchId != -1 ) {
        walker.setHue(hue % 360);
        hue += 2;
        tree.add(walker);
        Branch newBranch = new Branch(tree.get(branchId).pos, walker.pos, walker.r);
        branches.add(newBranch);
        walkers.remove(i);
      }
    }
  }

  //float r = walkers.get(walkers.size() - 1).r;
  while (walkers.size() < maxWalkers && radius > 1) {
    radius *= shrink;
    walkers.add(new Walker());
  }

  if( mousePressed == true ) {
    saveFrame("records/frame-###.jpg");
  }
}
