 /*
 Hui Han Coil testing circuit
 Aug 7,2015 major changes in version 20 to support 12 channels
 Aug 23,2015 adding offsets in version 21
 Sept 10,2015 fixed temperature sensor routine
 Sept.21-22,2015 looking at adding 10 channel array for switching every 30 ms
 Feb.7,2016 changing for new board
 Feb.17,2016 adding auto routine for testing
*/

#include "SPI.h" 		// necessary library
#include <stdio.h>
 
String cmd;
String val = "";
String sBuffer = "";
String sResp = "?";
int dactype;
word dataVolt;	
int offset;

int sensorTempPin1 = 0; 	// these should go to 12 temperature sensors
int sensorTempPin2 = 1; 
int sensorTempPin3 = 2; 
int sensorTempPin4 = 3; 
int sensorTempPin5 = 4; 

// could calculate this by #define OUTPUTPINCOUNT (sizeof (MaOutputPins) / sizeof (MaOutputPins [0]))
int OUTPUTPINCOUNT = 5;     // number of dacs or opa channels in use max will be 10 for new pc board

// OPAs - 0 to 11 this is the real chip enable pin number
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
};

/* correction for dacs each count is 5v/32767 or .15259mv
   I set this manual method and put values in table below
   with luck new boar will not need these
*/
const int cordac [] = 
{
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
};

/* this is the value stored for each DAC and is moved to the DAC with X excute command
   starting at a value of 0 for all the dacs this is page 1 of how many pages Hui wants
*/
word DacValue1[] = 
{
  32767,        //channel 1
  32767,
  32767,
  32767,
  32767,
  32767,
  32767,
  32767,
  32767,
  32767,      //channel 10
};

void setup()
{
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
  delay( 300 );
  HuiHelp();
}

// main loop only watches serial input
void loop() 
{
  while (Serial.available () > 0)
  {
    delay (10);
    sBuffer = Serial.readStringUntil('\n');
    ProcessCommand ();
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
        dacZero();                  // zero all dacs
        delay(30);
        break;
      case 'T':
        TempVolt();                // T for temperature
        delay(30);
        break;
      case 'A':
        dactype = 1;		// setup dac
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 1
        break;
      case 'B':
        dactype = 2;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 2
        break;
      case 'C':
        dactype = 3;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 3
        break;
      case 'D':
        dactype = 4;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 4
        break;
      case 'E':
        dactype = 5;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 5
        break;
      case 'F':
        dactype = 6;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 6
        break;
      case 'G':
        dactype = 7;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 7
        break;
      case 'H':
        dactype = 8;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 8
        break;
      case 'I':
        dactype = 9;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 8
        break;
      case 'J':
        dactype = 10;
        SaveDacCommand (sBuffer.substring (1));  //set dac value channel 8
        break;
      case 'O':
        showOffset();
        break;
      case 'S':
        showStored();
        break;
      case 'X':
        ProcessDacCommand (sBuffer.substring (1));    // move data to dac turn on current
        break;
      case 'Q':        // I added this just to test on/off of dac every 30ms
        TestDacCommand (sBuffer.substring (1));    // set dacs to a value
        break;
      case '?':                                // show Hui Han help
        HuiHelp();
        break;
    }
  }
}

// changed this to read array and move number to all dacs  Sept.22,2015
void ProcessDacCommand (String PsCommand)
// command takes 16.88us for any one dac chip enable down and backup
{
  long vlt;
  long lowvlt;
  int i;
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    dataVolt = DacValue1[(i)];            // get value from array
    vlt = (dataVolt);                    // make into number
    lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
    offset = (cordac [i]);		// get offset correction
    vlt = vlt + offset;		// add in offset
    lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
    lowvlt = lowvlt + offset;		// add in offset
    digitalWrite (MaOutputPins [i], LOW);  // set chip enable on
    SPI.transfer(0xA0);                 // set to 24 bit +/- 5v bipolar range
    SPI.transfer(vlt / 256);            // only upper 8 bits
    SPI.transfer(lowvlt); 
    digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
    dactype = 0;                      // reset dactype
  }
}

// writes value input to page one or array, does not send data to dac
void SaveDacCommand (String PsCommand)
{
  long vlt;
  long lowvlt;
  int i;
  dataVolt = PsCommand.toInt ();
  i = dactype - 1;                      //set counter i to real dac chip enable
// dactype is array number for storage in array and datavolt is the 16 bit value to save
  DacValue1[(dactype - 1)] = (dataVolt);
  vlt = (dataVolt);                    // make into number
  lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
  offset = (cordac [i]);		// get offset correction
  vlt = vlt + offset;		// add in offset
  lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
//  lowvlt = lowvlt + offset;		// add in offset
//  digitalWrite (MaOutputPins [i], LOW);  // set chip enable on
//  SPI.transfer(0xA0);                 // set to 24 bit +/- 5v bipolar range
//  SPI.transfer(vlt / 256);            // only upper 8 bits
//  SPI.transfer(lowvlt); 
//  digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
  dactype = 0;                      // reset dactype
}

// test all channels  add 10 hex to high value start at 7F which = 0
void TestDacCommand (String PsCommand)
{
  long vlt;		//this is 0
  int i;			// storage for dac channel
  int s;			// storage for times to run addition or changes to current
  int r;
  int reading;                        // reading from a to d 
  float voltage;                       // voltage calculated from a to d
  float temperatureC;                  // temperature in deg C

  offset = 0x10;		// current value that is changed on each pass
  vlt = 0x6F;    //this will be 0
  for (r = 0; r < 2; r++)
  { 
   for (s = 0; s < 7; s++)
   {
    vlt = vlt + offset;		         // add in offset which will keep changing the current
    for (i = 0; i < OUTPUTPINCOUNT; i++)
    {
      digitalWrite (MaOutputPins [i], LOW);  // set chip enable on
      SPI.transfer(0xA0);                    // set to 24 bit +/- 5v bipolar range
      SPI.transfer(vlt);                     // only upper 8 bits
      SPI.transfer(0xFF);                    // always leave lower 8 bits the same
      digitalWrite (MaOutputPins [i], HIGH); // set chip enable off
      delay( 100 );                           // time ms
      reading = analogRead(i);        // get raw number
      voltage = 0.00488 * reading;        // 5 / 1024 = .00488
      temperatureC = ( ( (voltage - 2.103) / -0.01098));                // showes 23.53 deg   
    }
    for (i =0; i < 5; i++)               // this sets how long the channel is on for
    {
      delay( 1000 );                           // time ms or 1 sec
    }
  }
  offset = -(0x10);    // make current negative
  vlt = 0x8F;    //this will be 0
  }
}

// changed Aug 23 to add offset value
// changed Sept.21 to store 0 in page one of array
void dacZero()
{
  ////Serial.println(" zero dacs with offset and save to array memory");
  int i;
// 8us for 2nd chip enable to go low in for routine
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    offset = (cordac [i]);		              // get offset correction
    digitalWrite (MaOutputPins [i], LOW);   // set chip enable on
    SPI.transfer(0xA0); 			              // command set to 24 bit +/- 5v bipolar range
    SPI.transfer(0x7F); 			              // set to 0 volts out 7FFF = 32767
    SPI.transfer(( 0xFF + offset)); 		    // set to 0 volts out
    digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
    DacValue1[(i)] = (32767 + offset);      // write 0 value to array location
   }
}

// this next routine is just for playing with on off/on and time
void dacZeroTest()
{
  int i;
// 8us for 2nd chip enable to go low in for routine
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    offset = (cordac [i]);		              // get offset correction
    digitalWrite (MaOutputPins [i], LOW);   // set chip enable on
    SPI.transfer(0xA0); 			              // command set to 24 bit +/- 5v bipolar range
    SPI.transfer(0x7F); 			              // set to 0 volts out 7FFF = 32767
    SPI.transfer(( 0xFF + offset)); 		    // set to 0 volts out
    digitalWrite (MaOutputPins [i], HIGH);  // set chip enable off
   }
}

// added Aug 23 to show offset value
void showOffset()
{
  int offset;
  int i;
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    offset = (cordac [i]);		        // get offset correction
  }
}

// added Sept 21 to show stored page one values
void showStored()
{
  word storedata;
  int i;
  for (i = 0; i < OUTPUTPINCOUNT; i++)
  {
    storedata = (DacValue1 [i]);		        // data stored
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
   reading = analogRead(x);        // get raw number
//   voltage = reading * 5.0;
//   voltage /= 1024.0; 
   voltage = 0.00488 * reading;        // 5 / 1024 = .00488
// -10.9 mv/deg there is a chart for the output LMT86_LookUpTable
// so figuring temperature range was from 10c=1.993v to 100c=.997v
// output voltage from 2.616v at -50c to 0.42v at 150c or .01098 volts per degree C
// when running equation I get next line for 10 deg C to 100 deg C
// temperatureC = ( ( (voltage - 1.993) / -0.0110666) + 10);      // showes 23.85 deg
// doc shows the next line for 20 to 50 deg C  this seems to be ver close
   temperatureC = ( ( (voltage - 2.103) / -0.01098));                // showes 23.53 deg
   temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
 }
}

// added Sept 21 help
void HuiHelp()
{
 ////Serial.println();
 ////Serial.println("Help for Output Amp testing Ver. 2-17-2016");
 ////Serial.println("cmd A,B,C,D,E,F,G,H & 5 decimal digits saves data to arrray, -5v=0v 0v=32768 +5v=65535");
 ////Serial.println("cmd T shows temperature of heat sinks");
 ////Serial.println("cmd Z zeroes all DAC's");
 ////Serial.println("cmd X execute move array data to dacs");
 ////Serial.println("cmd O show hard coded offsets (offset data input when testing)");
 ////Serial.println("cmd S shows dac values");
 ////Serial.println("cmd Q test all channels high and low leave on for 30 sec");
}

