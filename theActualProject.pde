
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
boolean drawLinesBoolean;

boolean firstContact = false;
int inByte;
String inString = null;
boolean receivedContact = false;
long timerSend = millis() - 7000;
int value1 = 500;
int value2 = 000;
int value3 = 000;
int value4 = 000;
int sendValue1 = 000;
int sendValue2 = 000;
int sendValue3 = 000;
float droneActualXCoordinates;
float droneActualYCoordinates;
int value1Display;
int[][] pixelStates;
int state;
boolean firstL = false;
int desiredCOM = 1; // arduino's COM
float droneHeight = 70;
boolean posDroneHeight = false;
boolean negDroneHeight = false;
boolean droneMoving = false;
 color r = color(255,0,0);  
 long lastMoved = millis();
 float droneBufferX = dronePosX;
 float droneBufferY = dronePosY;
 float droneDifferenceX;
 float droneDifferenceY;
 float[] sinState;
 float[] cosState;
 long droneDegreesLong = int(droneDegrees);
 int graphUpdater;
 float droneBufferTotal;
void setup() {

  pixelStates = new int[width][height];
  size(1024,720, P3D);
 randomx[10] = 0; 
 randomy[10] = 0; 
 randomposx[10] = 0; 
 randomposy[10] = 0;
 lastTime = millis();
 timeStampReceived = millis();
 
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[desiredCOM], 9600);
  port.clear();
  inString = port.readStringUntil('r');
  inString = null;
}
void draw() {
  stroke(0);
line(dronePosX,dronePosY,droneBufferX,droneBufferY);
background(255,255,255);
 // fill(0,0,255);
droneActualXCoordinates = width/2 + dronePosX;
droneActualYCoordinates = height/2 + dronePosY;
    droneXcoordinates = width/2 - dronePosX;
   droneYcoordinates = height/2 - dronePosY;
 sendStringVar = true;
fill(r);
rect(25,width/2 -droneHeight/2,25,droneHeight);
 pushMatrix();
 translate(width/2 + dronePosX , height/2 + dronePosY);
  rotateZ(droneRadians);
  fill(r);
  noStroke();
rectMode(CENTER);

  rect(0, value1Display/2 , droneSizeX/10 ,value1Display);
 
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
  
   text("main x: "+dronePosX + width/2 +" y: "+dronePosY+ height/2, 10, 30);
   text("head x: "+dronePosX + droneSizeX/4 +" y: "+dronePosY , 10, 50);
   text("Height: "+droneHeight , 10 , height/4 + height/2); 
   pixelDraw(droneActualXCoordinates,droneActualYCoordinates,value1Display);

  if (droneDegrees >= 360) {
    droneDegrees = droneDegrees - 360;
  }
  if (droneDegrees < 0) {
   droneDegrees = droneDegrees + 360; 
  }

if (droneHeight <= 10 || droneHeight > 500) { //when close to ground sensors detect being  around 2^11
   text("Height near ground" , 10 , 240) ;
  } 
  if (droneHeight >= 250) {
   text("Height near roof" , 10 , 240); 
  }

if (negDroneHeight == true) {
  sendStringVar = true;
    if (droneHeight > 10 && droneHeight < 500) { //when close to ground sensors detect being  around 2^11
    droneHeight = droneHeight - 1;
  } 
 }
 if (posDroneHeight == true) {
   sendStringVar = true;
     if (droneHeight < 250) {
      droneHeight = droneHeight + 1;
      }
 } 
 
 
if (negDroneAngle == true) {
   sendStringVar = true;
   droneDegrees = droneDegrees - 1;
   droneDegreesLong--; 
 }
 
 if (posDroneAngle == true) {
   sendStringVar = true;
   droneDegrees = droneDegrees + 1;
   droneDegreesLong++;

 }
 
   droneRadians = radians(droneDegrees);
  drawLines();
                               

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


   text("x: "+mouseX+" y: "+mouseY, 10, 15);




if (sPressed == true || wPressed == true|| dPressed == true || aPressed == true) {
   
  if ( sPressed == true && dronePosY < height/2) {
   dronePosY = dronePosY + droneSpeed;
   }  
  if ( wPressed == true && dronePosY > -height/2) {
   dronePosY = dronePosY - droneSpeed;
   
   }  
  if ( dPressed == true && dronePosX < width/2) {
   dronePosX = dronePosX + droneSpeed;
   
   }  
  if ( aPressed == true && dronePosX > -width/2) {
   dronePosX = dronePosX - droneSpeed;
   }
 }  

if ( millis() - lastMoved > 500 ) {
 droneBufferY = dronePosY;
 droneBufferX = dronePosX;
 lastMoved = millis();
 float droneBufferSq;
 droneBufferSq = sq(droneDifferenceX) + sq(droneDifferenceY);
 droneBufferTotal = sqrt(droneBufferSq);
 

} 


  droneDifferenceX = abs(dronePosX - droneBufferX);
  droneDifferenceY = abs(dronePosY - droneBufferY);
  text("DifferenceX" + droneDifferenceX,10,560);
  text("DifferenceY" + droneDifferenceY,10,580);
  text("Total Diff" + droneBufferTotal,10,600);
  



 if(inString != null) {
 
   if( millis() - timeStampReceived > 50) {
   timeStampReceived = millis();
                                          }
                          
     if(inString.indexOf('j') >=  0 && inString != null) 
     {
       int jpos = inString.indexOf('j');
       println(inString);
       String value1String = inString.substring(jpos +2,jpos+5);
       value1 = int(value1String);
       String value2String = inString.substring(jpos + 6,jpos + 9);
       value2 = int(value2String);
       String value3String = inString.substring(jpos + 10,jpos + 13);
       value3 = int(value3String);;
       value1Display = value1;
       println(inString.indexOf('j'));
       println(value1String);
         if (value1 == 500) {
           value1Display = width*2 + int(abs(dronePosX));
           }
     }
     
 }

}

void pixelDraw(float posx, float posy, int hypotenuse ) {
  float cos = cos(radians(droneDegrees + 90)) * hypotenuse;
  float sin = sin(radians(droneDegrees + 90)) * hypotenuse;
  float pixelX = posx + cos;
  float pixelY = posy  + sin;

  text("pixelX = " + pixelX + "pixelY =" + pixelY , 40 , 200);
  set(int(pixelX), int(pixelY), color(0,0,0));
  text("ab", int(pixelX), int(pixelY));
  text(droneDegrees,40,220);
  
  if (pixelX < width && pixelY < height && pixelX > 0 && pixelY > 0 && int(value1) < 500) {
  pixelStates[int(pixelX)][int(pixelY)] = 1;
  }
  for(int x=0; x<width; x++) {
   for (int y=0; y<height; y++) {
      if (pixelStates[x][y] >= 1 && pixelStates[x][y] < 255) {
       
       set(x,y,color(pixelStates[x][y]));
       if(droneBufferTotal > 10) {
      pixelStates[x][y] = pixelStates[x][y] + int(log((droneBufferTotal)));
      }
      }
     if (pixelStates[x][y] == -1) {
        set(x,y,0);
          if (drawLinesBoolean == false) {
            pixelStates[x][y] = pixelStates[x][y] + 2;
          }
       }
    //   if (pixelStates[x][y] != -255 && pixelStates[x][y] < -1) {
    //   set(x,y,color(pixelStates[x][y] + 256));
    //   pixelStates[x][y]++;
    //   }
     }
  }
}
  void drawLines () {
if (drawLinesBoolean == false) {

 text("Select Mode Off", 10,70);
} else {
  
  
 text("Select Mode On", 10,70);
 pixelStates[mouseX][mouseY] = -1;
  }
  }
  
 




void keyPressed () {
if (key == 'l' || key == 'L') {
  drawLinesBoolean = true;
}
  if (key == 'w' || key == 'W')
    {
      wPressed = true;
    }
    else if (key == 's' || key == 'S')
    {
       sPressed = true;
    }
    else if (key == 'a' || key == 'A')
    {
       aPressed = true;
    }
    else if (key == 'd' || key == 'D')
    {
       dPressed = true;
    }
    
  if (keyCode == RIGHT) {
    posDroneAngle = true;

  }
  if (keyCode == UP) {
   posDroneHeight = true; 
  }
   if (keyCode == LEFT) {

   negDroneAngle = true;
  }
  if (keyCode == DOWN) {
   negDroneHeight = true; 
  }
}
  void keyReleased() {
if (key == 'l' || key == 'L') {
  drawLinesBoolean = true;
  
  if (firstL == true) {
    drawLinesBoolean = false;
    firstL = false;
 } else {
   firstL = true;
 }

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
 
posDroneAngle = false;
                          }
     if (keyCode == LEFT) {

negDroneAngle = false;
                          }

    if (keyCode == UP) {
 
posDroneHeight = false;
                          }
     if (keyCode == DOWN)   {

negDroneHeight = false;

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
  port.write('e');
  break;
                 }
    }
    
  } else {
   print("no"); 
  }
    
  
 }

void serialEvent(Serial port ) {
inString = port.readString();
if (inString != null) {
    if (inString.equals("A")) { 
     if (firstContact == false) {
       firstContact = true;
       port.buffer(15);
       port.clear();
    }
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
