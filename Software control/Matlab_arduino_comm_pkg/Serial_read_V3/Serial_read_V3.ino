
//Author: George Li
//%Crete date: 10/19/2016
//Version number: 03
//File description: To read 70*40 16-bit unsigned int voltage data from matlab
//Note: work with 'Serial_sent' Matlab script 

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
unsigned int temp_ui = 0;

//String data_receive[Size]; //1-d array used to receive voltage data from matlab
unsigned int volt_data_A[40]; 
//unsigned int* volt_data_A = (unsigned int *)mallc(sizeof(unsigned int));
  
unsigned int volt_data_B[40]; 
unsigned int volt_data_C[40]; 
unsigned int volt_data_D[40]; 
unsigned int volt_data_E[40]; 
unsigned int volt_data_F[40]; 
unsigned int volt_data_G[40]; 
unsigned int volt_data_H[40]; 
unsigned int volt_data_I[40]; 
unsigned int volt_data_J[40]; 
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

  for (int i = 0; i < 40; i ++){
    volt_data_A[i] = 0;
    volt_data_B[i] = 0;
    volt_data_C[i] = 0;
    volt_data_D[i] = 0;
    volt_data_E[i] = 0;
    volt_data_F[i] = 0;
    volt_data_G[i] = 0;
    volt_data_H[i] = 0;
    volt_data_I[i] = 0;
    volt_data_J[i] = 0;
  }
}

void loop()
{
  if(Serial.available()> 0) 
  {
    digitalWrite(sig4,HIGH);
    temp = Serial.readStringUntil('\n');

//    if (count_B == 40)
//      for (int i = 0; i < count_B; i ++)
//        Serial.println(volt_data_B[i]);
    
    if (temp == "Auto") //if arduino receives signal to trigger auto mode 
      {
      sig = 1; //signal the arudino data being received.
      digitalWrite(sig7,HIGH);
      }
    else if (iterator == 400)
    {
      //Serial.println("board2 receive all data!");
      sig = 2;
      digitalWrite(sig11,HIGH);
    }
    else if (temp != "NULL" && temp.length() > 1) 
    {
      if (isNum(temp.substring(1))) 
        {   
          iterator ++;   
          switch (temp.charAt(0)){
            case 'A':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_A[count_A] = temp_ui;
                    count_A ++;
                    break;
            case 'B':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_B[count_B] = temp_ui;
                    count_B ++;
                    break;
            case 'C':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_C[count_C] = temp_ui;
                    count_C ++;
                    break;
            case 'D':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_D[count_D] = temp_ui;
                    count_D ++;
                    break;
            case 'E':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_E[count_E] = temp_ui;
                    count_E ++;
                    break;
            case 'F':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_F[count_F] = temp_ui;
                    count_F ++;
                    break;
            case 'G':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_G[count_G] = temp_ui;
                    count_G ++;
                    break;
            case 'H':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_H[count_H] = temp_ui;
                    count_H ++;
                    break;
            case 'I':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_I[count_I] = temp_ui;
                    count_I ++;
                    break;
            case 'J':
                    temp_ui = temp.substring(1).toInt();
                    volt_data_J[count_J] = temp_ui;
                    count_J ++;
                    break;        
            default:  
                    break;
            }
      }
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

