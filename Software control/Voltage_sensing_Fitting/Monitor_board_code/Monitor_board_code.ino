


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

int loopCount = -2;
double tempA;

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

  //Those formulas are for ancestor board. 
  /*ChanA_I = (ChanA_volt*sq(ChanA_volt)*(0.0025)+sq(ChanA_volt)*(-0.0119)+ChanA_volt*(1.3493)-1.8505)/RA;
  ChanB_I = (ChanB_volt*sq(ChanB_volt)*(0.0014)+sq(ChanB_volt)*(-0.0038)+ChanB_volt*(1.3176)-1.8077)/RB;
  ChanC_I = (ChanC_volt*sq(ChanC_volt)*(0.0026)+sq(ChanC_volt)*(-0.0116)+ChanC_volt*(1.3389)-1.8491)/RC;
  ChanD_I = (ChanD_volt*sq(ChanD_volt)*(-0.0003)+sq(ChanD_volt)*(0.0025)+ChanD_volt*(1.3245)-1.8691)/RD;
  ChanE_I = (ChanE_volt*sq(ChanE_volt)*(-0.006)+sq(ChanE_volt)*(0.0251)+ChanE_volt*(1.2751)-1.7739)/RE;

  String I_A = "A";
  String I_B = "B";
  String I_C = "C";
  String I_D = "D";
  String I_E = "E";

  I_A += String(ChanA_I);
  I_B += String(ChanB_I);
  I_C += String(ChanC_I);
  I_D += String(ChanD_I);
  I_E += String(ChanE_I);*/

  if(abs(ChanA_volt - tempA) > 0.05)
  {
    Serial.print("\n");
    loopCount++;
  }

  Serial.print(loopCount);
  Serial.print(": ");
  Serial.print(" A:");
  Serial.print(ChanA_volt,4); 
  Serial.print(" B:");
  Serial.print(ChanB_volt,4);
  Serial.print(" C:");
  Serial.print(ChanC_volt,4);
  Serial.print(" D:");
  Serial.print(ChanD_volt,4);
  Serial.print(" E:");
  Serial.print(ChanE_volt,4);
  Serial.print(" F:"); 
  Serial.print(ChanF_volt,4);
  Serial.print(" G:");
  Serial.print(ChanG_volt,4);
  Serial.print(" H:");
  Serial.print(ChanH_volt,4);
  Serial.print(" I:");
  Serial.print(ChanI_volt,4);
  Serial.print(" J:");
  Serial.print(ChanJ_volt,4);
  Serial.print("\n");

  tempA = ChanA_volt;
  
  delay(1000);
}
