/**
 * Based on topographic by Kjetil Midtgarden Golid
 * @link https://raw.githubusercontent.com/kgolid/topographic/master/index.js
 */

Grid grid;
FloatList noiseGrid;
float delta = 0.7 / 10;
float persistence = 0.45;
float noiseDim = 0.0025;

color[] palette = {
  color(0, 91, 197),
  color(0, 180, 252),
  color(23, 249, 255),
  color(223, 147, 0),
  color(248, 190, 0)
};

void setup() {
    size(800, 800);
    background(0);
    noFill();
    stroke(255);

    grid = new Grid();
    grid.cellWidth = 2;
    grid.init();
    noiseGrid = noiseGrid();
}

FloatList noiseGrid() {

    FloatList noiseGrid = new FloatList();
    for (int x = 0; x < grid.cols+1; x++) {
        for (int y = 0; y < grid.rows+1; y++) {
            
            float noise = 0;
            float maxAmp = 0;
            float amp = 1;
            float freq = noiseDim;

            for( int iter = 0; iter < 16; iter++ ) {
                noise += noise(14.3 + x * freq, 5.71 + y * freq ) * amp;
                maxAmp += amp;
                freq *= 2;
            }
            noiseGrid.append( noise / maxAmp);
        }
    }
    return noiseGrid;
}
FloatList build_threshold_list(float init, int steps, float delta) {
    FloatList thresholds = new FloatList();
    for(int t = 0; t <= steps; t++) {
        float threshold = init + t * delta;
        thresholds.append(threshold);
    }
    return thresholds;
}

void draw() {
    
    FloatList thresholds = build_threshold_list(0.3, 120, delta);
    color currentColor = palette[int( palette.length * random(1))];

    for (int x = 0; x < grid.cols; x++) {

        for (int y = 0; y < grid.rows; y++) {

            FloatList local_thresholds = new FloatList();

            int _x = (x * grid.cellWidth) + grid.outer_x_margin;
            int _y = (y * grid.cellWidth) + grid.outer_y_margin;

            //rect(_x + 12, _y + 12, grid.cellWidth-24, grid.cellWidth-24);

            float v1 = noiseGrid.get((x * grid.cols) + y);
            float v2 = noiseGrid.get((x * grid.cols) + y + 1);
            float v3 = noiseGrid.get(((x+1) * grid.cols) + y + 1);
            float v4 = noiseGrid.get(((x+1) * grid.cols) + y);
            float[] vValues = {v1, v2, v3, v4};
            float min = min(vValues);
            float max = max(vValues);

            for( int t = 0; t < thresholds.size(); t++ ) {
                float threshold = thresholds.get(t);
                if( threshold >= min - delta && threshold <= max ) {
                    local_thresholds.append(threshold);
                }
            }
            for( float threshold : local_thresholds ) {
                float b1 = v1 > threshold ? 8 : 0;
                float b2 = v2 > threshold ? 4 : 0;
                float b3 = v3 > threshold ? 2 : 0;
                float b4 = v4 > threshold ? 1 : 0;

                int id = int( b1 + b2 + b3 + b4 );
                stroke(currentColor);
                draw_line(id, v1, v2, v3, v4, threshold, grid.cellWidth);
            }
        }
    }
}

void draw_line(int id, float nw, float ne, float se, float sw, float threshold, int dim) {

  PVector n = new PVector( map(threshold, nw, ne, 0, dim), 0);
  PVector e = new PVector( dim, map(threshold, ne, se, 0, dim));
  PVector s = new PVector( map(threshold, sw, se, 0, dim), dim);
  PVector w = new PVector( 0, map(threshold, nw, sw, 0, dim));

  if (id == 1 || id == 14) line(s.x, s.y, w.x, w.y);
  else if (id == 2 || id == 13) line(e.x, e.y, s.x, s.y);
  else if (id == 3 || id == 12) line(e.x, e.y, w.x, w.y);
  else if (id == 4 || id == 11) line(n.x, n.y, e.x, e.y);
  else if (id == 6 || id == 9) line(n.x, n.y, s.x, s.y);
  else if (id == 7 || id == 8) line(w.x, w.y, n.x, n.y);
  else if (id == 5 || id == 10) {
    line(e.x, e.y, s.x, s.y);
    line(w.x, w.y, n.x, n.y);
  }
}