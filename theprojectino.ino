// h,0,00,\n   header,note (1 (A) 2 (B) 3 (C) 4 (D) 5 (E) 6 (F) 7 (G)), octave(1,2,3,4,5,6,7,8,9), intermediate ( 0 (flat), 1 (natural) ,2 (sharp)),\n 

#include <LiquidCrystal.h>
LiquidCrystal lcd(7,8,9,10,11,12);

#define echoPin 2
#define trigPin 3

long duration; 
int distance; 

int value1 = 0;
int value2 = 0;
int value3 = 0;
boolean lcdNaN = false;
long  timeStampReceived = millis();
long timeStampContact = millis();
long timeStampLCD = millis();
long timeStampClearLCD = millis();
boolean timeSinceNaN = false;
String inString; 
int inByte;
int pastCount = 0;
int pastDistance = 0;
int distanceCalc = distance;
boolean clearedLCD = false;
boolean toggleVals = false;
boolean firstContact = false;
void setup() {
lcd.begin(16,2);
lcd.print("baller");

 pinMode(trigPin, OUTPUT); 
 pinMode(echoPin, INPUT); 
 
   Serial.begin(9600);
establishContact();
}

void loop() {
  if (toggleVals == true) {
    lcd.setCursor(0,1);
    char buffer[10];
    sprintf(buffer, "%d %d %d", value1, value2, value3);
  lcd.print(buffer);
  }
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    if (inByte == 'B' || firstContact == false){
      firstContact = true;
      Serial.write('C');
    }
     inString = Serial.readStringUntil('e');          //  // get incoming bytes
  if(inString != "null" )
    {
  if(  millis() - timeStampReceived > 50 ) {
  
//                Serial.print("I received: ");
//               Serial.println(inString);
//                lcd.setCursor(0,0);
//                lcd.print(inString);
                
                timeStampReceived = millis();
  }

 if (inString.startsWith("h") )                  //   si string inicia con  "h" es valida y guarda contenido en arreglo sa[]
     {  
          String  value1String   =    inString.substring(2,5);
          value1 = value1String.toInt();
          String  value2String   =    inString.substring(6,9); 
          value2 =  value2String.toInt();
           String  value3String   =    inString.substring(10,13); 
          value3 =  value3String.toInt();
        Serial.print("v1 ");
         Serial.println(value1);
          Serial.print("v2 ");
           Serial.println(value2);
            Serial.print("v3 ");
             Serial.println(value3);
          toggleVals = true;
                          }
                         
        }
    }


if (pastDistance - distance < -50 || pastDistance - distance > 50 || millis() - timeStampLCD > 300 || clearedLCD == true) {
lcd.setCursor(0,0);

if (distance < 500) {
lcd.print(distance);
} else {
  lcd.setCursor(4,0);
lcd.print("NaN");
lcd.setCursor(0,0);
}

timeStampLCD = millis();
pastDistance = distance;
clearedLCD = false;
}

if (pastCount != countDigits(distance) && pastDistance - distance < 2 && distance < 500 || millis() - timeStampClearLCD > 3000 ) {
lcd.clear();
clearedLCD = true;
 pastCount = countDigits(distance);
timeStampClearLCD = millis();
}

  digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
 
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2; 
}
void establishContact() {
 while (Serial.available() <= 0) {

      Serial.write('A');   // send a capital A

  
 }
}

int countDigits(long n)
{
  int count = 0;
  while (n != 0) {
    n = n/10;
    ++count;
  }
  return count;
}
