/*
 Hui Han Coil testing circuit
 Aug 9,2015
*/

#include "SPI.h" 		// necessary library
#include <stdio.h>

String cmd;
String val = "";
String sBuffer = "";
String sResp = "?";
char szBuf [256];
int dactype;
int ss1=2;       		// using digital pin 2 for SPI slave select volts channel 1
int ss2=3;       		// using digital pin 3 for SPI slave select volts channel 2
int ss3=4;       		// using digital pin 4 for SPI slave select volts channel 3
int ss4=5;       		// using digital pin 5 for SPI slave select volts channel 4

word dataVolt;		
word dataVlt1;
word dataVlt2;
word dataVlt3;
word dataVlt4;
word dataVlt5;
word dataVlt6;
word dataVlt7;
word dataVlt8;
word dataVlt9;
word dataVlt10;
word dataVlt11;
word dataVlt12;
		
int sensorTempPin1 = 0; 
int sensorTempPin2 = 1; 
int sensorTempPin3 = 2; 
int sensorTempPin4 = 3; 
int OUTPUTPINCOUNT = 4;     // number of dacs or opa channels in use

// OPAs - 0 to 11
const int MaOutputPins [] = 
{
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
};

// could calculate this by #define OUTPUTPINCOUNT (sizeof (MaOutputPins) / sizeof (MaOutputPins [0]))

void setup()
{
//  pinMode(ss1, OUTPUT); 		    // we use this for SS pin SDA-1
//  pinMode(ss2, OUTPUT); 		    // we use this for SS pin SDA-2
//  pinMode(ss3, OUTPUT); 		    // we use this for SS pin SDA-2
//  pinMode(ss4, OUTPUT); 		    // we use this for SS pin SDA-2
// Set pin modes to output and chip enable off Aug 4
  int i;
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    pinMode (MaOutputPins [i], OUTPUT);     // set to output mode
    digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
  }
// setup SPI channel
  SPI.begin();         		            // wake up the SPI bus.
  SPI.setBitOrder(MSBFIRST);  	      // LTC1592 wants data most significant byte first
// SPI.setDataMode(SPI_MODE3);        //  Set for clock rising edge
// SPI.setClockDivider(SPI_CLOCK_DIV64);    //  Set clock divider (optional)
  dacZero();                          // zero all dacs
// setup Serial port at 57,600 baud
  Serial.begin (57600);
  Serial.println(" Output Amp testing Ver. 8-10-2015");
}

// main loop only watches serial input
void loop() 
{
  char c;
  if (Serial.available () > 0)
  {
    while (Serial.available () > 0)
    {
      delay (10);
      c = Serial.read ();
      if (c == '\r')
      {
        ProcessCommand ();
        sBuffer = "";
        continue;
      }
      sBuffer += c;             // make string
    }
  }
}

void ProcessCommand ()
{
  sResp = " ";
  if (sBuffer.length () > 0)
  {
    sBuffer.toUpperCase ();
    Serial.println(sBuffer);
    switch (sBuffer [0])            // look at first character in string
    {             
      case 'Z':
        dacZero();                          // zero all dacs
        delay(30);
        break;
      case 'T':
        TempVolt();        // T for temperatue
        delay(30);
        break;
      case 'A':
        dactype = 1;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'B':
        dactype = 2;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'C':
        dactype = 3;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'D':
        dactype = 4;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'E':
        dactype = 5;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'F':
        dactype = 6;
        ProcessDacCommand (sBuffer.substring (1));
        break;
      case 'G':
        dactype = 7;
        ProcessDacCommand (sBuffer.substring (1));
        break;
       case 'H':
        dactype = 8;
        ProcessDacCommand (sBuffer.substring (1));
        break;
     case '?':
        Serial.println("Help");
        Serial.println("cmd A,B,C,D,E,F,G,H & 5 decimal digits, -5v=0v 0v=32768 +5v=65535");
        Serial.println("cmd T shows temperature of heat sinks");
        Serial.println("cmd Z zeroes all DAC's");
        break;
    }
  Serial.println (sResp);           // Prompts
  Serial.print (">");  
  }
}

void ProcessDacCommand (String PsCommand)
// command takes 16.88us for any one dac chip enable down and backup
{
  long vlt;
  long lowvlt;
  int i;
  dataVolt = PsCommand.toInt ();
  i = dactype - 1;                      //set counter i to real dac chip enable
  Serial.print(" channel=");
  Serial.print(dactype);
  vlt = (dataVolt);                    // make into number
  lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
  Serial.print(" volts=");
  Serial.println(vlt);     
  digitalWrite (MaOutputPins [i], LOW);  // set chip enable on
  SPI.transfer(0xA0);                 // set to 24 bit +/- 5v bipolar range
  SPI.transfer(vlt / 256);            // only upper 8 bits
  SPI.transfer(lowvlt); 
  digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
  dactype = 0;                      // reset dactype
}

// changed Aug 4 to make faster
void dacZero()
{
  Serial.println(" zero dacs");
  int i;
// 8us for 2nd chip enable to go low in for routine
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    digitalWrite (MaOutputPins [i], LOW);  // set chip enable on
  }
  SPI.transfer(0xA0); 			// command set to 24 bit +/- 5v bipolar range
  SPI.transfer(0x7F); 			// set to 0 volts out
  SPI.transfer(0xF8); 			// set to 0 volts out
// first chip enable low for 52us  
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
  }
}

// read temperature on all sensors set to 4 could be 12   changed Aug 4
// could drop out some of the print statements    just leave temperature
void TempVolt(){
 int reading;                        // reading from a to d 
 float voltage;                       // voltage calculated from a to d
 float temperatureC;                  // temperature in deg C
 float temperatureF;
 for (int x=0; x < OUTPUTPINCOUNT; x++){
   reading = analogRead(x);  // get raw number
   Serial.print(" DAC #"); 
   Serial.print((x+1));
   Serial.print(" ");
   Serial.print(reading);   // show raw number
   Serial.print(" cnt, ");
   voltage = reading * 5.0;
   voltage /= 1024.0; 
   Serial.print(voltage);   // show voltage calculated
   Serial.print("v, ");
// -10.9 mv/deg there is a chart for the output LMT86_LookUpTable
// I could not get the reading right using 5 volts
   temperatureC = ((4.6 - voltage) / 10.9) * 100;
   Serial.print(temperatureC);    // show calculated temperature
   Serial.print(" degC, ");
   temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
   Serial.print(temperatureF); 
   Serial.println(" degF");
 }
}

