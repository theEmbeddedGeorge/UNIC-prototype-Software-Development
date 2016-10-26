
//Author: George Li
//%Crete date: 10/19/2016
//Version number: 02 
//File description: To read 70*40 16-bit unsigned int voltage data from matlab
//Note: work with 'Serial_sent' Matlab script 
#include "ctype.h"
#include "avr/pgmspace.h"

#define BaudRate 57600
#define Data_seq 70
#define Chan_num 10

const int sig7 = 7;
const int sig11 = 11;
const int sig4 = 4;

int sig = 0; //signal that data has been received 
int iterator = 0; //iterator for looping

const int Size = Data_seq*Chan_num; //define the array size of the receive array
String temp = "NULL";
unsigned temp_ui = 0;

//String data_receive[Size]; //1-d array used to receive voltage data from matlab
unsigned int *volt_data_A; 
unsigned int *volt_data_B; 
unsigned int *volt_data_C; 
unsigned int *volt_data_D; 
unsigned int *volt_data_E; 
unsigned int *volt_data_F; 
unsigned int *volt_data_G; 
unsigned int *volt_data_H; 
unsigned int *volt_data_I; 
unsigned int *volt_data_J; 
int count_A=0;
int count_B=0;
int count_C=0;
int count_D=0;
int count_E=0;
int count_F=0;
int count_G=0;
int count_H=0;
int count_I=0;
int count_J=0;

boolean isNum(String input);

void setup()
{ 
  pinMode(sig7,OUTPUT);
  pinMode(sig11,OUTPUT);
  pinMode(sig4,OUTPUT);
  
  Serial.begin(BaudRate); //set up BaudRate used to communicate with matlab
  Serial.flush();
}

void loop()
{
  if(Serial.available()> 0) 
  {
    digitalWrite(sig4,HIGH);
    temp = Serial.readStringUntil('\n');
    
    if (temp == "Auto") //if arduino receives signal to trigger auto mode 
      {
      sig = 1; //signal the arudino data being received.
      digitalWrite(sig7,HIGH);
      }
    else if (temp == "end")
    {
      sig = 2;
      digitalWrite(sig11,HIGH);
    }
    else
    {
      if (isNum(temp.substring(1))) 
        {   
              //Serial.println(temp.charAt(0));
            switch (temp.charAt(0)){
            case 'A':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_A[count_A] = temp_ui;
                    count_A ++;
                    //Serial.println(temp_ui);
                    //volt_data_A ++;
                    break;
//            case 'B':
//                    *volt_data_B = temp.substring(1).toInt();
//                    volt_data_B ++;
//                    break;
//            case 'C':
//                    *volt_data_C = temp.substring(1).toInt();
//                    volt_data_C ++;
//                    break;
//            case 'D':
//                    *volt_data_D = temp.substring(1).toInt();
//                    volt_data_D ++;
//                    break;
//            case 'E':
//                    *volt_data_E = temp.substring(1).toInt();
//                    volt_data_E ++;
//                    break;
//            case 'F':
//                    *volt_data_F = temp.substring(1).toInt();
//                    volt_data_F ++;
//                    break;
//            case 'G':
//                    *volt_data_G = temp.substring(1).toInt();
//                    volt_data_G ++;
//                    break;
//            case 'H':
//                    *volt_data_H = temp.substring(1).toInt();
//                    volt_data_H ++;
//                    break;
//            case 'I':
//                    *volt_data_I = temp.substring(1).toInt();
//                    volt_data_I ++;
//                    break;
//            case 'J':
//                    *volt_data_J = temp.substring(1).toInt();
//                    volt_data_J ++;
//                    break;        
            default:  
                    break;
            }
            //Serial.println(volt_data_A[count_A]);
      }
      iterator ++;      
   }
  }

}

boolean isNum(String input)
{
  for(byte i=0;i<input.length();i++)
  {
    if(isdigit(input.charAt(i))) return true;
  }
  return false;
} 

