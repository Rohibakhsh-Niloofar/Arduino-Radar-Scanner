#include <Servo.h>
Servo myServo;

const int trigPin = 10;   
const int echoPin = 11;   
const int servoPin = 12;  

void setup()
{
  Serial.begin(9600);         
  myServo.attach(servoPin);    
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

long readDistance()
{
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);   
  long distance = duration * 0.034 / 2;     
  return distance;
}

void loop()
{
  for (int angle = 0; angle <= 180; angle += 1)
  {
    myServo.write(angle);       
    delay(75);                 
    long dist = readDistance();

    Serial.print("Angle : "); 
    Serial.print(angle);        
    Serial.print(",");
    Serial.print("Distance : ");     
    Serial.println(dist);
    
  }
  


  for (int angle = 180; angle >= 0; angle -= 1)
  {
    myServo.write(angle);
    delay(75);
    long dist = readDistance();

    Serial.print("Angle : ");
    Serial.print(angle);
    Serial.print(",");
    Serial.print("Distance : ");
    Serial.println(dist);

  }
}
