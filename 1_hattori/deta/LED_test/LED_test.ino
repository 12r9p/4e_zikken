void setup() {
  // put your setup code here, to run once:
  pinMode(LED0, OUTPUT);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(LED0, HIGH);
  delay(100);
  digitalWrite(LED1, HIGH);
  delay(100);
  digitalWrite(LED2, HIGH);
  delay(100);
  digitalWrite(LED3, HIGH);
  delay(100);

  digitalWrite(LED0, LOW);
  delay(100);
  digitalWrite(LED1, LOW);
  delay(100);
  digitalWrite(LED2, LOW);
  delay(100);
  digitalWrite(LED3, LOW);
  delay(1000);
  
}
