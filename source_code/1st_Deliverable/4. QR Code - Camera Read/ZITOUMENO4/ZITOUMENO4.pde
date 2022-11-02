
import processing.video.*;
import qrcodeprocessing.*;

boolean overButton = false;



Capture video;                                 // instance of the video capture library
String statusMsg = "Waiting for an image";     // a string to return messages:

// Decoder object from prdecoder library
Decoder decoder;

void setup() {
  size(500, 420);
  video = new Capture(this, 420, 340);
  video.start();

  // Create a decoder object
  decoder = new Decoder(this);
  
}

// When the decoder object finishes
// this method will be invoked.
void decoderEvent(Decoder decoder) {
  statusMsg = decoder.getDecodedString();
}

void captureEvent(Capture video) {
  video.read();
}





void draw() {
  background(0);

  // Display video
  image(video, 0, 0);
  // Display status
  text(statusMsg, 10, height-4);

  // If we are currently decoding
  if (decoder.decoding()) {
    // Display the image being decoded
    PImage show = decoder.getImage();
    image(show, 0, 0, show.width/4, show.height/4); 
    statusMsg = "Decoding image";
    for (int i = 0; i < (frameCount/2) % 10; i++) statusMsg += ".";
  }
  
  if (overButton == true) {
    fill(255);
  } else {
    noFill();
  }
  
}

void keyReleased() {
  // Depending on which key is hit, do different things:
  switch (key) {
  case ' ':        
    // Spacebar takes a picture and tests it:
    // copy it to the PImage savedFrame:
    PImage savedFrame = createImage(video.width, video.height, RGB);
    savedFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
    savedFrame.updatePixels();
    // Decode savedFrame
    decoder.decodeImage(savedFrame);
    break;
  case 'f':    // f runs a test on a file
    PImage preservedFrame = loadImage("QR.png");
    // Decode file
    decoder.decodeImage(preservedFrame);
    link("https://github.com/AggelosXrn/Advanced-Interaction-Tecnologies-Applications-Individual-Assignment");
    break;
  }
}

void mousePressed() {
  if (overButton) { 
    link("https://github.com/AggelosXrn/Advanced-Interaction-Tecnologies-Applications-Individual-Assignment");
  }
}
