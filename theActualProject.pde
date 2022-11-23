import processing.serial.*;
Serial port;

 long lastTime = 0;              // timestamp for that moment
 int stepSend = 0;               // number of ongoing case 
 int timeStep = 10;            // first action moment          
 boolean sendStringVar = false;  // function enabled or disabled
 int interval = 10;            // number in milliseconds       // difference per case (1000 = 1 Second)
 long timeStampReceived = 0;
 
float dronePosX = 0;
float dronePosY = 0;
float droneSizeX = 16;
float droneSizeY = 16;
float droneSpeed = 1;
boolean wPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean dPressed = false;
boolean posDroneAngle = false;
boolean negDroneAngle = false;
int directionAngle = 0;
  float droneDegrees = 0;
  float droneRadians = radians(droneDegrees);
  int   droneDegreesInt = int(droneDegrees);

float droneXcoordinates = width/2;
float droneYcoordinates = height/2;
float square = random(width/4, width/2);
float randomHeight = random(height/8,height);
float  randomWidth = random(width/8,width);
float[] randomposx = new float[11];
float[] randomposy = new float[11];
float[] randomy = new float[11];
float[] randomx= new float[11];

float rvalposx = 0;
float rvalposy = 0;
float rValx = 0;
float rValy = 0;
char [] key_lookup = {'L','l', ']', '}'};
boolean[] keys = { false, false,false,false};
boolean drawLinesBoolean;

boolean firstContact = false;
int inByte;
String inString = null;
boolean receivedContact = false;
long timerSend = millis() - 7000;
int value1 = 000;
int value2 = 000;
int value3 = 000;
int sendValue1 = 000;
int sendValue2 = 000;
int sendValue3 = 000;

          
void setup() {
  size(1024,720, P3D);
 randomx[10] = 0; 
 randomy[10] = 0; 
 randomposx[10] = 0; 
 randomposy[10] = 0;
 lastTime = millis();
 timeStampReceived = millis();
 
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[1], 9600);
  port.clear();
  inString = port.readStringUntil('r');
  inString = null;
}
void draw() {

  background(255);
  fill(0,0,255);

   if   (keys[0] == false && keys[1] == false )  
      {

       keys[0] = false;
       keys[1] = false;
       text("Select Mode Off", 10,70);
      }
  if   (keys[2] == true || keys[3] == true)  //debug
       {
       println("rads = " + droneRadians + " degrees ="+ droneDegrees);
       keys[2] = false;
       keys[3] = false;
       }
      if   (keys[0] == true || keys[1] == true)  
        {
        text("Select Mode On", 10,70);
        drawLinesBoolean = true;

       text("Select Mode Off", 10,70);
         }
         
if (drawLinesBoolean == true ) {
  drawLines();
                               } 

if (sendStringVar == true) {
  
  
    sendString(int(droneDegrees),int(456),int(999));
                           }
if (firstContact == true )     
   {
     port.readStringUntil('r');
     text(str(value1), 10,130);
text(str(value2), 10,150);
text(str(value3), 10,170);

        text(" Arduino Contactado ", 10,90);
        text("Received: " + inString, 10, 110);
        
   }
if (firstContact == false) 
    {
      
    text(" Arduino no Contactado ", 10,90);
    }

 droneUpdate(dronePosX, dronePosY , droneRadians );
   text("x: "+mouseX+" y: "+mouseY, 10, 15);
droneAngleCalc();




if (sPressed == true || wPressed == true|| dPressed == true || aPressed == true) {
 if (sPressed == true) {
   dronePosY = dronePosY + droneSpeed;
 }  
  if (wPressed == true) {
   dronePosY = dronePosY - droneSpeed;
 }  
   if (dPressed == true) {
   dronePosX = dronePosX + droneSpeed;
 }  
 if ( aPressed == true ) {
   dronePosX = dronePosX - droneSpeed;
   
   droneXcoordinates = width/2 - dronePosX;
   droneYcoordinates = height/2 - dronePosY;
 }
 
 
}



 if(inString != null) {
 
   if( millis() - timeStampReceived > 50) {
   timeStampReceived = millis();
                                          }
                          
     if(inString.indexOf('j') ==  1) 
     {
       String value1String = inString.substring(3,6);
       value1 = int(value1String);
       String value2String = inString.substring(7,10);
       value2 = int(value2String);
       String value3String = inString.substring(11,14);
       value3 = int(value3String);
       
     }
                        }
                         }
            

 

  void drawLines () {
if (drawLinesBoolean == false) {

 text("Select Mode Off", 10,70);
} else {
  
  
 text("Select Mode On", 10,70);
  }
  }
  
void droneAngleCalc () {
  if (droneDegrees >= 360) {
    droneDegrees = droneDegrees - 360;
  }
  if (droneDegrees < 0) {
   droneDegrees = droneDegrees + 360; 
    
  }
  
// 1 stands for -1 and 2 stands for +1
if (negDroneAngle == true) {
  
  sendStringVar = true;
 droneDegrees = droneDegrees - 1;
 }
 if (posDroneAngle == true) {
   sendStringVar = true;
 droneDegrees = droneDegrees + 1;
 }
 
   droneRadians = radians(droneDegrees);
 
}

void droneUpdate( float posx , float posy, float rad) {
 
  pushMatrix();
  translate(width/2 + posx , height/2 + posy );
  rotateZ(rad);
   color R = color(255,0,0);  
  fill(R);
  noStroke();
rectMode(CENTER);

  rect(0, width, droneSizeX/10 ,width * 2);
 
 smooth();
  noStroke();
  fill(255/3);
  smooth();
  noStroke();
  fill(255/2);
 rectMode(CENTER);
  rect( 0,0  ,droneSizeX,droneSizeY);
  
rectMode(CENTER);
  rect(0, 0 + droneSizeX/4, droneSizeX/2  , droneSizeY * 1.5 );
 
popMatrix();
   text("main x: "+posx + width/2 +" y: "+posy+ height/2, 10, 30);
   text("head x: "+posx + droneSizeX/4 +" y: "+posy , 10, 50);
   
}

void keyPressed () {
  keys (true);
  if (key == 'w')
    {
      wPressed = true;
    }
    else if (key == 's')
    {
       sPressed = true;
    }
    else if (key == 'a')
    {
       aPressed = true;
    }
    else if (key == 'd')
    {
       dPressed = true;
    }
    
  if (keyCode == RIGHT) {
    posDroneAngle = true;
   droneAngleCalc();
  }
   if (keyCode == LEFT) {
   droneAngleCalc(); 
   negDroneAngle = true;
  }

}
  void keyReleased() {
keys(false);
    //spawn more rects
    if (key == 'R' || key == 'r'); {
                                         
    }
    if (key == 'W' || key == 'w')   {

    wPressed = false;
     }
        if (key == 'D' || key == 'd') {

    dPressed = false;
      }
        if (key == 'S' || key == 's')  {

    sPressed = false;
       }
        if (key == 'A' || key == 'a')    {

    aPressed = false;
         } 
    if (keyCode == RIGHT) {
   droneAngleCalc();
posDroneAngle = false;
                          }
     if (keyCode == LEFT)   {
   droneAngleCalc();
negDroneAngle = false;

                             }
}
  
  void keys(boolean pressedMaybe) {
    for ( int i = 0; i < key_lookup.length; i++){
      if( key == key_lookup[i] )    {
        keys[i] = pressedMaybe;
                                    }
                                                }
                                  }
                                  
void sendString( int a, int b , int c) {
  
  String sa = nf(a,3);
  String sb = nf(b,3);
  String sc = nf(c,3);

if (firstContact == true)
{
  
   if ( millis() - lastTime > timeStep )
   {

    stepSend = stepSend + 1;
    timeStep = timeStep + interval;
    
 switch(stepSend) {
    case 1:
  port.write('h');
 break;
    case 2:
  port.write(',');
 break;
    case 3:
  port.write(sa);
 break;
    case 4:
 port.write(',');
 break;
    case 5:
  port.write(sb);
 break;
    case 6:
 port.write(',');
  break;
    case 7:

 port.write(sc);
  break;
    case 8:
  port.write(',');
  break;
  
 case 9:
  sendStringVar = false;
  stepSend = 0;
  timeStep = 10;
  lastTime = millis();
  println("9end"); 
  port.write('e');
  break;
                 }
    }
    
  } else {
    
  }
 }

void serialEvent(Serial port ) {
inString = port.readString();
 
    if (inString.equals("A")) { //65 is A in ASCII
     if (firstContact == false) {
       firstContact = true;
       port.buffer(15);
       port.clear();
    }
 }
}
int countDigits (int n) 
{
  int count = 0;
  while (n != 0) {
  n = n/10;
  ++count;
  }
  return count;
}
