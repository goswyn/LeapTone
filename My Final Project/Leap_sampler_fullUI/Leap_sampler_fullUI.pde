import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;

import ddf.minim.*;
import com.leapmotion.leap.Gesture;
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.LeapMotion;


import ddf.minim.Minim;
import ddf.minim.AudioSample;
import ddf.minim.AudioPlayer;

LeapMotion leapMotion;

ConcurrentMap<Integer, Integer> fingerColors;
ConcurrentMap<Integer, Integer> toolColors;
ConcurrentMap<Integer, Vector> fingerPositions;
ConcurrentMap<Integer, Vector> toolPositions;

AudioSample plate;
AudioSample rattle;
AudioSample sheet;
AudioSample snares;
 
Minim minim;

 
void setup()
{
  size(550, 550);
  background(20);
  frameRate(60);
  ellipseMode(CENTER);
 

  leapMotion = new LeapMotion(this); 
 
  // this loads mysong.wav from the data folder

   

  minim = new Minim(this);
  plate = minim.loadSample("metalplate.wav", 512);
  rattle = minim.loadSample("metalrattle.wav", 512);
  sheet = minim.loadSample("metalsheet.wav", 512);
  snares = minim.loadSample("metalsnares.wav", 512);
  fingerColors = new ConcurrentHashMap<Integer, Integer>();
  toolColors = new ConcurrentHashMap<Integer, Integer>();
  fingerPositions = new ConcurrentHashMap<Integer, Vector>();
  toolPositions = new ConcurrentHashMap<Integer, Vector>();
  
  
}
 

void draw()
{
  
  // draws the tone matrix UI
  // Light grey indicates track attacked, darker grey means null
  fill(50);
  rect(30, 30, 100, 100);
  
  fill(50);
  rect(160, 30, 100, 100);
  
  fill(50);
  rect(290, 30, 100, 100);
  
  fill(30);
  rect(420, 30, 100, 100);
  
  fill(30);
  rect(30, 160, 100, 100);
  
  fill(30);
  rect(160, 160, 100, 100);
  
  fill(30);
  rect(290, 160, 100, 100);
  
  fill(30);
  rect(420, 160, 100, 100);
  
  fill(30);
  rect(30, 290, 100, 100);
  
  fill(30);
  rect(160, 290, 100, 100);
  
  fill(30);
  rect(290, 290, 100, 100);
  
  fill(30);
  rect(420, 290, 100, 100);
  
  fill(30);
  rect(30, 420, 100, 100);
  
  fill(30);
  rect(160, 420, 100, 100);
  
  fill(30);
  rect(290, 420, 100, 100);
  
  fill(30);
  rect(420, 420, 100, 100);
  
  // attaches the waves to the tone squares
  
    for (Map.Entry entry : fingerPositions.entrySet())
  {
    Integer fingerId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(fingerColors.get(fingerId));
    noStroke();
    ellipse(leapMotion.leapToSketchX(position.getX()), leapMotion.leapToSketchY(position.getY()), 4.0, 4.0);
      if ( leapMotion.leapToSketchX(position.getX()) > 30 && leapMotion.leapToSketchY(position.getY()) > 30 && leapMotion.leapToSketchX(position.getX()) < 130 && leapMotion.leapToSketchY(position.getY()) < 130)  {
        plate.trigger();
      }
      else if ( leapMotion.leapToSketchX(position.getX()) > 160 && leapMotion.leapToSketchY(position.getY()) > 30 && leapMotion.leapToSketchX(position.getX()) < 260 && leapMotion.leapToSketchY(position.getY()) < 130)  {
        rattle.trigger();
      }
      else if (leapMotion.leapToSketchX(position.getX()) > 290 && leapMotion.leapToSketchY(position.getY()) > 30 && leapMotion.leapToSketchX(position.getX()) < 390 && leapMotion.leapToSketchY(position.getY()) < 130)  {
        sheet.trigger();
      }
  }
  for (Map.Entry entry : toolPositions.entrySet())
  {
    Integer toolId = (Integer) entry.getKey();
    Vector position = (Vector) entry.getValue();
    fill(toolColors.get(toolId));
    noStroke();
    ellipse(leapMotion.leapToSketchX(position.getX()), leapMotion.leapToSketchY(position.getY()), 24.0, 24.0);
  }
  
  
  
}




void onInit(final Controller controller)
{
  controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
  controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
  controller.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
  controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  // enable background policy
  controller.setPolicyFlags(Controller.PolicyFlag.POLICY_BACKGROUND_FRAMES);
}

void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
                
   
  for (Finger finger : frame.fingers())
  {
    int fingerId = finger.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    fingerColors.putIfAbsent(fingerId, c);
    fingerPositions.put(fingerId, finger.tipPosition());
   
  }
  for (Tool tool : frame.tools())
  {
    int toolId = tool.id();
    color c = color(random(0, 255), random(0, 255), random(0, 255));
    toolColors.putIfAbsent(toolId, c);
    toolPositions.put(toolId, tool.tipPosition());
  }
  
}

// Find code to stop and reload sample code
// change tracking finger to not leave artifacts
//

void stop()
{
  plate.close();
  rattle.close();
  sheet.close();
  snares.close();
  minim.stop();
  super.stop();
}
