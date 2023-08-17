class Player{

int gravity = 7;
int playerHeight;
int playerWidth;
float LocX;
float LocY;


Player(){
 playerHeight = 100;
 playerWidth = 50;
 LocX = 40;
 LocY = 40;
}

void display(){
  rectMode(CENTER);
  fill(250, 180, 214);
  rect(LocX, LocY, playerWidth, playerHeight);
  if(LocY + playerHeight/2 > height){
    LocY = height - playerHeight/2;
  }
  if(LocY - playerHeight/2 < 150){
    LocY = 150 + playerHeight/2;
  }
}

void moveDown(){
  LocY += gravity;
  
}

void moveUp(){
 LocY -= gravity; 
}
}

  
 
