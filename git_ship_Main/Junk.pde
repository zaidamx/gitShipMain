class Junk {
  int type;
  PVector position;
  PVector direction;
  float rotation;
  float speed;
  float rotationDirection = 1;
  float rotationIncriment = 0.01;
  
  PVector startingPosition = new PVector(243.75, 205.75);
  
  Junk(){
    position = new PVector(startingPosition.x, startingPosition.y);
    direction = new PVector(random(0.5, 5), -random(0.5, 5));
    speed = random(0.01, 0.2);
  }
  
  void update(){
    //make it drift when gravity is off
    if(!artificialGravity){
      //increase rotation
      rotation += (rotationIncriment * rotationDirection);
      //get new position
      position.x += direction.x * speed;
      position.y += direction.y * speed;
      if (position.y < 0 || position.y > height) {
        rotationDirection *= -1;
        rotationIncriment *= random(0.5, 2);
        direction.y *= -1;
      }
      if (position.x < 0 || position.x > (width)){
        rotationDirection *= -1;
        rotationIncriment *= random(0.5, 2);
        direction.x *= -1;
      }
    }
    //draw it whether it's drifting or not
    //do the nasty matrix stuff
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    drawMug();
    //display();
    popMatrix();
  }
  
  void drawMug(){
    //-.5, -.5 --> .5, .75
    //0.5, -.25 --> 0.75, -0.25 --> 0.75, 0.25 --> 0.5, 0.5
    rect(-12.5, -12.5, 25, 31.25);
    //handle
    strokeWeight(4);
    line(12.5, -6.25, 18.75, -6.25);
    line(18.75, -6.25, 18.75, 6.25);
    line(18.75, 6.25, 12.5, 12.5);
    strokeWeight(2);
    noStroke();
  }
}
