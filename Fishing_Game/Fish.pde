class Fish{
  
float fishWidth;
float fishHeight;
float fishSpeed;
float fishLocX;
float fishLocY;

Fish(){
  fishWidth = random(30, 100);
  fishHeight = random(10, 50);
  fishSpeed = random(1, 10);
  fishLocX = width+100;
  fishLocY = random(270, height);
}


void display(){
  rectMode(CENTER);
  noStroke();
  fill(0,255,0);
  rect(fishLocX, fishLocY, fishWidth, fishHeight);
  if(fishLocX - fishWidth/2 < 0){
    fishLocX = width+100;
  }
  
}

void move(){
  fishLocX = fishLocX - fishSpeed;
  
}
  
  
  
  
  
  
}
