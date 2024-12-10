int relay_1 = 4;
int relay_2 = 7;
int relay_3 = 8;
int relay_0 = 12;
int bit_0 = 2;
int bit_1 = 3;
int sample_tube = 0;
int time_flush = 10000;
int time_sample = 30000;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(relay_1, OUTPUT);
  pinMode(relay_2, OUTPUT);
  pinMode(relay_3, OUTPUT);
  pinMode(relay_0, OUTPUT);
  pinMode(bit_0, OUTPUT);
  pinMode(bit_1, OUTPUT);

  digitalWrite(relay_1, LOW);
  digitalWrite(relay_2, LOW);
  digitalWrite(relay_3, LOW);
  digitalWrite(relay_0, LOW);
  digitalWrite(bit_0, LOW);
  digitalWrite(bit_1, LOW);
}

void loop() {
  switch (sample_tube){
  case 0:
    digitalWrite(relay_1, LOW);
    digitalWrite(relay_2, LOW);
    digitalWrite(relay_3, LOW);
    digitalWrite(relay_0, HIGH);
  break;
  case 1 : 
    digitalWrite(relay_1, HIGH);
    digitalWrite(relay_2, LOW);
    digitalWrite(relay_3, LOW);
    digitalWrite(relay_0, LOW);
  break;
  case 2 : 
    digitalWrite(relay_1, LOW);
    digitalWrite(relay_2, HIGH);
    digitalWrite(relay_3, LOW);
    digitalWrite(relay_0, LOW);
  break;
  case 3 : 
    digitalWrite(relay_1, LOW);
    digitalWrite(relay_2, LOW);
    digitalWrite(relay_3, HIGH);
    digitalWrite(relay_0, LOW);
  break;
  default :
  break;
}

  delay(1000);
  sample_tube = sample_tube + 1;
  if (sample_tube == 4){
  sample_tube = 0;
  }
}