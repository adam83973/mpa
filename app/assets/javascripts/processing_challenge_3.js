function setup() {
  var myCanvas3 = createCanvas(523, 523);
  myCanvas3.parent('processing_challenge_3');
}

function draw() {
  if (mouseIsPressed) {
    fill(0);
    ellipse(mouseX, mouseY, 10, 10);
  }
}
