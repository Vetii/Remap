PImage img;
PImage remap;
float d = 450;

void setup() {
  size(1280,720);
  selectInput("Select an image to remap...", "fileSelected");

}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or user canceled");
    exit();
  } else {
    // Do stuff.
    img = loadImage(selection.getAbsolutePath());
    remap = createImage(width, height, RGB);
  }
}

void keyPressed() {
  switch(key) {
    case 'p': saveFrame("out####.jpg"); break;
    case '+': d += 50; break;
    case '-': d -= 50; break;
  }
  redraw();
}

float smootherstep(float x, float edge0, float edge1) {
    // Scale, and clamp x to 0..1 range
    x = constrain((x - edge0)/(edge1 - edge0), 0.0, 1.0);
    // Evaluate polynomial
    return x*x*x*(x*(x*6 - 15) + 10);
}

void draw() {
  if(remap == null || img == null) {
    return;
  }
  
  remap.loadPixels();
  img.loadPixels();
  float z1 = random(5.0);
  float z2 = random(5.0);
  for(int i = 0; i < (remap.width * remap.height); ++i) {
    float currX = i % remap.width;
    float currY = floor(i / remap.width);
    float tX = map(smootherstep(noise(currX / d, currY / d, z1), 0, 1), 0, 1, 0, img.width  - 1);
    float tY = map(smootherstep(noise(currX / d, currY / d, z2), 0, 1), 0, 1, 0, img.height - 1);
    int fromX = floor(tX);
    float offsetX = tX - fromX;
    int fromY = floor(tY);
    float offsetY = tY - fromY;
    int toX   = ceil(tX);
    int toY   = ceil(tY);   
    int idFrom = fromY * img.width + fromX;
    int idTo   = toY * img.width + toX;
    remap.pixels[i] = lerpColor(img.pixels[idFrom], img.pixels[idTo], sqrt(offsetX * offsetX + offsetY * offsetY));
  }
  img.updatePixels();
  remap.updatePixels();
  image(remap,0,0);
  noLoop();  
}
