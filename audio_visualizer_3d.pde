import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

FFT fft;
AudioPlayer player;
Minim minim;
float rotateAll = 0;
int depth, flashTimer = 0;
boolean fullScreenMode = true;
boolean flash=false;

void setup() {
   stroke(0, 239, 135); 
   strokeWeight(5);

   fullScreen(P3D);
   //size(600, 600, P3D);
   if (fullScreenMode) {
      depth = 0;
   } else {
      depth = -120;
   }

   background(0);
   minim = new Minim(this);
   //player = minim.loadFile("D:/test.mp3");  //600
   player = minim.loadFile("D:/__Music/Stephen Swartz -- Bullet Train (Feat. Joni Fatora).mp3");  //1000
   player.play();
   fft = new FFT(player.bufferSize(), player.sampleRate());
}

void draw() {
   background(0, 20, 20);
   lights();

   fft.forward(player.mix);

   pushMatrix();
   translate(width/2, height/2, depth);
   rotateAll+=0.01;
   rotateY(rotateAll);
   if (rotateAll>255)
      rotateAll = 0;

   if (flash) {
      if (flashTimer > 100) {
         flash = false;
         flashTimer = 0;
      } else {
         flashTimer++;
         background(255 / flashTimer*2, 100 / flashTimer*2, 0);
      }
   }

   for (int i=0; i<24; i++) {
      pushMatrix();

      rotateY(PI+i*50);

      translate(200, 200, 0);
      if (fft.getBand(i)*5 > 300) {

         if (i==4 && fft.getBand(i)*5 > 1000) {
            flash = true;
         }

//         stroke(255, 100, 0); 
//         fill(255, 0, 0, 10);
      } else {
         stroke(0, 239, 135); 
         fill(0, 254, 179, 33);
      }
      box(50, (-fft.getBand(i)*5) - 80, 50);  //lerp(display[i], target[i], 1-sensitivity);

      popMatrix();
   }

   popMatrix();
}

void keyPressed() {
   if (key == 'p')
      player.play();
   else if (key == 's')
      player.pause();
}
