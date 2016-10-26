
//Author: George Li
//%Crete date: 10/25/2015
//Version number: 01 
//File description: To read 32*40 16-bit unsigned int voltage data from matlab
//Note: work with 'Serial_sent' Matlab script 

#define BaudRate 9600
#define Data_seq 40
#define Dac_num 32

int sig = 0; //signal that data has been received 
int pinY = 10; //define pins for lights 
int pinG = 7;
int i = 0; //iterator for looping

const int Size = Data_seq*Dac_num; //define the array size of the receive array
unsigned int data_receive[Size]; //1-d array used to receive voltage data from matlab
unsigned int volt_data[Data_seq][Dac_num]; //2_d Voltdata matrix (Dac Voltage Data is stored here!)

float temperatureF [64] = {20.3,30.5,40,50,60,34,21,56,69,54,67,45,32,43,5,67,22,56,38,23,45,67,30,12,34,65,43,38,67,23,45,17,
20.3,30.5,40,50,60,34,21,56,69,45,67,45,32,43,5,67,42,56,12,23,45,67,50,12,34,65,43,28,67,23,45,52};

String cur_A = "A4.5"; 
float cur = 5.47;

void setup()
{
  Serial.begin(BaudRate); //set up BaudRate used to communicate with matlab
  
  pinMode(pinY,OUTPUT); //setup signal lights (unnecessary)
  pinMode(pinG,OUTPUT);
  
  //2-d Volt_dat matrix intialization
  for(int i = 0; i<Data_seq; i++)
    for(int j = 0; j<Dac_num; j++)
       volt_data[i][j] = 0;
}

void loop()
{
  if(Serial.available()>=2) //if the buffer received at least two bytes (16-bit int)
  {
     unsigned int dumy = 0; //local variable to hold the received data temperally 
     dumy = Serial.read(); //dumy hold the lower 8-bits of the data bcs Serial.read() only reads in 8 bits a time 
     data_receive[i] = (Serial.read()<<8)|dumy;//matlab send the first 8 bit first and then the last 8 bit
     sig = 1; //signal that arduino has received data
     i++; //increment to the next element in the array
  }
  else if(Serial.available())
  {
   /*for(int j = 0; j < 64; j++)
       {
         //send back the received data for debuging/monitoring (not necessary)
         Serial.println(temperatureF[j]);  
       }*/
       Serial.println(cur_A);  
  }
  else 
  {      
    if(sig == 1 && i == Size) //if arduino received all the data
    {
      digitalWrite(pinG,HIGH); //turn on both lights if arduino finish receiving 
      digitalWrite(pinY,HIGH);
      
      int row = 0; //iterators for looping through 2-d volt data matrix 
      int col = 0;
     
     for(int n = 0; n < Size; n++) //put the received information into the 2-d volt data matrix
     {
       if (col == Dac_num) //go to the next row
       {
         col = 0;
         row ++;
       }
       volt_data[row][col] = data_receive[n];
       col++; 
     }
    }
  }
}
     
