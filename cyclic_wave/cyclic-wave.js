///<reference path= "../ts/p5.global-mode.d.ts"/>

var arcs = [];
const sketchSize = 800;
var numFrames = 75;
var margin = 12, // margin between circle
  noiseScale = 256,
  noiseRadius = 3,
  noiseStrength = 1.5,
  lineSize = 4,
  speed = 0, // the value wich increments circle's radiuses
  maxRadius = 0; // Limit the size of the arc circle

function getNoiseIntensity(x, y, t) {

  return noise(
    noiseRadius * cos(TWO_PI * t),
    noiseRadius * sin(TWO_PI * t)
  ) * noiseStrength;
}

function setup() {

  createCanvas(sketchSize, sketchSize, WEBGL);
  center = createVector(800 / 2, 800 / 2);
  maxRadius = sketchSize / 2.5;
  speed = maxRadius / numFrames;

  for (var c = margin; c <= maxRadius; c += margin) {

    var newArc;
    newArc = new EllipseSection(c, 0, [], center);
    newArc.init();
    arcs.push(newArc);
  }
}

function draw() {
  background(0);
  push();
  rotateX(PI / 3);

  var t = 1.0 * (frameCount < numFrames ? frameCount : frameCount % numFrames) / numFrames;

  for (var arcID = 0; arcID < arcs.length; arcID++) {

    var arc = arcs[arcID];
    var currentAngle = arc.initialAngle;

    for (var angleID = 0; angleID < arc.angles.length - 1; angleID += 2) {

      var strokeColor = map(arc.radius, 0, maxRadius, 255, 0);
      var lineWeight = map(arc.radius, 0, maxRadius, 0.1, 1.5);

      var start = currentAngle + arc.angles[angleID];
      var end = currentAngle + arc.angles[angleID + 1];

      var startPoint = createVector(
        arc.radius * cos(start),
        arc.radius * sin(start)
      );

      var endPoint = createVector(
        arc.radius * cos(end),
        arc.radius * sin(end)
      );

      var distance = startPoint.dist(endPoint);
      var currentPoint = startPoint;

      stroke(strokeColor);
      strokeWeight(lineWeight);

      for (var d = 0; d <= distance; d += lineSize) {

        var ratio = d / distance;

        var x = startPoint.x + (endPoint.x - startPoint.x) * ratio;
        var y = startPoint.y + (endPoint.y - startPoint.y) * ratio;

        var pointNoise = getNoiseIntensity(x, y, t);

        beginShape(LINES);
        vertex(currentPoint.x, currentPoint.y, 0);
        vertex(
          x + noiseRadius * cos(pointNoise),
          y + noiseRadius * sin(pointNoise),
          0
        );
        endShape();

        currentPoint = createVector(x, y);
      }
      currentAngle = end;
    }
    arc.radius += speed;

    if (arc.radius >= maxRadius) {
      if (arcID != 1) {
        arc.radius = margin;
      }
    }
  }
  pop();
}

class EllipseSection {

  constructor(radius, initialAngle, angles, center) {
    this.radius = radius;
    this.initialAngle = initialAngle;
    this.angles = angles;
    this.center = center;
  }
  init() {
    var angles = [];
    var initialAngle = 0;
    var newAngle = 0;

    while (initialAngle <= TWO_PI) {

      newAngle = random(TWO_PI / 12);

      angles.push(newAngle);

      initialAngle += newAngle;

    }
    this.angles = angles;
    this.initialAngle = random(TWO_PI);
  }
}