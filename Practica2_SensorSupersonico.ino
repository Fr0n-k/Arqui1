#define LED1 22
#define LED2 23
#define LED3 24
#define LED4 25
#define LED5 26

#define Boton 7
const int EchoPin = 5;
const int TriggerPin = 6;

void setup() {
   Serial.begin(9600);
   pinMode(TriggerPin, OUTPUT);
   pinMode(EchoPin, INPUT);

   pinMode(Boton,INPUT); 
   pinMode(LED1,OUTPUT);
   pinMode(LED2,OUTPUT);
   pinMode(LED3,OUTPUT);
   pinMode(LED4,OUTPUT);
   pinMode(LED5,OUTPUT);
}
 
void loop() {
   int cm = ping(TriggerPin, EchoPin);
   Serial.print("Distancia: ");
   Serial.println(cm);
   delay(1000);
}

int ping(int TriggerPin, int EchoPin) {
   long duration, distanceCm;
   
   digitalWrite(TriggerPin, LOW);  //para generar un pulso limpio ponemos a LOW 4us
   delayMicroseconds(4);
   digitalWrite(TriggerPin, HIGH);  //generamos Trigger (disparo) de 10us
   delayMicroseconds(10);
   digitalWrite(TriggerPin, LOW);
   
   duration = pulseIn(EchoPin, HIGH);  //medimos el tiempo entre pulsos, en microsegundos
   
   distanceCm = duration * 10 / 292/ 2;   //convertimos a distancia, en cm

   if(distanceCm == 2){
      digitalWrite(LED1,HIGH);
      digitalWrite(LED2,LOW);
      digitalWrite(LED3,LOW);
      digitalWrite(LED4,LOW);
      digitalWrite(LED5,LOW);
   } else if(distanceCm == 4){
      digitalWrite(LED1,HIGH);
      digitalWrite(LED2,HIGH);
      digitalWrite(LED3,LOW);
      digitalWrite(LED4,LOW);
      digitalWrite(LED5,LOW);
   } else if(distanceCm == 6){
      digitalWrite(LED1,HIGH);
      digitalWrite(LED2,HIGH);
      digitalWrite(LED3,HIGH);
      digitalWrite(LED4,LOW);
      digitalWrite(LED5,LOW);
   } else if(distanceCm == 8){
      digitalWrite(LED1,HIGH);
      digitalWrite(LED2,HIGH);
      digitalWrite(LED3,HIGH);
      digitalWrite(LED4,HIGH);
      digitalWrite(LED5,LOW);
   }  else if(distanceCm == 10){
      digitalWrite(LED1,HIGH);
      digitalWrite(LED2,HIGH);
      digitalWrite(LED3,HIGH);
      digitalWrite(LED4,HIGH);
      digitalWrite(LED5,HIGH);
   }
   return distanceCm;
}
