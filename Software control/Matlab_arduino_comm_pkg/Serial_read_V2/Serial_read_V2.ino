
//Author: George Li
//%Crete date: 10/19/2016
//Version number: 02 
//File description: To read 32*40 16-bit unsigned int voltage data from matlab
//Note: work with 'Serial_sent' Matlab script 
#include "ctype.h"
#include "avr/pgmspace.h"

#define BaudRate 57600
#define Data_seq 40
#define Chan_num 10

const short sig7 = 12;
const short sig11 = 11;
const short sig4 = 4;

int sig = 0; //signal that data has been received 
int iterator = 0; //iterator for looping

const int Size = Data_seq*Chan_num; //define the array size of the receive array
String data_receive[Size]; //1-d array used to receive voltage data from matlab
//unsigned int volt_data[Data_seq][Chan_num]; //2_d Voltdata matrix (Dac Voltage Data is stored here!)
String temp = "NULL";

boolean isNum(String input);

void setup()
{ 
  pinMode(sig7,OUTPUT);
  pinMode(sig11,OUTPUT);
  pinMode(sig4,OUTPUT);

  Serial.begin(BaudRate); //set up BaudRate used to communicate with matlab
  //Serial.flush();
  //Serial.println("waitting for input");
  //2-d Volt_dat matrix intialization
//  for(int i = 0; i<Data_seq; i++)
//    for(int j = 0; j<Chan_num; j++)
//       volt_data[i][j] = 0;
       
// for(int i = 0; i<Size; i++)
//    data_receive[i] = "NULL";
}

void loop()
{
  if(Serial.available()> 0) 
  {
    digitalWrite(sig4,HIGH);
    temp = Serial.readStringUntil('\n');
    Serial.println(iterator);
    if (temp == "Auto\n") //if arduino receives signal to trigger auto mode 
      {
      sig = 1; //signal the arudino data being received.
      digitalWrite(sig7,HIGH);
      }
    else if (temp == "Finsh\n")
    {
      sig = 2;
      digitalWrite(sig11,HIGH);
      Serial.println("Hello");
    }
    else
    {
      data_receive[iterator] = temp;
      //Serial
      //Serial.println(data_receive[iterator]);
     /* if (isNum(temp.substring(1))) 
        {
          data_receive[iterator] = temp;
          Serial.println(data_receive[iterator]);
        }*/
      iterator ++;      
    }
  }
  /*if (iterator >= 399)
  {
    for (int m = 0; m< Size; m++)
        Serial.println(data_receive[m]);     
  }*/
  //Serial.println(iterator);
}

boolean isNum(String input)
{
  for(byte i=0;i<input.length();i++)
  {
    if(isdigit(input.charAt(i))) return true;
  }
  return false;
} 

