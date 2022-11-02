
import processing.video.*;
import jp.nyatla.nyar4psg.*;
PImage pic;
Capture cam;
MultiMarker nya;

void setup() {
  size(850,550,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,850,550);
  nya=new MultiMarker(this,width,height,"../../data/camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("../../data/patt.hiro",100);
  cam.start();
  pic = loadImage("ball.png");
}

void draw()
{
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);//frustumを考慮した背景描画
  if((!nya.isExist(0))){
    return;
  }
  nya.beginTransform(0);
   translate(0,0,0);
  
  rotateY(PI/10.0);
  image (pic, -200, -50, 400, 200);
  nya.endTransform();
}
