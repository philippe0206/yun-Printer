#include <EEPROM.h>
/*
Filament Problem Detector designed for Replicator2 running sailfish
 
 Add a lead connecting an input to ground for trigger high/trigger low
 */
int encoder0PinA = 18;
int encoder0PinB = 19;
int encoder0PinALast = LOW;
int encoder1PinA = 15;
int encoder1PinB = 16;
int encoder1PinALast = LOW;
boolean justOn = true;//keeps LED from going green during startup

byte PJ2 = 17;//output pin to Replicator
byte LEDR = 3;//red LED
byte LEDB = 1;//blue LED
byte LEDG = 2;//green LED
byte LEDe0 = 13;//encoder0 LED
byte LEDe1 = 16;//encoder1 LED
byte EXT = 0; //optional external Pause button
byte SET = 14;//onboard set Button
byte pCount0 = 0; //traveled distance 0 (for arming)
byte pCount1 = 0; //traveled distance 1 (for arming)
byte ArmDist = 6; //number of encoder ticks for arming

boolean ARMED = false;//can't trigger a pstop until it's moved a bit

int interval = 0;
int count = 501;

void setup()
{
  /* Setup encoder pins as inputs */
  pinMode (encoder0PinA, INPUT);
  pinMode (encoder0PinB, INPUT);
  digitalWrite(encoder0PinA, HIGH);
  digitalWrite(encoder0PinB, HIGH);
  pinMode (encoder1PinA, INPUT);
  pinMode (encoder1PinB, INPUT);
  digitalWrite(encoder1PinA, HIGH);
  digitalWrite(encoder1PinB, HIGH);
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
  pinMode(PJ2, OUTPUT);
  digitalWrite(LEDe0, LOW);
  digitalWrite(LEDe1, LOW);
  digitalWrite(PJ2, HIGH);
  
  if (EEPROM.read(2) == 1){//has the memory been set up?
interval = EEPROMReadInt(0);//set the interval to whatever is in the eeprom 
  }
  else{//no value ever set, set a default value
    interval = 8000;
  }
  LColor('W');
  delay(1000);
  if (digitalRead(SET) == 0){
    interval = 0; 
    while(digitalRead(SET) == 0){
      LColor('C'); 
      delay(500);
      if (digitalRead(SET) == 0){
        Blink('Y','C', 2);
        interval += 1000;
      }
    }
  }
  else{
    LColor('C'); 
    delay(600);
  }
  if (EEPROMReadInt(0) != interval){//if it doesn't match what's in memory
    EEPROMWriteInt(0, interval);//write to memory
    EEPROM.write(2, 1);//we have set the memory to something
  }
  Blink('R','C', interval/1000);

}

void loop()
{
  int tmpData0 = readEnc0();
  int tmpData1 = readEnc1();
  boolean mvMt = false;

  if (tmpData0 != 0 || tmpData1 != 0) {//moving
    mvMt = true;
    count = 0;//there was movement, reset the time
    if (tmpData0 != 0) {
      digitalWrite(LEDe0, HIGH);//show movement on encoder LED 0
      if (pCount0 <= ArmDist){
        pCount0 +=1;//increment pcount0
      }
    }
    if (tmpData1 != 0) {
      digitalWrite(LEDe1, HIGH);//show movement on encoder LED 1
      if (pCount1 <= ArmDist){
        pCount1 +=1;//increment pcount0
      }
    }
  }
  if (pCount0 > ArmDist || pCount1 > ArmDist){
    ARMED = true; 
  }

  if (!mvMt && count < 300 && !justOn) { //not moving but still want to display movement
    //digitalWrite(LEDe0, LOW);
    //digitalWrite(LEDe1, LOW);
    LColor('G');
  }
  else if (!mvMt && count > 300 && count < interval && !ARMED) { //not moving and not armed. happens during startup when printing hasn't started
    digitalWrite(LEDe0, LOW);
    digitalWrite(LEDe1, LOW);
    LColor('B');
    justOn = false;
  }
  else if (!mvMt && count < interval && ARMED) { //not moving and armed
        digitalWrite(LEDe0, LOW);
    digitalWrite(LEDe1, LOW);
    LColor('Y');
  }
  else if ((!mvMt && count >= interval && ARMED) || digitalRead(EXT) == 0) {//triggered by motion timeout or external switch
    ARMED = false;
    LColor('R');
    digitalWrite(PJ2, LOW);   //set output low
    while (true);//infinite loop right here, must reset to restart
  }

  //do time incrementing
  delay(1);
  if (count < interval) {
    count += 1;
  }
}

void LColor(char c) {
  if (c == 'K') {
    digitalWrite(LEDR, HIGH);
    digitalWrite(LEDB, HIGH);
    digitalWrite(LEDG, HIGH);
  }
  else if (c == 'W') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'R') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, HIGH);
    digitalWrite(LEDG, HIGH);
  }
  else if (c == 'G') {
    digitalWrite(LEDR, HIGH);
    digitalWrite(LEDB, HIGH);
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'B') {
    digitalWrite(LEDR, HIGH);
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, HIGH);
  }
  else if (c == 'Y') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, HIGH);
    digitalWrite(LEDG, LOW);
  }
  else if (c == 'V') {
    digitalWrite(LEDR, LOW);
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, HIGH);
  }
  else if (c == 'C') {
    digitalWrite(LEDR, HIGH);
    digitalWrite(LEDB, LOW);
    digitalWrite(LEDG, LOW);
  }
}

int readEnc0() {
  int r = 0;
  int n = digitalRead(encoder0PinA);
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

void Blink(char col1, char col2, int count){
  for (int i = 1; i<= count; i++){
    LColor(col1);
    delay(100);
    LColor(col2);
    delay(200); 
  }
}

//This function will write a 2 byte integer to the eeprom at the specified address and address + 1
void EEPROMWriteInt(int p_address, int p_value)
{
  byte lowByte = ((p_value >> 0) & 0xFF);
  byte highByte = ((p_value >> 8) & 0xFF);
  EEPROM.write(p_address, lowByte);
  EEPROM.write(p_address + 1, highByte);
}

//This function will read a 2 byte integer from the eeprom at the specified address and address + 1
unsigned int EEPROMReadInt(int p_address)
{
  byte lowByte = EEPROM.read(p_address);
  byte highByte = EEPROM.read(p_address + 1);
  return ((lowByte << 0) & 0xFF) + ((highByte << 8) & 0xFF00);
}








