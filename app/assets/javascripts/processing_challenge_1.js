function setup() {
  var myCanvas = createCanvas(523, 523);
  background('#'+Math.floor(Math.random()*16777215).toString(16));

  var canvas_height = myCanvas.height
  var center = canvas_height/2
  var diameter = canvas_height

  myCanvas.parent('processing_challenge_1');

  while (diameter > 0) {
    fill('#'+Math.floor(Math.random()*16777215).toString(16));
    ellipse(center, center, diameter, diameter);
    diameter -= 100
  }
}
