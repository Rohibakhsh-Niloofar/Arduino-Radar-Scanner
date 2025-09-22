import processing.serial.*;
import java.util.*;

Serial port;
int angle = 0;
int distance = 0;

final int BAUD = 9600;
final int radarRadius = 350;
final int maxDistanceCm = 200;

float smoothAngle = 0;
float smoothDistance = 0;
final float ALPHA = 0.2;

int[] prevScan = new int[181];  
int[] currScan = new int[181];  

ArrayList<String> warnings = new ArrayList<String>();

void setup() {
  size(900, 700);
  smooth(8);
  println("Available ports: " + join(Serial.list(), " | "));

  String chosen = pickPort();
  if (chosen == null) {
    println(" Connect Arduino Port / There is no Serial port !!!");
    noLoop();
    return;
  }

  port = new Serial(this, chosen, BAUD);
  port.bufferUntil('\n');

  for (int i = 0; i <= 180; i++) {
    prevScan[i] = -1;
    currScan[i] = -1;
  }
}

String pickPort() {
  String[] ps = Serial.list();
  if (ps.length == 0) return null;
  for (String p : ps) {
    if (p.contains("ACM") || p.contains("USB")) return p;
  }
  return ps[0];
}

void draw() {
  background(0);

  fill(0, 255, 0);
  textSize(18);
  text("Angle: " + angle + "°", 20, 30);
  text("Distance: " + distance + " cm", 20, 60);

  smoothAngle = ALPHA * angle + (1 - ALPHA) * smoothAngle;
  smoothDistance = ALPHA * distance + (1 - ALPHA) * smoothDistance;

  pushMatrix();
  translate(width/2, height - 20);

  stroke(0, 180, 0, 180);
  noFill();
  for (int r = 50; r <= radarRadius; r += 50) {
    arc(0, 0, r*2, r*2, PI, TWO_PI);
  }
  for (int a = 0; a <= 180; a += 15) {
    float x = cos(radians(a)) * radarRadius;
    float y = -sin(radians(a)) * radarRadius;
    line(0, 0, x, y);
  }


  float lx = cos(radians(smoothAngle)) * radarRadius;
  float ly = -sin(radians(smoothAngle)) * radarRadius;
  for (int i = 80; i > 0; i -= 5) {
    stroke(0, 255, 0, i*3);
    line(0, 0, lx, ly);
  }

  for (int a = 0; a <= 180; a++) {
    int d = currScan[a];
    if (d > 0 && d <= maxDistanceCm) {
      float r = map(d, 0, maxDistanceCm, 0, radarRadius);
      float x = cos(radians(a)) * r;
      float y = -sin(radians(a)) * r;

      if (d < 20) {
        drawPulsingBlip(x, y, color(255, 0, 0)); 
       
        fill(255);
        textSize(14);
        text(a + "° , " + d + " cm", x + 12, y - 12);
      } else {
        fill(0, 255, 0);
        noStroke();
        ellipse(x, y, 5, 5);
      }
    }
  }

  popMatrix();

  
  fill(50, 0, 0, 180);
  rect(width - 310, 10, 300, 220, 10);
  fill(255, 0, 0);
  textSize(16);
  text("⚠ ALERT CHANGES:", width - 300, 35);

  int yOffset = 60;
  for (int i = max(0, warnings.size()-10); i < warnings.size(); i++) {
    text(warnings.get(i), width - 300, yOffset);
    yOffset += 20;
  }
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;

  line = line.replace("Angle :", "").replace("Distance :", "");

  String[] toks = splitTokens(line, ",");
  if (toks.length >= 2) {
    try {
      angle = constrain(Integer.parseInt(trim(toks[0])), 0, 180);
      distance = max(0, Integer.parseInt(trim(toks[1])));

      currScan[angle] = distance;

      
      if (prevScan[angle] != -1 && abs(prevScan[angle] - distance) > 5) {
        String warn = "Angle " + angle + "° → " + distance + " cm (was " + prevScan[angle] + ")";
        warnings.add(warn);
      }

     
      if (angle == 180) {
        prevScan = currScan.clone();
      }
      if (angle == 0) {
        prevScan = currScan.clone();
      }

    } catch (Exception e) {
      println("Parse failed → " + line);
    }
  }
}

void drawPulsingBlip(float x, float y, color c) {
  noStroke();
  float pulse = 8 + sin(millis()/100.0) * 4;
  fill(c, 200);
  ellipse(x, y, pulse, pulse);
  fill(c, 80);
  ellipse(x, y, pulse*2, pulse*2);
}
