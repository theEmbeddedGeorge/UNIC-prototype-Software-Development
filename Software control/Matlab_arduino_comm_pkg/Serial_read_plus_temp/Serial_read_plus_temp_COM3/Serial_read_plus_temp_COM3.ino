
//Author: George Li
//%Crete date: 10/25/2015
//Version number: 01 
//File description: To read 32*40 16-bit unsigned int voltage data from matlab
//Note: work with 'Serial_sent' Matlab script 

#include<stdio.h>
#include<String.h>
#define BaudRate 57600
#define Data_seq 40
#define Dac_num 10

int sig = 0; //signal that data has been received 
int pinY = 13; //define pins for lights 
int i = 0; //iterator for looping
int data_count = 0;
int col = 0;
int row = 0;
int el_count = 0;

const int Size = Data_seq*Dac_num; //define the array size of the receive array
String data_receive[500]; //1-d array used to receive voltage data from matlab
unsigned int volt_data[Data_seq][Dac_num]; //2_d Voltdata matrix (Dac Voltage Data is stored here!)
String Rec_data = "NULL"; 

void setup()
{
  Serial.begin(BaudRate); //set up BaudRate used to communicate with matlab
  pinMode(pinY,OUTPUT); //setup inMode(pinG,OUTPUT);
}

void loop()
{
  if(Serial.available()> 0) //if the buffer received at least two bytes (16-bit int)
  {
     //unsigned int dumy = 0; //local variable to hold the received data temperally 
     //dumy = Serial.read(); //dumy hold the lower 8-bits of the data bcs Serial.read() only reads in 8 bits a time 
     //data_receive[i] = (Serial.read()<<8)|dumy;//matlab send the first 8 bit first and then the last 8 bit
     //sig = 1; //signal that arduino has received data
     //i++; //increment to the next element in the array
     Rec_data = Serial.readStringUntil('\n');
     //if (Rec_data != "end" || "NULL")
     data_receive[data_count] = Rec_data;
     data_count ++; 
  }
//  else if(Serial.available())
//  {
//   for(int j = 0; j < 64; j++)
//       {
//         //send back the received data for debuging/monitoring (not necessary)
//         Serial.println(temperatureF[j]);  
//       } 
//  }
//  else 
//  {      
//    if(sig == 1 && i == Size) //if arduino received all the data
//    {
//      digitalWrite(pinG,HIGH); //turn on both lights if arduino finish receiving 
//      digitalWrite(pinY,HIGH);
//      
//      int row = 0; //iterators for looping through 2-d volt data matrix 
//      int col = 0;
//     
//    
//    }
//  }
    if (Rec_data == "end")
    {
     for(int n = 0; n < data_count; n++) //put the received information into the 2-d volt data matrix
     {
       if (col == Dac_num && row != Data_seq) //go to the next row
       {
         col = 0;
         row ++;
       }
       volt_data[row][col] = data_receive[n].toInt();
       col++; 
     }
     
      for (int i =0; i < Data_seq; i++)
        for (int m =0; m < Dac_num; m++) 
           {
            Serial.println(String(volt_data[i][m]));
            el_count ++; 
           }
//        for (int i =0; i < data_count; i++)

      Serial.println(el_count);
      Rec_data = "NULL";
    }
     //Serial.println(String(data_count));
}
     
