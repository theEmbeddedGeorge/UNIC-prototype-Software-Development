

const double RA = 0.25;
const double RB = 0.25;
const double RC = 0.25;
const double RD = 0.25;
const double RE = 0.25;

double ChanA_volt = 0;
double ChanB_volt = 0;
double ChanC_volt = 0;
double ChanD_volt = 0;
double ChanE_volt = 0;

double ChanA_I = 0;
double ChanB_I = 0;
double ChanC_I = 0;
double ChanD_I = 0;
double ChanE_I = 0;

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

  double ratio = 5.0/1024.0;
  
  ChanA_volt = ratio * ChanA_raw; 
  ChanB_volt = ratio * ChanB_raw; 
  ChanC_volt = ratio * ChanC_raw; 
  ChanD_volt = ratio * ChanD_raw; 
  ChanE_volt = ratio * ChanE_raw; 

  //Those formulas are for ancestor board. 
  ChanA_I = (ChanA_volt*sq(ChanA_volt)*(0.0025)+sq(ChanA_volt)*(-0.0119)+ChanA_volt*(1.3493)-1.8505)/RA;
  ChanB_I = (ChanB_volt*sq(ChanB_volt)*(0.0014)+sq(ChanB_volt)*(-0.0038)+ChanB_volt*(1.3176)-1.8077)/RB;
  ChanC_I = (ChanC_volt*sq(ChanC_volt)*(0.0026)+sq(ChanC_volt)*(-0.0116)+ChanC_volt*(1.3389)-1.8491)/RC;
  ChanD_I = (ChanD_volt*sq(ChanD_volt)*(-0.0003)+sq(ChanD_volt)*(0.0025)+ChanD_volt*(1.3245)-1.8691)/RD;
  ChanE_I = (ChanE_volt*sq(ChanE_volt)*(-0.006)+sq(ChanE_volt)*(0.0251)+ChanE_volt*(1.2751)-1.7739)/RE;

  Serial.print(" A_V:");
  Serial.print(ChanA_I*RA); 
  Serial.print("  B_V:");
  Serial.print(ChanB_I*RA);
  Serial.print("  C_V:");
  Serial.print(ChanC_I*RA);
  Serial.print("  D_V:");
  Serial.print(ChanD_I*RA);
  Serial.print("  E_V:");
  Serial.print(ChanE_I*RA);
  
  Serial.println("\n");

  delay(500);
}
