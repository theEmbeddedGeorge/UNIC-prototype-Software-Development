

//Define Resistance Value for each channel
const double RA = 0.25;
const double RB = 0.25;
const double RC = 0.25;
const double RD = 0.25;
const double RE = 0.25;
const double RF = 0.25;
const double RG = 0.25;
const double RH = 0.25;
const double RI = 0.25;
const double RJ = 0.25;

double ChanA_volt = 0;
double ChanB_volt = 0;
double ChanC_volt = 0;
double ChanD_volt = 0;
double ChanE_volt = 0;
double ChanF_volt = 0;
double ChanG_volt = 0;
double ChanH_volt = 0;
double ChanI_volt = 0;
double ChanJ_volt = 0;

double ChanA_I = 0;
double ChanB_I = 0;
double ChanC_I = 0;
double ChanD_I = 0;
double ChanE_I = 0;
double ChanF_I = 0;
double ChanG_I = 0;
double ChanH_I = 0;
double ChanI_I = 0;
double ChanJ_I = 0;

int refresh_rate = 500; //refresh rate = 250 ms

const double Mon_x1 [10] = 
{
  0.505463234,
-0.002343592,
-0.001636573,
-0.002442007,
-0.002783121,
0.002591548,
-0.000232627,
0.013683707,
0.000575331,
0.009722708,
};

const double Mon_x2 [10] = 
{
 -0.390353406,
1.395745677,
1.380048548,
1.383586529,
1.395411098,
1.383741728,
1.384592328,
1.325224617,
1.373865822,
1.316928856,
};

const double Mon_b [10] = 
{
-0.681713717,
-2.053155081,
-2.033902822,
-2.042591813,
-2.047841267,
-2.043456056,
-2.043964138,
-1.98856373,
-2.026707228,
-1.96432477,

};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  double ChanA_raw = analogRead(A0);
  double ChanB_raw = analogRead(A1);
  double ChanC_raw = analogRead(A2);
  double ChanD_raw = analogRead(A3);
  double ChanE_raw = analogRead(A4);
  
  double ChanF_raw = analogRead(A8);
  double ChanG_raw = analogRead(A9);
  double ChanH_raw = analogRead(A10);
  double ChanI_raw = analogRead(A11);
  double ChanJ_raw = analogRead(A12);

  double ratio = 5.0/1024.0;
  
  ChanA_volt = ratio * ChanA_raw; 
  ChanB_volt = ratio * ChanB_raw; 
  ChanC_volt = ratio * ChanC_raw; 
  ChanD_volt = ratio * ChanD_raw; 
  ChanE_volt = ratio * ChanE_raw; 
  ChanF_volt = ratio * ChanF_raw; 
  ChanG_volt = ratio * ChanG_raw; 
  ChanH_volt = ratio * ChanH_raw; 
  ChanI_volt = ratio * ChanI_raw; 
  ChanJ_volt = ratio * ChanJ_raw; 

  //Those formulas are for Board 3. 
  ChanA_I = (sq(ChanA_volt)*(Mon_x1[0])+ChanA_volt*(Mon_x2[0])+ Mon_b[0])/RA;
  ChanB_I = (sq(ChanB_volt)*(Mon_x1[1])+ChanB_volt*(Mon_x2[1])+ Mon_b[1])/RB;
  ChanC_I = (sq(ChanC_volt)*(Mon_x1[2])+ChanC_volt*(Mon_x2[2])+ Mon_b[2])/RC;
  ChanD_I = (sq(ChanD_volt)*(Mon_x1[3])+ChanD_volt*(Mon_x2[3])+ Mon_b[3])/RD;
  ChanE_I = (sq(ChanE_volt)*(Mon_x1[4])+ChanE_volt*(Mon_x2[4])+ Mon_b[4])/RE;
  ChanF_I = (sq(ChanF_volt)*(Mon_x1[5])+ChanF_volt*(Mon_x2[5])+ Mon_b[5])/RF;
  ChanG_I = (sq(ChanG_volt)*(Mon_x1[6])+ChanG_volt*(Mon_x2[6])+ Mon_b[6])/RG;
  ChanH_I = (sq(ChanH_volt)*(Mon_x1[7])+ChanH_volt*(Mon_x2[7])+ Mon_b[7])/RH;
  ChanI_I = (sq(ChanI_volt)*(Mon_x1[8])+ChanI_volt*(Mon_x2[8])+ Mon_b[8])/RI;
  ChanJ_I = (sq(ChanJ_volt)*(Mon_x1[9])+ChanJ_volt*(Mon_x2[9])+ Mon_b[9])/RJ;


  String I_A = "A";
  String I_B = "B";
  String I_C = "C";
  String I_D = "D";
  String I_E = "E";
  
  String I_F = "F";
  String I_G = "G";
  String I_H = "H";
  String I_I = "I";
  String I_J = "J";

  I_A += String(ChanA_I);
  I_B += String(ChanB_I);
  I_C += String(ChanC_I);
  I_D += String(ChanD_I);
  I_E += String(ChanE_I);
  I_F += String(ChanF_I);
  I_G += String(ChanG_I);
  I_H += String(ChanH_I);
  I_I += String(ChanI_I);
  I_J += String(ChanJ_I);
  
  Serial.println(I_A); 
  Serial.println(I_B);
  Serial.println(I_C);
  Serial.println(I_D);
  Serial.println(I_E);
  Serial.println(I_F); 
  Serial.println(I_G);
  Serial.println(I_H);
  Serial.println(I_I);
  Serial.println(I_J);
  
  delay(refresh_rate);
}
