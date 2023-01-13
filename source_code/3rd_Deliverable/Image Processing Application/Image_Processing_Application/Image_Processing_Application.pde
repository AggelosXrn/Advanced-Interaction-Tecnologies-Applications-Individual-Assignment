import processing.core.PConstants;
import TUIO.*;


TuioProcessing tuioClient;


float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; 
boolean callback = true; 

 
PImage img1;
PImage img2;
PImage img;

void setup()
{
  size(640, 480);

  // Instance of TuioProcessing client
  tuioClient  = new TuioProcessing(this);

  // Load images
  img1 = loadImage("pao_1.jpg");
  img1.resize(450, 0);
  
  img2 = loadImage("pao_2.jpg");
  img2.resize(450, 0);
  
  

  // GUI setup
  noCursor();
  size(640, 480);
  noStroke();
  fill(0);


  if (!callback) 
  {
    frameRate(60);
    loop();
  } else noLoop(); 

  font = createFont("Arial", 18);
  scale_factor = height/table_size;
}



void draw()
{
  imageMode(CENTER);
  background(255);
  textFont(font, 18*scale_factor);
  float cur_size = cursor_size*scale_factor; 

  // Get Objects
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();

  for (int i = 0; i < tuioObjectList.size(); i++) 
  {
    TuioObject tobj = tuioObjectList.get(i);
    
    switch(tobj.getSymbolID())
    {
      // Images
    case 0:
      {
        image(img1, width/2, height/2);
        break;
      }

    case 1:
      {
        image(img2, width/2, height/2);
        break;
      }

    

      // Filters
    case 2:
      {
       filter(THRESHOLD);
        break;
      }

    case 3:
      {
        filter(BLUR, 10);
        break;
      }

    case 4:
      {
        filter(GRAY);
        break;
      }

    case 5:
      {
        
        translate(-width/2, -height/2);

        // Grab mouse coordinates, constrained to window
        int mx = constrain(mouseX, 0, width);
        int my = constrain(mouseY, 0, height);

        // Translate to the mouse location
        translate(mx, my);
        break;
      }

    case 6:
      {
        filter(POSTERIZE, 5);
        break;
      }
      
    case 7:
      {
        float mx = map(mouseX, -2, width, 0, 2);
        scale(mx);
        break;
      }
      
    case 8:
      {
        filter(ERODE);
        break;
      }
      
    case 9:
      {
        brightnessFilter();
        break;
      }
    }
  }

    // Get the current list of TUIO cursors
    ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();

    for (int i = 0; i < tuioCursorList.size(); i++)
    {
      TuioCursor tcur = tuioCursorList.get(i);

      ArrayList<TuioPoint> pointList = tcur.getPath();

      if (pointList.size()>0) 
      {
        stroke(0, 0, 255);
        TuioPoint start_point = pointList.get(0);

        for (int j = 0; j < pointList.size(); j++)
        {
          TuioPoint end_point = pointList.get(j);
          line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
          start_point = end_point;
        }

        stroke(300, 300, 300);
        fill(300, 300, 300);
        ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
        fill(0);
        text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
        
      }
    }

    // Get Blobs
    ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();

    for (int i = 0; i < tuioBlobList.size(); i++) {
      TuioBlob tblb = tuioBlobList.get(i);
      stroke(0);
      fill(0);
      pushMatrix();
      translate(tblb.getScreenX(width), tblb.getScreenY(height));
      rotate(tblb.getAngle());
      ellipse(-1*tblb.getScreenWidth(width)/2, -1*tblb.getScreenHeight(height)/2, tblb.getScreenWidth(width), tblb.getScreenWidth(width));
      popMatrix();
      fill(255);
      text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenX(width));
    }

   
  }

void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}


void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}


void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}


void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());

}


void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
    +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());

}


void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");

}

void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}

void brightnessFilter()
{ loadPixels();
 
  for (int x = 0; x < width; x++ ) {
    for (int y = 0; y < height; y++ ) {

      int loc = x + y*width;

      float r = red  (pixels[loc]);
      float g = green(pixels[loc]);
      float b = blue (pixels[loc]);
      
      float adjustBrightness = map(mouseX, 0, width, 0, 8);  
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;

      r = constrain(r, 0, 550); 
      g = constrain(g, 0, 550);
      b = constrain(b, 0, 550);

      color c = color(r, g, b);
      pixels[loc] = c;
    }
  }
  updatePixels();
}
