//Idea to phase opacity by proximity to target to give the illusion of target aquisition from
//'SpyHunter' Interactive Drawing by Adam Prochazka 991613655
//Fall 2023 GAME12805

class Combat {
  float speed = 3;
  PVector position;
  PVector destination;
  float opacity;
  float timer;
  float shootTime = 5;
  PVector shootPosition;
  PVector hitPosition;
  boolean attacking = false;
  
  color shadow = color(50, 100, 80);
  color grey = color(0, 135, 80);
  color light = color(40, 190, 130);
  color bright = color(255, 225, 0);
  color disruptor = color(0, 255, 0);
  
  float ta;
  float disruptorTimer;
  float nextShot;
  float maxShotTime = 25;
  boolean shoot;
  
  Combat(){
    if(attacking){
      position = new PVector(random(0, width), random(0, height));
      destination = new PVector(random(0, width), random(0, height));
      hitPosition = new PVector(random(0, width), random(0, height));
      nextShot = random(5, maxShotTime);
    }
    else {
      position = new PVector(200, 120);
    }
  }
  
  void update(){
    if(attacking){
      //move position
      PVector direction = new PVector(destination.x - position.x, destination.y - position.y);
      
      if(direction.x < 5 && direction.y < 5){
        destination = new PVector(random(0, width), random(0, height));
        direction = new PVector(destination.x - position.x, destination.y - position.y);
      }
      
      direction.normalize();
      direction.mult(speed);
      position.add(direction);
    }
    
    if(mousePressed){
      timer = frameCount + shootTime;
      shootPosition = new PVector(mouseX, mouseY);
    }
    
    if(attacking){
      ta+=0.1;
      
      disruptorTimer += 1;
      if(disruptorTimer > nextShot){
        shoot = !shoot;
        disruptorTimer = 0;
        nextShot = random(0, maxShotTime);
        if(!shoot) nextShot *= 10;
        hitPosition = new PVector(random(0, width), random(0, height));
      }
    }

  }
  
  void display(){
    //draw ship at position
    fill(shadow);
    
    //right wing
    //0, 0 --> 5.25, 2.75 --> 0, 0.75
    //0, 0.75 --> 5.25, 2.75 --> 5, 3
    //5, 3 --> 5.25, 2.75 --> 5.5, 3.5
    //5.5, 3.5 --> 5, 3 --> 5.25, 3.5
    triangle(position.x, position.y, position.x+131.25, position.y+68.75, position.x, position.y+18.75);
    triangle(position.x, position.y+18.75, position.x+131.25, position.y+68.75, position.x+125, position.y+75);
    triangle(position.x+125, position.y+75, position.x+131.25, position.y+68.75, position.x+137.5, position.y+87.5);
    triangle(position.x+137.5, position.y+87.5, position.x+125, position.y+75, position.x+131.25, position.y+87.5);
    
    //left wing
    //0, 0 --> -5.25, 2.75 --> 0, 0.75
    //0, 0.75 --> -5.25, 2.75 --> -5, 5
    //-5, 3 --> -5.25, 2.75 --> -5.5, 3.5
    //-5.5, 3.5 --> -5, 3 --> -5.25, 3.5
    triangle(position.x, position.y, position.x-131.25, position.y+68.75, position.x, position.y+18.75);
    triangle(position.x, position.y+18.75, position.x-131.25, position.y+68.75, position.x-125, position.y+75);
    triangle(position.x-125, position.y+75, position.x-131.25, position.y+68.75, position.x-137.5, position.y+87.5);
    triangle(position.x-137.5, position.y+87.5, position.x-125, position.y+75, position.x-131.25, position.y+87.5);
    
    //engines
    //1, 0.5 r1
    ellipse(position.x+25, position.y+12.5, 50, 50);
    ellipse(position.x-25, position.y+12.5, 50, 50);
    ellipse(position.x, position.y+25, 75, 50);
    
    //bridge
    fill(grey);
    //rect(position.x-25, position.y+18, 30, 10);
    ellipse(position.x-25, position.y+25, 50, 30);
    fill(light);
    ellipse(position.x-25, position.y+28.5, 12.5, 12.5);
    stroke(light);
    strokeWeight(4);
    line(position.x-37.5, position.y+18.75, position.x-25, position.y+15);
    line(position.x-25, position.y+15, position.x-12.5, position.y+18.75);
    //disruptor blast
    if(shoot){
      fill(disruptor);
      line(position.x-25, position.y+28.5, hitPosition.x, hitPosition.y);
    }
    
    noStroke();
    
    strokeWeight(10);
    stroke(255, 0, 0, (275 - (frameCount * 9 % 270)) - 255 * ((sqrt( (mouseX - position.x)*(mouseX - position.x) + (mouseY - position.y)*(mouseY - position.y) )) / 100));
    noFill();
    rect(position.x - 50, position.y - 20, 100, 75);
    noStroke();
    
    if(timer > frameCount){
      strokeWeight(5);
      stroke(255, 0, 0, 200);
      line(0, height, shootPosition.x, shootPosition.y);
      line(width, height, shootPosition.x, shootPosition.y);
      noStroke();
      
      //draw explosion
    }
    
    //if they shot at us, show shields effect
    if(shoot){
      showStatic();
    }
    
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    ellipse(mouseX, mouseY, 20, 20);
    line(mouseX, mouseY-15, mouseX, mouseY+15);
    line(mouseX-15, mouseY, mouseX+15, mouseY);
    noStroke();
  }
  
    void showStatic(){
    for(int x = 0; x < width; x+=10){
      for(int y = 0; y < height; y+=10){
        float col = map(noise(x, y, ta), 0, 1, 0, 255);
        //now we want to interpolate alpah between 0 and 1
        //where close to hit position == 1, fall off to 0
        float xdist = abs(x-hitPosition.x);
        float ydist = abs(y-hitPosition.y);
        float dist = sqrt(xdist*xdist + ydist*ydist);
        float alpha = map(dist, 0, 0.5 * width, 255, 0);
        fill(0, col, 0, alpha);
        rect(x, y, 10, 10);
      }
    }
  }
}
