from opensimplex import OpenSimplex

recording = True
numFrames = 75
margin = 16
radius = 0.05
step = 2
simplex = OpenSimplex()
strokeColor = 0

def setup():
  size(800, 800)
  background(255)
  stroke(strokeColor)
  noFill()

def draw():

  t = 1.0 * frameCount / numFrames
  background(255)

  scale = 0.005

  loadPixels()

  for x in xrange(margin, width-margin, step):
  
    for y in xrange(margin, height-margin, step):

      noiseValue = simplex.noise4d(
        scale * x,
        scale * y,
        radius * cos(TWO_PI * t),
        radius * sin(TWO_PI * t)
      )

      roundNoise = round( noiseValue * 100 ) / 100

      b = ( roundNoise % 0.01 ) == 0

      if b:

        pixels[x+width*y] = color( strokeColor )
        point(x, y)


  updatePixels()

  if frameCount <= numFrames and recording :
    saveFrame("records/frame-###.jpg")

  if frameCount == numFrames and recording :
    println("Finished")
    exit()
