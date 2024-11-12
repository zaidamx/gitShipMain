class Holodeck {
  
  color col;
  float gridSpacing = 30;
  float t;
  float alpha;
  
  Holodeck(color c){
    col = c;
  }
  
  void update(){
    t+=0.1;
  }
  
  void display(){
    strokeWeight(1);
    noFill();
    //draws the grid bigger than the visible screen because drift makes the rest of it visible
    for(int x = -width; x < width; x+=gridSpacing){
      for(int y = -height; y < height; y+=gridSpacing){
        alpha = map(GetNoise(x, y), 0, 1, 0, 85);
        stroke(red(col), green(col), blue(col), alpha);
        triangle(x, y, x+gridSpacing, y, x+gridSpacing, y+gridSpacing);
        alpha = map(GetNoise(x, y), 0, 1, 0, 120);
        stroke(red(col), green(col), blue(col), alpha);
        triangle(x, y, x+gridSpacing, y+gridSpacing, x, y+gridSpacing);
      }
    }
    noStroke();
  }
  
  float GetNoise(float x, float y){
    return noise(x, y, t);
  }
}
