import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
Player player;

int sensorPower = 7;
int sensorPin = 0;

// Value for storing water level
int val = 0;

//https://forum.processing.org/one/topic/how-to-create-countdown-timer.html
String time = "10";
int t;
int interval = 15;
ArrayList<Fish> fish = new ArrayList<Fish>();
int gamePhase = 0;
color shallowWater, deepWater;
int waterHeight = 250;
int Y_AXIS = 1;
float per = 0;
int score = 0;
boolean scoreFlag = true;
final int SX = width + 850;
final int SY = 200;

void setup() {
  size(1000, 1000);
  //frameRate(20);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(sensorPower, Arduino.OUTPUT);
  smooth();
  player = new Player();
  fish = new ArrayList();
  for (int i = 0; i < random(50, 100); i++) {
    fish.add(new Fish());
  }
  shallowWater = color(107, 255, 248);
  deepWater = color(1, 51, 125);
}

void draw() {

  if (gamePhase == 0) {



    background(71, 191, 255);
    textSize(70);
    text("Go Fish", 100, height/2);
    if (mousePressed) {
      gamePhase = 1;
    }
  }

  if (gamePhase == 1) {
    background(71, 191, 255);
    int level = readSensor();
    print("Water level: ");
    println(level);
    setGradient(0, waterHeight, width, height, shallowWater, deepWater, Y_AXIS);
    t = interval-int(millis()/1000);
    time = nf(t, 0);
    fill(0);
    text(time + "s", width/2, 50);
    player.display();
    if(level > 100){
    player.moveDown();
    }
    if(level < 100){
      player.moveUp();
    }
    //println(player.LocY);
    for (int i = fish.size() - 1; i >= 0; i--) {
      Fish fishes = fish.get(i);
      fishes.display();
      fishes.move();
    }
    oxygenLevels();
    for (int i = fish.size() - 1; i >= 0; i--) {
      if (player.LocX + player.playerWidth/2 > fish.get(i).fishLocX - fish.get(i).fishWidth/2 &&
        player.LocY - player.playerHeight/2 < fish.get(i).fishLocY - fish.get(i).fishHeight/2 &&
        player.LocY + player.playerHeight/2 > fish.get(i).fishLocY + fish.get(i).fishHeight/2 &&
        scoreFlag) {
        fish.remove(i);
        scoreFlag = false;
        score++;
        interval++;
      }

      scoreFlag = true;
      textSize(40);
      fill(0);
      text("score: " + score, 20, 50);
    }
    if (t <= 0) {
      rectMode(CENTER);
      background(71, 191, 255);
      text("Time's up!", width/2 - 100, height/2);
      text("Final score: " + score, width/2-100, height/2 + 100);
      text("Click the mouse to return to the main menu", width/2-350, height/2 + 200);
      if (mousePressed) {
        reset();
        gamePhase = 0;
      }
    }
    if (per >= 750) {
      background(71, 191, 255);
      text("You drowned.", width/2, height/2);
      text("Final score: " + score, width/2, height/2 + 100);
      text("Click the mouse to return to the main menu", width/2, height/2 + 200);
      if (mousePressed) {
        reset();
        gamePhase = 0;
      }
    }

    if (fish.size() <= 0) {
      background(71, 191, 255);
      fill(255);
      text("You caught all the fish!", width/2, height/2);
      text("Final score: " + score, width/2, height/2 + 100);
      text("Click the mouse to return to the main menu", width/2, height/2 + 200);
      if (mousePressed) {
        reset();
        gamePhase = 0;
      }
    }
  }
}



//https://processing.org/examples/lineargradient.html
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }
}

//https://helloacm.com/simple-loading-bar-made-in-processing
void oxygenLevels() {

  rectMode(CORNER);
  textSize(50);
  fill(0);
  text("O", width - 45, 190);
  stroke(5);
  noFill();
  rect(width - 50, 200, 40, 750);
  if (player.LocY > waterHeight) {
    per = per + 3;
    noStroke();
    fill(255, 0, 0);
    rect(SX, SY, 40, per);
    //println(per);
  } else {
    noStroke();
    fill(255, 0, 0);
    rect(SX, SY, 40, per);
    per = per - 5;
  }
  if (per < 0) {
    per = 0;
  }
}

void reset() {
  score = 0;
  interval = 10;
  per = 0;
  t = interval-int(millis()/1000);
  for (int i = fish.size(); i < 50; i++) {
    fish.add(new Fish());
  }
  //if(mousePressed){
  //  gamePhase = 0;
  //}
}

//https://lastminuteengineers.com/water-level-sensor-arduino-tutorial/#:~:text=The%20water%20level%20sensor%20is%20extremely%20simple%20to%20use%20and,from%203.3V%20to%205V.
int readSensor() {
  arduino.digitalWrite(sensorPower, Arduino.HIGH);  // Turn the sensor ON
  //delay(10);              // wait 10 milliseconds
  val = arduino.analogRead(sensorPin);    // Read the analog value form sensor
  //arduino.digitalWrite(sensorPower, Arduino.LOW);    // Turn the sensor OFF
  return val;              // send current reading
}
