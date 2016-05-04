import processing.serial.*;
int bgcolor;           // Background color
int fgcolor,acolor,bcolor,ccolor,dcolor,ecolor;           // Fill color
Serial myPort;  

// The serial port
int[] serialInArray = new int[6];    
int serialCount = 0;                 // A count of how many bytes we receive
               // Starting position of the ball
boolean firstContact = false;       

void setup() {
  size(900, 900); 
  noStroke();      
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  //background(bgcolor);
  //fill(fgcolor);
  // Draw the shape
  noStroke();
   sensor1();
  sensor2();
  sensor3();
  sensor4();
  sensor5();
  sensor6();
  stroke(#00B9FF);
  noFill();
  strokeWeight(3);
  rect(100,100,300,700);
  rect(500,100,300,700);
}
void sensor1(){
  fill(fgcolor);
  rect(0,0,width/2,300);
}
void sensor2(){
  fill(acolor);
  rect(0,300, width/2,300);
}
void sensor3(){
  fill(bcolor);
  rect(0,600, width/2,300);
}
void sensor4(){
  fill(ccolor);
  rect(width/2,0, width/2,300);
}

void sensor5(){
  fill(dcolor);
  rect(width/2,300, width/2,300);
}
void sensor6(){
  fill(ecolor);
  rect(width/2,600, width/2,300);
}



void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 5 ) {
      fgcolor = serialInArray[0];
      acolor = serialInArray[1];
      bcolor = serialInArray[2];
     ccolor = serialInArray[3];
     dcolor = serialInArray[4];
       ecolor = serialInArray[5];

      // print the values (for debugging purposes only):
      println(fgcolor + "\t" + acolor + "\t" +bcolor + "\t" + ccolor + "\t" + dcolor + "\t" + ecolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
