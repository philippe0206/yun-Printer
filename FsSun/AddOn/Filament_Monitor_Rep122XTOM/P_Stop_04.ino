#include <EEPROM.h>
/*
Filament Monitor designed for Replicator 1/2/2X running sailfish
Version 04 
  Ignores encoders if set button is pressed during runtime
  fixes a type mismatch for saving interval count
  fixed a bug where eeprom is written to on every startup
  faulting moved to separate routine (o.o.p.)
Version 03
  Allows system to be manually faulted at any time
  Stores timeout time as byte(seconds) rather than int(ms)
 */
int encoder0PinA = 18;
int encoder0PinB = 19;
int encoder0PinALast = LOW;//memory variable
int encoder1PinA = 15;
int encoder1PinB = 16;
int encoder1PinALast = LOW;//memory variable

byte PJ2 = 17;//output pin to Replicator
byte jmp = 10;//solder jumper to invert output signal
boolean faultLow = true;//sets output Low on a fault
byte LEDR = 3;//red LED
byte LEDB = 1;//blue LED
byte LEDG = 2;//green LED
byte LEDe0 = 13;//encoder0 LED
byte LEDe1 = 16;//encoder1 LED
byte EXT = 0; //optional external Pause connection
byte SET = 14;//onboard set Button for reprogramming
byte pCount0 = 0; //traveled distance 0 (for arming)
byte pCount1 = 0; //traveled distance 1 (for arming)
byte ArmDist = 6; //number of encoder ticks for arming

boolean ARMED = false;//can't trigger a pstop until it's moved a bit

byte interval = 0;//how many seconds it takes to time out
int count = 501;

void setup()
{
  pinMode (jmp, INPUT);
  digitalWrite(jmp, HIGH);
  pinMode(PJ2, OUTPUT);
  if (digitalRead(jmp) == 0) { //output goes low on fault
    faultLow = true;
    digitalWrite(PJ2, HIGH);//set high to start out, keep high until fault
  }
  else { // output high on fault
    faultLow = false;
    digitalWrite(PJ2, LOW);//set low to start out, keep low until fault
  }

  /* Setup encoder pins as inputs */
  pinMode (encoder0PinA, INPUT);
  pinMode (encoder0PinB, INPUT);
  digitalWrite(encoder0PinA, HIGH);
  digitalWrite(encoder0PinB, HIGH);
  pinMode (encoder1PinA, INPUT);
  pinMode (encoder1PinB, INPUT);
  digitalWrite(encoder1PinA, HIGH);
  digitalWrite(encoder1PinB, HIGH);
  encoder0PinALast = digitalRead(encoder0PinA);//initialize at initial state
  encoder1PinALast = digitalRead(encoder1PinA);//initialize at initial state
  pinMode(EXT, INPUT);
  digitalWrite(EXT, HIGH);
  pinMode(SET, INPUT);
  digitalWrite(SET, HIGH);

  // set up led pins as outputs
  pinMode(LEDR, OUTPUT);
  pinMode(LEDB, OUTPUT);
  pinMode(LEDG, OUTPUT);
  pinMode(LEDe0, OUTPUT);
  pinMode(LEDe1, OUTPUT);

  digitalWrite(LEDe0, LOW);
  digitalWrite(LEDe1, LOW);

  if (EEPROM.read(1) == 1) { //has the memory been set up?
    interval = EEPROM.read(0);//set the interval to whatever is in the eeprom
  }
  else { //no value ever set, set a default value
    interval = 12;
  }
  LColor('W');
  delay(1000);
  if (digitalRead(SET) == 0) {
    interval = 0;
    while (digitalRead(SET) == 0) {
      LColor('C');
      delay(500);
      if (digitalRead(SET) == 0) {
        Blink('Y', 'C', 2);
        interval += 1;
      }
    }
  }
  else {
    LColor('C');
    delay(600);
  }
  if (EEPROM.read(0) != interval) { //if it doesn't match what's in memory
    EEPROM.write(0, interval);//write to memory
    EEPROM.write(1, 1);//we have set the memory to something
  }
  Blink('R', 'C', interval);

}

void loop()
{
  int tmpData0 = readEnc0();//read primary encoder
  int tmpData1 = readEnc1();//read secondary encoder
  boolean mvMt = false;//is there movement? default to no

  if (tmpData0 != 0 || tmpData1 != 0) {//moving
    mvMt = true;
    count = 0;//there was movement, reset the time
    if (tmpData0 != 0) {
      digitalWrite(LEDe0, HIGH);//show movement on encoder LED 0
      if (pCount0 <= ArmDist) {
        pCount0 += 1; //increment pcount0
      }
    }
    if (tmpData1 != 0) {
      digitalWrite(LEDe1, HIGH);//show movement on encoder LED 1
      if (pCount1 <= ArmDist) {
        pCount1 += 1; //increment pcount0
      }
    }
  }

  if ( digitalRead(EXT) == 0) { //fault out if external input is pressed
  FaultOut();
  }
  if (digitalRead(SET) == 0) { //set was presses during loop, ignore encoders
    LColor('G');
    while (true) {}
  }
  if (pCount0 > ArmDist || pCount1 > ArmDist) {
    ARMED = true;
  }
  if (!mvMt && count < 300) { //not moving but still want to display movement so user can see
    LColor('G');
  }
  else if (!mvMt && count > 300 && count < interval * 1000 && !ARMED) { //not moving and not armed
    digitalWrite(LEDe0, LOW);
    digitalWrite(LEDe1, LOW);
    LColor('B');
  }
  else if (!mvMt && count < interval * 1000 && ARMED) { //not moving and armed
    digitalWrite(LEDe0, LOW);
    digitalWrite(LEDe1, LOW);
    LColor('Y');
  }
  else if ((!mvMt && count >= interval * 1000 && ARMED)) { //triggered by motion timeout or external switch, or SET button
FaultOut();
  }

  //do time incrementing
  delay(1);
  if (count < interval * 1000) {
    count += 1;
  }
}

void LColor(char c) {
  //reset them all to high (off)
  digitalWrite(LEDR, HIGH);
  digitalWrite(LEDB, HIGH);
  digitalWrite(LEDG, HIGH);
  //Now set the color
  if (c == 'W') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'R') {
    digitalWrite(LEDR, LOW);
  }
  else if (c == 'G') {
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'B') {
    digitalWrite(LEDB, LOW);
  }
  else if (c == 'Y') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'V') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, LOW);
  }
  else if (c == 'C') {
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, LOW);
  }
}

void FaultOut(){
    LColor('R');
    if (faultLow) {
      digitalWrite(PJ2, LOW);//set output low
    }
    else {
      digitalWrite(PJ2, HIGH);//set output high
    }
    while (true);//infinite loop right here, system locket, must reset to restart
}

int readEnc0() {
  int r = 0;
  byte n = digitalRead(encoder0PinA);
  if ((encoder0PinALast == LOW) && (n == HIGH)) {
    if (digitalRead(encoder0PinB) == LOW) {
      r = -1;
    }
    else {
      r = 1;
    }
  }
  encoder0PinALast = n;
  return r;
}

int readEnc1() {
  int r = 0;
  int n = digitalRead(encoder1PinA);
  if ((encoder1PinALast == LOW) && (n == HIGH)) {
    if (digitalRead(encoder1PinB) == LOW) {
      r = -1;
    }
    else {
      r = 1;
    }
  }
  encoder1PinALast = n;
  return r;
}

void Blink(char col1, char col2, int count) {
  for (int i = 1; i <= count; i++) {
    LColor(col1);
    delay(100);
    LColor(col2);
    delay(200);
  }
}



