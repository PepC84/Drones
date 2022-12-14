// h,000,000,000,e ps send format
// j,000,000,000,r arduino send format
#include <LiquidCrystal.h>
LiquidCrystal lcd(7,8,9,10,11,12);

#define switchPin 5
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
String  value1String;
String  value2String;
String  value3String;

int distanceSend = distance;
int value2Send;
int value3Send;
int value4Send;

boolean enableSendString = false;
long stringSendDelay = millis();

void setup() {
lcd.begin(16,2);
lcd.print("baller v1.2");

 pinMode(trigPin, OUTPUT); 
 pinMode(echoPin, INPUT); 

   Serial.begin(9600);
establishContact();
}

void loop() {
  value2Send = 888;
  value3Send = 777;
  value4Send = 998;
  if (distance < 500) {
  distanceSend = distance;
  } else {
   distanceSend = 500;
  }
 if (value3 == 999 && millis() - stringSendDelay > 50 ) {
  enableSendString = true;
  stringSendDelay = millis();
 }
  if (enableSendString == true) {
  sendString(distanceSend,value2Send,value3Send, value4Send);
  }

  if (toggleVals == true) {
    lcd.setCursor(0,1);
  lcd.print(value1String + " " + value2String + " " + value3String);
  lcd.setCursor (0,0);
  }
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    lcd.setCursor(15,0);
 lcd.print('a');
 lcd.setCursor(0,0);
   //   Serial.write('C');
    inString = Serial.readStringUntil('e');
  if(inString != "null" )
    { 
 lcd.setCursor(14,0);
 lcd.print('1');
 lcd.setCursor(0,0);

 if (inString.startsWith("h") )                  //   si string inicia con  "h" es valida y guarda contenido en arreglo sa[]
     {  
      lcd.setCursor(13,0);
      lcd.print('h');
      lcd.setCursor(0,0);
        value1String   =    inString.substring(2,5);
          value1 = value1String.toInt();
        value2String   =    inString.substring(6,9); 
          value2 =  value2String.toInt();
        value3String   =    inString.substring(10,13); 
          value3 =  value3String.toInt();

          
          
/*        Serial.print("v1 ");
         Serial.println(value1);
          Serial.print("v2 ");
           Serial.println(value2);
            Serial.print("v3 ");
             Serial.println(value3);
             */
             toggleVals = true;
                          }
                         
        } else {
        lcd.setCursor(14,0);
        lcd.print('n');
        lcd.setCursor(0,0);
        }
    }


if (pastDistance - distance < -50 || pastDistance - distance > 50 || millis() - timeStampLCD > 300 || clearedLCD == true) {
lcd.setCursor(0,0);

if (distance < 500) {
  lcd.setCursor(0,0);
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
  if (millis() - timeStampContact > 3000)
 {
      Serial.write('A');   // send a capital A
      lcd.setCursor(15,1);
      lcd.print('A');
      lcd.setCursor(0,0);
    timeStampContact = millis();
  }


      
 
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
void sendString(int a, int b, int c, int d) {
  enableSendString = false;
    char buffer[16];
    sprintf(buffer, "j,%03d,%03d,%03d,r" , distanceSend, value2Send, value3Send);
  Serial.print(buffer);
  lcd.setCursor(12,0);
  lcd.print('j');
  lcd.setCursor(0,0);
  enableSendString = false;
}
