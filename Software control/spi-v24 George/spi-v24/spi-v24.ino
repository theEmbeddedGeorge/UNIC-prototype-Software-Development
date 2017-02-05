/*
 Hui Han Coil testing circuit
 Aug 7,2015 major changes in version 20 to support 12 channels
 Aug 23,2015 adding offsets in version 21
 Sept 10,2015 fixed temperature sensor routine
 Sept.21-22,2015 looking at adding 10 channel array for switching every 30 ms
*/

#include "SPI.h" 		// necessary library
#include <stdio.h>

#define BaudRate 57600
#define Page_num 40
#define MAX_DAC_NUM 5 //5 dac per board

const int Size = Page_num*MAX_DAC_NUM; //define the array size of the receive array
unsigned int data_receive[Size]; //1-d array used to receive voltage data from matlab
unsigned int volt_data[Page_num][MAX_DAC_NUM]; //2_d Voltdata matrix (Dac Voltage Data is stored here!) (32*5)
unsigned int DacValue[MAX_DAC_NUM]; //Dac value for a single page
unsigned int dataVolt; //single value entry

int offset;

// OPAs - 0 to 11 this is the real chip enable pin number
const int MaOutputPins [MAX_DAC_NUM] = {2,3,4,5,6}; //we are only using 5 of them (5 DACS)

/* correction for dacs each count is 5v/32767 or .15259mv
   I set this manual method and put values in table below
   with luck new boar will not need these
*/
const int cordac [MAX_DAC_NUM] = {-124,-9,-222,-122,0};

int k = 0; //iterator for looping

void setup()
{
  for (int i = 0; i < MAX_DAC_NUM; i++)
  {
    pinMode (MaOutputPins[i], OUTPUT);     // set to output mode
    digitalWrite (MaOutputPins[i], HIGH);  // set chip enable off
  }
  for (int i = 0; i < MAX_DAC_NUM; i++)
  {
	  DacValue[i] = 32767; //initialize each Dac to zero
  }
  for(int i = 0; i<Page_num; i++) //initialize the data matrix
    for(int j = 0; j<MAX_DAC_NUM; j++)
       volt_data[i][j] = 0;
   
// setup SPI channel
  Serial.begin(BaudRate);
  SPI.begin();         		            // wake up the SPI bus.
  SPI.setBitOrder(MSBFIRST);  	      // LTC1592 wants data most significant byte first
// SPI.setDataMode(SPI_MODE3);        //  Set for clock rising edge
// SPI.setClockDivider(SPI_CLOCK_DIV64);    //  Set clock divider (optional)
  dacZero();                          // zero all dacs
}

// main loop only watches serial input
void loop() 
{
  if(Serial.available()>=2) //if the buffer received at least two bytes (16-bit int)
  {
     unsigned int dumy = 0; //local variable to hold the received data temperally 
     dumy = Serial.read(); //dumy hold the lower 8-bits of the data bcs Serial.read() only reads in 8 bits a time 
     data_receive[k] = (Serial.read()<<8)|dumy;//matlab send the first 8 bit first and then the last 8 bit
     k++; //increment to the next element in the array
  }
  else 
  {      
    if(k == Size) //if arduino received all the data
    { 
     int row = 0; //iterators for looping through 2-d volt data matrix 
     int col = 0;
     k = 0; //reset k value
     
     for(int i = 0; i < Size; i++) //put the received information into the 2-d volt data matrix
     {
       if (col == MAX_DAC_NUM) //go to the next row
       {
         col = 0;
         row ++;
       }
       volt_data[row][col] = data_receive[i];
       col++; 
     }
	 
     char c;
     c = Serial.read ();
     ProcessCommand (c);
     Serial.flush(); //flush the buffer and wait for new instructions
   }
  }
}

void ProcessCommand (char sBuffer)
{
	switch (sBuffer)            // look at first character in string
	{             
	  case 'z':
		dacZero();                  // zero all dacs
		delay(30);
		break;
	  case 'r': 				   // upload to Dac
		for (int i = 0; i<Page_num; i++)
		{
			for (int j = 0; j<MAX_DAC_NUM; j++)
				DacValue[j] = volt_data[i][j];
					
			ProcessDacCommand();  //set dac value channel 1 to MAX_DAC_NUM  
			delay(30); //delay 30 ms before processing to the next page 
		}
		break;
	  default: //do nothing if sBuffer is not the above two char
		break;
	}
}

void ProcessDacCommand ()
{
  long vlt; 
  long lowvlt;
  for (int i = 0; i < MAX_DAC_NUM; i++)
  {
    vlt = DacValue[i];            // get value from array
    lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word
    offset = (cordac[i]);		// get offset correction
    vlt = vlt + offset;		// add in offset
    lowvlt = vlt - ((vlt / 256) * 256 ); // remove upper 8 bits need to send word    
    lowvlt = lowvlt + offset;		// add in offset
    digitalWrite (MaOutputPins[i], LOW);  // set chip enable on
    SPI.transfer(0xA0);                 // set to 24 bit +/- 5v bipolar range
    SPI.transfer(vlt / 256);            // only upper 8 bits
    SPI.transfer(lowvlt); 
    digitalWrite (MaOutputPins[i], HIGH);  // set chip enable off
  }
}

void dacZero()
{
  for (int i = 0; i < MAX_DAC_NUM; i++)
  {
    offset = (cordac[i]);		        // get offset correction
    digitalWrite (MaOutputPins [i], LOW);       // set chip enable on
    SPI.transfer(0xA0); 			// command set to 24 bit +/- 5v bipolar range
    SPI.transfer(0x7F); 			// set to 0 volts out 7FF8 = 32767
    SPI.transfer(( 0xFF + offset)); 		// set to 0 volts out
    digitalWrite (MaOutputPins [i], HIGH);      // set chip enable off
    DacValue[i] = (32767 + offset);          // write 0 value to array location
   }
}


/**********************************Following code is no longer used*********************************/
// this next routine is just for playing with on off/on and time
void dacZeroTest()
{
  Serial.println("*zero*");
  int i;
// 8us for 2nd chip enable to go low in for routine
  for (i = 0; i < MAX_DAC_NUM; i++)
  {
    offset = (cordac [i]);		        // get offset correction
    digitalWrite (MaOutputPins [i], LOW);       // set chip enable on
    SPI.transfer(0xA0); 			// command set to 24 bit +/- 5v bipolar range
    SPI.transfer(0x7F); 			// set to 0 volts out 7FF8 = 32767
    SPI.transfer(( 0xFF + offset)); 		// set to 0 volts out
    digitalWrite (MaOutputPins [i], HIGH);      // set chip enable off
   }
}

// added Aug 23 to show offset value
void showOffset()
{
  int offset;
  int i;
  Serial.println("offsets for board 2");
  for (i = 0; i < MAX_DAC_NUM; i++)
  {
    offset = (cordac [i]);		        // get offset correction
    Serial.print( i );                          // get dac number
    Serial.print("  value=");
    Serial.println(offset);                     // show me
  }
}

// added Sept 21 to show stored page one values
void showStored()
{
  word storedata;
  int i;
  Serial.println("dac stored info page 1");
  for (i = 0; i < MAX_DAC_NUM; i++)
  {
    storedata = (DacValue [i]);		        // data stored
    Serial.print( i );
    Serial.print("  value=");
    Serial.println(storedata);
  }
}

// read temperature on all sensors set to 4 could be 12   changed Aug 4
// could drop out some of the print statements    just leave temperature
void TempVolt(){
 int reading;                        // reading from a to d 
 float voltage;                       // voltage calculated from a to d
 float temperatureC;                  // temperature in deg C
 float temperatureF;
 for (int x=0; x < MAX_DAC_NUM; x++){
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
   Serial.println(temperatureC); // send temperature data back to PC   
 }
}


