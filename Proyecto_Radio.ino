#include <LiquidCrystal.h>

#include <C:\Users\Lucia\Desktop\Prueba\Inicio\pt\pt.h>

struct pt hiloS1;
struct pt hiloS2;
struct pt hiloS3;
struct pt hiloS4;
struct pt hiloS5;
struct pt hiloS6;
struct pt hiloPlay;
struct pt hiloStop;
struct pt hiloPause;
struct pt hiloInfo;
struct pt hiloLCD;

//------------------------------------------------------------ LECTURA VELOCIDAD
const int analogPin = A0;
const int pinBuzzer = 3;
static int cambioCancion = 0;
LiquidCrystal lcd(1,22,24,26,28,30);
int Cancion_Actual = 0;
int pause=0;
int stop1=0;
int play=0;
int aux=0;
//------------------------------------------------------------
void setup() {
  pinMode(pinBuzzer, OUTPUT);//buzzer
  
  PT_INIT(&hiloS1);
  PT_INIT(&hiloS2);
  PT_INIT(&hiloS3);
  PT_INIT(&hiloS4);
  PT_INIT(&hiloS5);
  PT_INIT(&hiloS6);
  PT_INIT(&hiloPlay);
  PT_INIT(&hiloStop);
  PT_INIT(&hiloPause);
  PT_INIT(&hiloInfo);
  PT_INIT(&hiloLCD);
}

void loop() {
  s1(&hiloS1, 4);   // Sonido 1 (Marcha Imperial)
  s2(&hiloS2, 2);   // Sonido 2 (Mario Bros)
  s3(&hiloS3, 5);   // Sonido 3 (Four Elise)
  s4(&hiloS4, 6);   // Sonido 4 (Para Adelina)
  s5(&hiloS5, 7);   // Sonido 5 (Tocata y fuga)
  s6(&hiloS6, 8);   // Sonido 6 (Noche de luna entre ruinas)
  pausa(&hiloPause,11);
  player(&hiloPlay,10);
  stp(&hiloStop,12);
  LCD(&hiloLCD, 9);   // Pantalla LCD
}


void pausa(struct pt *pt, int pin){
  PT_BEGIN(pt);
  static long t=0;
  static int valor =0;
  static int Old_valor=0;
  pinMode(pin,INPUT_PULLUP);
  while(true){
    valor=digitalRead(pin);
    if(((valor ^ Old_valor)==1) && valor==0){
      pause = 1;
      play=0;
      stop1=0;
      aux=0;
    }
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

static int posicionS = 0;
void player(struct pt *pt, int pin){
   PT_BEGIN(pt);
  static long t=0;
  static int valor =0;
  static int Old_valor=0;
  pinMode(pin,INPUT_PULLUP);
  while(true){
    valor=digitalRead(pin);
    if((((valor ^ Old_valor)==1) && valor==0) && stop1==0){
      pause = 0;
      play = 1;
      stop1=0;
      if(posicionS == 1){
       cambioCancion=1;
       s1(&hiloS1, 4);   // Sonido 1 (Marcha Imperial)
      }
      else if(posicionS == 4){
        cambioCancion=4;
        s4(&hiloS4,6);
      } else if(posicionS ==5){
        cambioCancion=5;
        s5(&hiloS5, 7);   // Sonido 5 (Tocata y fuga)
      }
    
    }
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

void stp(struct pt *pt, int pin){
   PT_BEGIN(pt);
  static long t=0;
  static int valor =0;
  static int Old_valor=0;
  pinMode(pin,INPUT_PULLUP);
  while(true){
    valor=digitalRead(pin);
    if(((valor ^ Old_valor)==1) && valor==0){
      pause = 0;
      play = 0;
      stop1=1;
     
    }
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

void LCD(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(pin, INPUT_PULLUP);
  lcd.begin(16,2);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      if(Cancion_Actual == 1){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Marcha Imperial - John Williams ");
        lcd.setCursor(0,1);
        lcd.print(" Cesar Alejandro Sazo Quisquinay ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      } else if(Cancion_Actual == 2){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Tema Mario Bros - Koji Condo ");
        lcd.setCursor(0,1);
        lcd.print(" Christian Enrique Ramos Alvarez ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 3){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Fur Elise - Ludwig van Beethoven ");
        lcd.setCursor(0,1);
        lcd.print(" Francisco Ernesto Carvajal Castillo ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 4){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Ballade pour Adeline - Richard Clayderman ");
        lcd.setCursor(0,1);
        lcd.print(" Lucia Alejandra Cabrera Ordoñez ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 5){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Toccata and Fugue - Johann Sebastian Bach ");
        lcd.setCursor(0,1);
        lcd.print(" Brayan Mauricio Aroche Boror ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 6){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Noche de Luna Entre Ruinas - Mariano Valverde ");
        lcd.setCursor(0,1);
        lcd.print(" Arqui1 Grupo 3 ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      } else if(Cancion_Actual == 0){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Proyecto Bocina - Arqui 1 ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
        //lcd.clear();
      }
    }else{
      if(Cancion_Actual == 1){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Marcha Imperial - John Williams ");
        lcd.setCursor(0,1);
        lcd.print(" Cesar Alejandro Sazo Quisquinay ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      } else if(Cancion_Actual == 2){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Tema Mario Bros - Koji Condo ");
        lcd.setCursor(0,1);
        lcd.print(" Christian Enrique Ramos Alvarez ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 3){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Fur Elise - Ludwig van Beethoven ");
        lcd.setCursor(0,1);
        lcd.print(" Francisco Ernesto Carvajal Castillo ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 4){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Ballade pour Adeline - Richard Clayderman ");
        lcd.setCursor(0,1);
        lcd.print(" Lucia Alejandra Cabrera Ordoñez ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 5){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Toccata and Fugue - Johann Sebastian Bach ");
        lcd.setCursor(0,1);
        lcd.print(" Brayan Mauricio Aroche Boror ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      }else if(Cancion_Actual == 6){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Noche de Luna Entre Ruinas - Mariano Valverde ");
        lcd.setCursor(0,1);
        lcd.print(" Arqui1 Grupo 3 ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
      } else if(Cancion_Actual == 0){
        lcd.setCursor(0,0);
        lcd.autoscroll();
        lcd.print(" Proyecto Bocina - Arqui 1 ");
        t = millis();
        PT_WAIT_WHILE(pt, (millis() - t) < 1000);
        //lcd.clear();
      }  
    }
    
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

int length = 70;
String notes[] = {"G4","G4", "G4", "D#4/Eb4", "A#4/Bb4", "G4", "D#4/Eb4","A#4/Bb4", "G4", "D5", "D5", "D5", "D#5/Eb5", "A#4/Bb4", "F#4/Gb4", "D#4/Eb4","A#4/Bb4", "G4", "G5","G4","G4","G5","F#5/Gb5", "F5","E5","D#5/Eb5","E5", "rest", "G4", "rest","C#5/Db5","C5","B4","A#4/Bb4","A4","A#4/Bb4", "rest", "D#4/Eb4", "rest", "F#4/Gb4", "D#4/Eb4","A#4/Bb4", "G4" ,"D#4/Eb4","A#4/Bb4", "G4"}; 
int beats[] = { 8, 8, 8, 6, 2, 8, 6 , 2 ,16 , 8, 8, 8, 6, 2, 8, 6, 2, 16,8,6,2,8,6,2,2, 2, 2,6,2,2,8,6,2,2,2,2,6,2,2,9,6,2,8,6,2,16  };
int tempoMI = 50;


void s1(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(analogPin, INPUT);
  pinMode(pin, INPUT_PULLUP);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      cambioCancion = 1;
      Cancion_Actual = 1;
      pause=0;
      stop1=0;
      play=0;
      static int i=0;
      for ( i = 0; i < length; i++) {
        if( cambioCancion == 1 ){
          if (notes[i] == "rest") {
            t = millis();
            PT_WAIT_WHILE(pt, (millis() - t) < beats[i] * tempoMI); // Espera por 1 segundo
          } else {
                //pause1();
                if(pause==1){
                  aux = i;
                  posicionS = 1;
                  cambioCancion=1;
                  break;
                }
                else if(stop1==1){
                  cambioCancion=0;
                  posicionS=0;
                  break;
                }
                else{
                   static int valorAnalogo = 0;
                   valorAnalogo = analogRead(analogPin);
                   valorAnalogo = valorAnalogo + tempoMI - 510;
                   playNote(notes[i], beats[i] * tempoMI);
                }
          }
          t = millis();
          PT_WAIT_WHILE(pt, (millis() - t) < tempoMI / 2); // Espera por 1 segundo 
        }
      }
    }
    else if(play == 1){
      if(cambioCancion==1){
        play=0;
        stop1=0;
        pause=0; 
        static int i=0;
      for ( i = aux; i < length; i++) {
        if( cambioCancion == 1 ){
          if (notes[i] == "rest") {
            t = millis();
            PT_WAIT_WHILE(pt, (millis() - t) < beats[i] * tempoMI); // Espera por 1 segundo
          } else {
                if(pause==1){
                  aux = i;
                  posicionS = 1;
                  cambioCancion=1;
                  break;
                }
                else if(stop1==1){
                  cambioCancion=0;
                  posicionS=0;
                  break;
                }
                else{
                  static int valorAnalogo = 0;
                   valorAnalogo = analogRead(analogPin);
                   valorAnalogo = valorAnalogo + tempoMI - 510;
                  playNote(notes[i], beats[i] * tempoMI);
                }
          }
          t = millis();
          PT_WAIT_WHILE(pt, (millis() - t) < tempoMI / 2); // Espera por 1 segundo 
        }
      }
      }
    }
    //cambioCancion = 0;
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}
#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978

#define SIXTEENTHNOTE 1
#define EIGHTHNOTE 2
#define DOTTEDEIGHTNOTE 3
#define QUARTERNOTE 4
#define DOTTEDQUARTERNOTE 6
#define HALFNOTE 8
#define DOTTEDHALFNOTE 12
#define WHOLENOTE 16

#define melodyPin 3
//Mario main theme melody
int melody[] = {
  NOTE_E7, NOTE_E7, 0, NOTE_E7,
  0, NOTE_C7, NOTE_E7, 0,
  NOTE_G7, 0, 0,  0,
  NOTE_G6, 0, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0,
  NOTE_C5  , NOTE_CS5 , 0 , NOTE_D5  ,
  NOTE_B5  , NOTE_F5  , NOTE_F5  , NOTE_F5  ,
  NOTE_E5  , NOTE_D5  , NOTE_E5  , NOTE_E5  , NOTE_E5  ,
  NOTE_C5  
};
//Mario main them tempo
int tempo[] = {
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  9, 9, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12, 12,
  12,
};
//Underworld melody
int underworld_melody[] = {

  NOTE_C4, NOTE_C5, NOTE_C4, 
  NOTE_C4, NOTE_C5, NOTE_C4,  
  NOTE_C3, NOTE_C4, NOTE_A2,  NOTE_A3,
  NOTE_AS2, NOTE_AS3,
  
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, 0,
  0,
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, 0,
  0,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, 0,
  0,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, 0,
  0, NOTE_DS4, NOTE_CS4, NOTE_D4,
  NOTE_CS4, NOTE_DS4,
  NOTE_DS4, NOTE_GS3,
  NOTE_G3, NOTE_CS4,
  NOTE_C4, NOTE_FS4, NOTE_F4, NOTE_E3, NOTE_AS4, NOTE_A4,
  NOTE_GS4, NOTE_DS4, NOTE_B3,
  NOTE_AS3, NOTE_A3, NOTE_GS3,
  0, 0, 0,NOTE_C4, NOTE_C4, NOTE_C5,
  
  
};
//Underwolrd tempo
int underworld_tempo[] = {

  12, 12, 12,
  12, 12, 12,
  12, 12, 12, 12, 
  12, 12,
 
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  6, 18, 18, 18,
  6, 6,
  6, 6,
  6, 6,
  18, 18, 18, 18, 18, 18,
  10, 10, 10,
  10, 10, 10,
  3, 3, 3,12, 12, 12,
  
  
};
void s2(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(analogPin, INPUT);
  pinMode(pin, INPUT_PULLUP);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      cambioCancion = 2;
      Cancion_Actual = 2;
      //----------------------------------------------------------------------------1
      Serial.println("----1----");
      static int size = sizeof(melody) / sizeof(int);
      static int thisNote = 0;
      for (thisNote = 0; thisNote < size; thisNote++) {
        if( cambioCancion == 2 ){
          // to calculate the note duration, take one second
          // divided by the note type.
          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
          static int valorAnalogo = 0;
          static int value = 0;
          static int noteDuration = 0;
          valorAnalogo = analogRead(analogPin);
          value = valorAnalogo + 510;
          noteDuration = value / tempo[thisNote];
          Serial.println(noteDuration);
          buzz(melodyPin, melody[thisNote], noteDuration);
          // to distinguish the notes, set a minimum time between them.
          // the note's duration + 30% seems to work well:
          static int pauseBetweenNotes = noteDuration * 1.30;
          t = millis();
          PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes); // Espera por 1 segundo
          //delay(pauseBetweenNotes);
          // stop the tone playing:
          buzz(melodyPin, 0, noteDuration);
        }
      }
      //----------------------------------------------------------------------------1
      Serial.println("----1----");
      size = sizeof(melody) / sizeof(int);
      thisNote = 0;
      for (thisNote = 0; thisNote < size; thisNote++) {
        if( cambioCancion == 2 ){
          // to calculate the note duration, take one second
          // divided by the note type.
          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
          static int valorAnalogo = 0;
          static int value = 0;
          static int noteDuration = 0;
          valorAnalogo = analogRead(analogPin);
          value = valorAnalogo + 510;
          noteDuration = value / tempo[thisNote];
          Serial.println(noteDuration);
          buzz(melodyPin, melody[thisNote], noteDuration);
          // to distinguish the notes, set a minimum time between them.
          // the note's duration + 30% seems to work well:
          static int pauseBetweenNotes = noteDuration * 1.30;
          t = millis();
          PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes); // Espera por 1 segundo
          //delay(pauseBetweenNotes);
          // stop the tone playing:
          buzz(melodyPin, 0, noteDuration);
        }
      }
      //----------------------------------------------------------------------------2
      Serial.println("----2----");
      size = sizeof(underworld_melody) / sizeof(int);
      thisNote = 0;
      for (thisNote = 0; thisNote < size; thisNote++) {
        if( cambioCancion == 2 ){
          // to calculate the note duration, take one second
          // divided by the note type.
          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
          static int valorAnalogo = 0;
          static int value = 0;
          static int noteDuration = 0;
          valorAnalogo = analogRead(analogPin);
          value = valorAnalogo + 510;
          noteDuration = value / tempo[thisNote];
          Serial.println(noteDuration);
          buzz(melodyPin, underworld_melody[thisNote], noteDuration);
          // to distinguish the notes, set a minimum time between them.
          // the note's duration + 30% seems to work well:
          static int pauseBetweenNotes = noteDuration * 1.30;
          t = millis();
          PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes); // Espera por 1 segundo
          //delay(pauseBetweenNotes);
          // stop the tone playing:
          buzz(melodyPin, 0, noteDuration);
        }
      }
    }
    //cambioCancion = 0;
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

int tempoS3 = 120;
boolean continuePlaying = true; //Set to true to continuously play (otherwise, false)
int continueDelay = 0; //Time to wait before continuing playing
void s3(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(analogPin, INPUT);
  pinMode(pin, INPUT_PULLUP);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      cambioCancion = 3;
      Cancion_Actual = 3;
      //Measure 1
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E6);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin) - 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_DS6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);      
      }        
      
      //Measure 2
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E6);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_DS6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_B5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_D6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 3
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_A3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 4
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_GS4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_GS5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_B5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 5
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_A3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_DS6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 6
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E6);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_DS6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_B5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_D6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 7
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_A3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }        
      
      //Measure 8
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_GS4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_GS5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_B5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }      
      
      //Measure 9
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_A3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_D6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 10
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_C4);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_G4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_G5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_F6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }        
      
      //Measure 11
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_G3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_G4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_B4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_F5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_D6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 12
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_A3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_D6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_C6);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
      
      //Measure 13
      if( cambioCancion == 3 ){
        tone(pinBuzzer, NOTE_E3);
        static float delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_E4);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + (analogRead(analogPin)- 510);
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
        tone(pinBuzzer, NOTE_A5);
        delayTime = (1000/tempoS3) * (60/4) * EIGHTHNOTE + analogRead(analogPin)- 510;
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < delayTime);
      }
    }
    //cambioCancion = 0;
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

int melody2[] = {
  NOTE_A6 , NOTE_G6 , NOTE_A6 , 0 ,
  NOTE_G6 , NOTE_F6 , NOTE_E6 , NOTE_D6 , NOTE_C6 , 0 ,

  NOTE_A5 , NOTE_G5 , NOTE_A5 , 0 ,
  NOTE_E5 , NOTE_F5 , NOTE_CS5 , NOTE_D5, 0,
   
  NOTE_A4 , NOTE_G4 , NOTE_A4 , 0       ,
  NOTE_G4 , NOTE_F4 , NOTE_E4 , NOTE_D4 , NOTE_C4 , 0 , 

  //7
  NOTE_CS4 , NOTE_E4 , NOTE_G4 , NOTE_B4 , NOTE_CS4 , NOTE_E4 , NOTE_D4 , 0 ,
  NOTE_E4  , NOTE_F4 ,

  NOTE_D4 , NOTE_A4 , NOTE_D4 ,
  //TEMPO
  NOTE_C4 , NOTE_D4 , NOTE_E4 , NOTE_C4 ,
            NOTE_D4 , NOTE_E4 , NOTE_C4 ,
            NOTE_D4 , NOTE_E4 , NOTE_C4 ,
  //FA
  NOTE_F5,
  NOTE_C5 , NOTE_D5 , NOTE_E5 , NOTE_C5 ,
            NOTE_D5 , NOTE_E5 , NOTE_C5 ,
            NOTE_D5 , NOTE_E5 , NOTE_C5 ,
  //FA
  NOTE_F6,
  NOTE_C6 , NOTE_D6 , NOTE_E6 , NOTE_C6 ,
            NOTE_D6 , NOTE_E6 , NOTE_C6 ,
            NOTE_D6 , NOTE_E6 , NOTE_C6 ,

  NOTE_A5 , NOTE_G5 , NOTE_F5 , NOTE_G5 , NOTE_F5 ,
  NOTE_A5 , NOTE_B5 , 0 ,

  NOTE_A5 , NOTE_G5 , NOTE_F5 , NOTE_G5 , NOTE_F5 , 
  NOTE_A5 , NOTE_B5 
  

};

// note durations: 4 = quarter note, 8 = eighth note, etc.:
int noteDurations2[] = {
  4, 4, 2, 4,
  5, 5, 4, 2, 1, 2,

  4, 4, 2, 4,
  5, 4, 2, 1, 2, 
  
  4, 4, 2, 4,
  5, 5, 4, 2, 1, 2,

  2, 4, 4, 4, 4, 3, 3, 2,
  1, 1 ,

  2 , 2 , 2 ,
  1 , 3 , 3 , 1 ,
      3 , 3 , 1 ,
      3 , 3 , 1 ,
  2,
  1 , 3 , 3 , 1 ,
      3 , 3 , 1 ,
      3 , 3 , 1 ,
  2,
  3 , 3 , 3 , 1 ,
      3 , 3 , 1 ,
      3 , 3 , 1 ,

  4 , 4 , 4 , 4 , 4 , 1 ,
  2 , 2 ,

  4 , 4 , 4 , 4 , 4 , 
  2 , 2 
  
};
int melody4[] = {

NOTE_G5 , NOTE_C5 , NOTE_D5 ,
NOTE_G5 , NOTE_C5 , NOTE_D5 ,
NOTE_G5 , NOTE_C5 , NOTE_D5 , 0 ,

NOTE_G5 , NOTE_E5 , NOTE_G5 ,
NOTE_G5 , NOTE_E5 , NOTE_G5 ,
NOTE_G5 , NOTE_E5 , NOTE_G5,


NOTE_C5 , 0,
NOTE_G5 , NOTE_E5 , 
NOTE_G5 , NOTE_E5 , NOTE_G5 , NOTE_E5 , NOTE_G5 ,
NOTE_D5 , NOTE_A5 , NOTE_F5 ,
NOTE_A5 , NOTE_F5 ,
NOTE_A5 ,   NOTE_F5 , 
NOTE_A5 ,  NOTE_G5 , NOTE_D5 , NOTE_B5,


NOTE_D5 , NOTE_B5,
NOTE_D5 , NOTE_B5,
NOTE_D5 , NOTE_C5,
NOTE_G5 , NOTE_E5,

NOTE_G5 , NOTE_E5,
NOTE_G5 , NOTE_E5, NOTE_G5,

NOTE_C5 , NOTE_G5 , NOTE_E5 , 
NOTE_G5 , NOTE_E5 , NOTE_G5 , NOTE_E5,
NOTE_G5 , NOTE_D5 , NOTE_A5 , NOTE_A5,
NOTE_F5 , NOTE_A5 , NOTE_F5 ,

NOTE_A5 , NOTE_G5 , NOTE_D5,
NOTE_B5 , NOTE_D5 , NOTE_B5,
NOTE_D5 , NOTE_B5 , NOTE_D5,
NOTE_C5 , NOTE_G5,

NOTE_E5 , NOTE_G5 , NOTE_E5 , NOTE_G5,
NOTE_C5 , NOTE_C5 , 
NOTE_B5 , NOTE_B5 ,
NOTE_A5 , NOTE_A5 ,
NOTE_E5 , NOTE_E5


};

// note durations: 4 = quarter note, 8 = eighth note, etc.:
int noteDurations4[] = {

   4, 4, 4, 
 4, 4, 4, 
 4, 4, 4, 4, 

 4, 4, 4, 
 4, 4, 4, 
 4, 4, 4, 

 2, 2,
 3, 3, 
 3, 3, 3, 3, 3, 
 3, 3, 3, 
 3, 3,
 2, 2, 
 3, 3, 2, 2, 
 
 4, 4, 8,

 5, 5,
 5, 5,
 5, 5,
 5, 5, 5,
 
3, 3, 3,
3, 3, 3, 3,
3, 3, 3, 3,
3, 3, 3,

3, 3, 4,
4, 4, 4,
4, 4, 4,
3, 3,

3, 3, 3, 3,
5, 5,
5, 5,
5, 5,
5, 5 ,
};
void s4(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(pin, INPUT_PULLUP);
  pinMode(analogPin, INPUT);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
     cambioCancion = 4;
      Cancion_Actual = 4;
      play=0;
      pause=0;
      stop1=0;
      
      for (static int thisNote = 0; thisNote < 82; thisNote++) {
        if(cambioCancion==4){
        if(pause==1){
          cambioCancion=4;
          posicionS=4;
          aux=thisNote;
          
          break;
        }else if(stop1==1){
          cambioCancion=0;
          aux=0;
          posicionS=0;
          break;
        }
        else{
          static int valor = 0;
          static int noteDuration = 0;
          valor = 1000 + (analogRead(analogPin)- 510);
          noteDuration = valor / noteDurations4[thisNote];
          tone(3, melody4[thisNote], noteDuration);
          static int pauseBetweenNotes = noteDuration * 1.30;
        //delay(pauseBetweenNotes);
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes);
        noTone(3);
        }
      }
      }
    }
    else if(play==1){
           
      play=0;
      stop1=0;
      pause=0;
      
      for (static int thisNote = 0; thisNote < 82; thisNote++) {
        if(cambioCancion==4){
        if(pause==1){
          cambioCancion=4;
          posicionS=4;
          aux=thisNote;
          play=0;
          break;
        }else if(stop1==1){
          cambioCancion=0;
          aux=0;
          posicionS=0;
          play=0;
          break;
        }
        else{
          
          static int valor = 0;
          static int noteDuration = 0;
          valor = 1000 + (analogRead(analogPin)- 510);
          noteDuration = valor / noteDurations4[thisNote];
          tone(3, melody4[thisNote], noteDuration);
          static int pauseBetweenNotes = noteDuration * 1.30;
        //delay(pauseBetweenNotes);
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes);
        noTone(3);
        }
      }
      }
    }
    
    //cambioCancion = 0;
  
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

void s5(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(pin, INPUT_PULLUP);
  pinMode(analogPin, INPUT); 

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      cambioCancion = 5;
      Cancion_Actual = 5;
      stop1=0;
      play=0;
      stop1=0;
      static int thisNote=0;
      
      for (thisNote = 0; thisNote < 80; thisNote++) {
        if (cambioCancion==5){    
        // to calculate the note duration, take one second divided by the note type.
        //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
        if(pause==1){
          posicionS=5;
          aux=thisNote;
          cambioCancion=5;
          
          break;
        }
        else if(stop1==1){
          cambioCancion=0;
          posicionS=0;
          aux=0;
          break;
        }
        else{
       static int valor = 0;
          static int noteDuration =0;
          valor = 1000 + (analogRead(analogPin)- 510);
          noteDuration = valor / noteDurations2[thisNote];
          tone(3, melody2[thisNote], noteDuration);
    
        // to distinguish the notes, set a minimum time between them.
        // the note's duration + 30% seems to work well:
        static int pauseBetweenNotes = noteDuration * 1.30;
        //delay(pauseBetweenNotes);
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes);
        // stop the tone playing:
        noTone(3);
        }
      }
      
    }
    } else if(play==1){
     
      play=0;
      pause=0;
      stop1=0;
      static int thisNote=0;
      for (thisNote = aux; thisNote < 80; thisNote++) {
        if(cambioCancion==5){
        // to calculate the note duration, take one second divided by the note type.
        //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
        if(pause==1){
          posicionS=5;
          aux=thisNote;
          cambioCancion=5;
          break;
        }
        else if(stop1==1){
          cambioCancion=0;
          aux=0;
          posicionS=0;
          break;
        }
        else{
       static int valor = 0;
          static int noteDuration =0;
          valor = 1000 + (analogRead(analogPin)- 510);
          noteDuration = valor / noteDurations2[thisNote];
          tone(3, melody2[thisNote], noteDuration);
    
        // to distinguish the notes, set a minimum time between them.
        // the note's duration + 30% seems to work well:
        static int pauseBetweenNotes = noteDuration * 1.30;
        //delay(pauseBetweenNotes);
        t = millis();
        PT_WAIT_WHILE(pt, (millis() -  t) < pauseBetweenNotes);
        // stop the tone playing:
        noTone(3);
        }
      }}
    }
    //cambioCancion = 0;
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

   
void s6(struct pt *pt, int pin) {
  PT_BEGIN(pt);   // Aqui inicia el protothread
  static long t = 0;
  static int valor = 0;
  static int Old_valor = 0;
  pinMode(pin, INPUT_PULLUP);
  static int Start=0;
  static int Pin = 3;
  pinMode(Pin, OUTPUT);

  while (true) {
    valor = digitalRead(pin);
    if (((valor ^ Old_valor) == 1) && valor == 0) {
      cambioCancion = 6;
      Cancion_Actual = 6;
      
      if( cambioCancion == 6 ){
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        //delay(3);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=375){
        digitalWrite(Pin, HIGH);
        delay(0);
        delayMicroseconds(0);
        digitalWrite(Pin, LOW);
        delay(0);
        delayMicroseconds(0);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=1000){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(349);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(349);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(275);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(275);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        //delay(3);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=375){
        digitalWrite(Pin, HIGH);
        delay(0);
        delayMicroseconds(0);
        digitalWrite(Pin, LOW);
        delay(0);
        delayMicroseconds(0);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=1000){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(349);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(349);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(275);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(275);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        
        //.;l
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        //delay(3);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=375){
        digitalWrite(Pin, HIGH);
        delay(0);
        delayMicroseconds(0);
        digitalWrite(Pin, LOW);
        delay(0);
        delayMicroseconds(0);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=1000){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(349);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(349);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(275);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(275);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        
        
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        //fmodknf
        
        //.;l
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(33);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        digitalWrite(Pin, LOW);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(405);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        //delay(3);
        delayMicroseconds(822);
        digitalWrite(Pin, LOW);
        //delay(3);
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 3);
        delayMicroseconds(822);
        }
        Start=millis();
        while ((millis()-Start)<=375){
        digitalWrite(Pin, HIGH);
        delay(0);
        delayMicroseconds(0);
        digitalWrite(Pin, LOW);
        delay(0);
        delayMicroseconds(0);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=1000){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(349);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(349);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(275);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(275);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(24);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(24);
        }
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        t = millis();
                PT_WAIT_WHILE(pt, (millis() -  t) < 250);
        //delay(250);
        
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(516);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(516);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(431);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(431);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(702);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(702);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=500){
        digitalWrite(Pin, HIGH);
        delay(1);
        delayMicroseconds(911);
        digitalWrite(Pin, LOW);
        delay(1);
        delayMicroseconds(911);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=750){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=125){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(551);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(551);
        }
        Start=millis();
        while ((millis()-Start)<=250){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(272);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(272);
        }
        
        delay(125);
        
        Start=millis();
        while ((millis()-Start)<=63){
        digitalWrite(Pin, HIGH);
        delay(2);
        delayMicroseconds(863);
        digitalWrite(Pin, LOW);
        delay(2);
        delayMicroseconds(863);
        }
      }
    }
    Old_valor = valor;
    PT_YIELD(pt);
  }
  PT_END(pt);
}

//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- MARIOS
//---------------------------------------------------------------------------------------------------------------------------------------------
void buzz(int targetPin, long frequency, long length) {
  digitalWrite(13, HIGH);
  long delayValue = 1000000 / frequency / 2; // calculate the delay value between transitions
  //// 1 second's worth of microseconds, divided by the frequency, then split in half since
  //// there are two phases to each cycle
  long numCycles = frequency * length / 1000; // calculate the number of cycles for proper timing
  //// multiply frequency, which is really cycles per second, by the number of seconds to
  //// get the total number of cycles to produce
  for (long i = 0; i < numCycles; i++) { // for the calculated length of time...
    digitalWrite(targetPin, HIGH); // write the buzzer pin high to push out the diaphram
    delayMicroseconds(delayValue); // wait for the calculated delay value
    digitalWrite(targetPin, LOW); // write the buzzer pin low to pull back the diaphram
    delayMicroseconds(delayValue); // wait again or the calculated delay value
  }
  digitalWrite(13, LOW);

}
//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- Marcha Imperial
//---------------------------------------------------------------------------------------------------------------------------------------------
void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(pinBuzzer, HIGH);
    delayMicroseconds(tone);
    digitalWrite(pinBuzzer, LOW);
    delayMicroseconds(tone);      
  }
}

void playNote(String note, int duration) {
  String noteNames[] = { "D#4/Eb4", "E4", "F4", "F#4/Gb4", "G4", "G#4/Ab4", "A4", "A#4/Bb4", "B4", "C5", "C#5/Db5", "D5", "D#5/Eb5", "E5", "F5", "F#5/Gb5", "G5", "G#5/Ab5", "A5", "A#5/Bb5", "B5", "C6", "C#6/Db6", "D6", "D#6/Eb6", "E6", "F6", "F#6/Gb6", "G6" };
  int tones[] = { 1607, 1516, 1431, 1351, 1275, 1203, 1136, 1072, 1012, 955, 901, 851, 803, 758, 715, 675, 637, 601, 568, 536, 506, 477, 450, 425, 401, 379, 357, 337, 318 };
  for (int i = 0; i < 29; i++) {
    if (noteNames[i] == note) {
      playTone(tones[i], duration);
    }
  }
}
//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- Para Elisa
//---------------------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- Para Adelina
//---------------------------------------------------------------------------------------------------------------------------------------------
//int tempoS3 = 120;
//boolean continuePlaying = true; //Set to true to continuously play (otherwise, false)
//int continueDelay = 0; //Time to wait before continuing playing
void spacedNote(int frequencyInHertz, int noteLength)
{
  tone(pinBuzzer, frequencyInHertz);
  float delayTime = (1000/tempoS3) * (60/4) * noteLength;
  delay(delayTime - 50);
  noTone(pinBuzzer);
  delay(50);
}

void note(int frequencyInHertz, int noteLength)  //Code to take care of the note
{
  tone(pinBuzzer, frequencyInHertz);
  float delayTime = (1000/tempoS3) * (60/4) * noteLength;
  delay(delayTime);
}        

void rest(int restLength)
{
  noTone(pinBuzzer);
  float delayTime = (1000/tempoS3) * (60/4) * restLength;
  delay(delayTime);
}
void metodoElisa(){
      // Song goes here
      //note(NOTE_G5, HALFNOTE);
      
      //Measure 1
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_DS6, EIGHTHNOTE);
      
      //Measure 2
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_DS6, EIGHTHNOTE);
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_B5, EIGHTHNOTE);
      note(NOTE_D6, EIGHTHNOTE);
      note(NOTE_C6, EIGHTHNOTE);
      
      //Measure 3
      note(NOTE_A3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A4, EIGHTHNOTE);
      note(NOTE_C5, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_A5, EIGHTHNOTE);
      
      //Measure 4
      note(NOTE_E3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_GS4, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_GS5, EIGHTHNOTE);
      note(NOTE_B5, EIGHTHNOTE);
      
      //Measure 5
      note(NOTE_A3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A4, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_DS6, EIGHTHNOTE);
      
      //Measure 6
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_DS6, EIGHTHNOTE);
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_B5, EIGHTHNOTE);
      note(NOTE_D6, EIGHTHNOTE);
      note(NOTE_C6, EIGHTHNOTE);
      
      //Measure 7
      note(NOTE_A3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A4, EIGHTHNOTE);
      note(NOTE_C5, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_A5, EIGHTHNOTE);
      
      //Measure 8
      note(NOTE_E3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_GS4, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_GS5, EIGHTHNOTE);
      note(NOTE_B5, EIGHTHNOTE);
      
      //Measure 9
      note(NOTE_A3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A4, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_C6, EIGHTHNOTE);
      note(NOTE_D6, EIGHTHNOTE);
      
      //Measure 10
      note(NOTE_C4, EIGHTHNOTE);
      note(NOTE_G4, EIGHTHNOTE);
      note(NOTE_C5, EIGHTHNOTE);
      note(NOTE_G5, EIGHTHNOTE);
      note(NOTE_F6, EIGHTHNOTE);
      note(NOTE_E6, EIGHTHNOTE);
      
      //Measure 11
      note(NOTE_G3, EIGHTHNOTE);
      note(NOTE_G4, EIGHTHNOTE);
      note(NOTE_B4, EIGHTHNOTE);
      note(NOTE_F5, EIGHTHNOTE);
      note(NOTE_E6, EIGHTHNOTE);
      note(NOTE_D6, EIGHTHNOTE);
      
      //Measure 12
      note(NOTE_A3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A4, EIGHTHNOTE);
      note(NOTE_E5, EIGHTHNOTE);
      note(NOTE_D6, EIGHTHNOTE);
      note(NOTE_C6, EIGHTHNOTE);
      
      //Measure 13
      note(NOTE_E3, EIGHTHNOTE);
      note(NOTE_E4, EIGHTHNOTE);
      note(NOTE_A5, EIGHTHNOTE);
      rest(EIGHTHNOTE); 
      
      /////// KEEP ALL CODE BELOW UNCHANGED, CHANGE VARS ABOVE ////////
      noTone(pinBuzzer);
      while(continuePlaying == false);
      delay(continueDelay);
}
//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- Tocata y fuga
//---------------------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------- Noche de luna entre ruinas
//---------------------------------------------------------------------------------------------------------------------------------------------
