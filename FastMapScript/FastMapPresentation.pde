import hypermedia.video.*;
import java.awt.Rectangle;
import java.awt.Point;
import hypermedia.net.*;
OpenCV opencv;



// Set up the overall variables
int w = 800;
int h = 600;
int threshold = 103;
String message;
int len;
int lennew;
int counter;
boolean find=true;
String myFileName;

PFont font;

void setup() {

    frameRate(24);
    size( w, h );

    opencv = new OpenCV( this );
    myFileName = "/Users/m/Desktop/Untit.txt";
//    opencv.movie("/Users/m/Desktop/traffic.mov",640,480);
    opencv.capture(w,h);
    
    font = loadFont( "AndaleMono.vlw" );
    textFont( font );

    println( "Drag mouse inside sketch window to change threshold" );
    println( "Press space bar to record background image" );

}



void draw() {

    background(0);
    opencv.read();
    loop();
    
    image( opencv.image(OpenCV.MEMORY), 0, 0 ); // image in memory
    opencv.absDiff();
    opencv.threshold(threshold);
    image( opencv.image(OpenCV.GRAY), 0, 0 ); // absolute difference image
    
  

    // working with blobs
    Blob[] blobs = opencv.blobs( 200, w*h/3, 20, false );

    noFill();

    for( int i=0; i<blobs.length; i++ ) {
        lennew = len;
        Rectangle bounding_rect	= blobs[i].rectangle;
        float area = blobs[i].area;
        float circumference = blobs[i].length;
        Point centroid = blobs[i].centroid;
        Point[] points = blobs[i].points;
        len = blobs.length;
        if (lennew != len) {
          counter++;
        }
        

        // rectangle
        noFill();
        stroke( blobs[i].isHole ? 128 : 64 );


        // centroid
        stroke(255,255,255);
        line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
        line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
        noStroke();
        fill(255,255,255);
        text( centroid.x,centroid.x+5, centroid.y+5 );
        text( centroid.y,centroid.x+5, centroid.y+15 );
        text("Threshold is:" + threshold, 5, h-5);
        String out = (counter+i + ", " + centroid.x + ", " +  centroid.y + ", " 
        + hour() + "." + minute() + "." + second() + "." + millis());
       println(out);
//        println(frameRate);       
//        println(counter);       
       saveData(myFileName, out, true);

        fill(255,0,255,50);
        stroke(100,100,100);
        if ( points.length>0 ) {
            beginShape();
            for( int j=0; j<points.length; j++ ) {
                vertex( points[j].x, points[j].y );
            }
            endShape(CLOSE);
        }

        noStroke();
        fill(255,0,255);

    }

}

void saveData(String fileName, String newData, boolean appendData){
  BufferedWriter bw = null;
  try {  
    FileWriter fw = new FileWriter(fileName, appendData);
    bw = new BufferedWriter(fw);
    bw.write(newData + System.getProperty("line.separator"));
  } catch (IOException e) {
  } finally {
    if (bw != null){
      try { 
        bw.close(); 
      } catch (IOException e) {}  
    }
  }
}   


void keyPressed() {
    if ( key==' ' ) opencv.remember();
    if ( key=='r' ) counter=0;
    if ( key=='s' ) saveFrame(hour()+minute()+second()+".png");
    if ( key=='i' ) image( opencv.image(), 0, 0 ); // absolute difference image
    if (key == CODED) {
    if ( keyCode==UP  ) threshold = threshold+1;
    if ( keyCode==DOWN  ) threshold = threshold-1;
    }
}

void mouseDragged() {
    threshold = int( map(mouseX,0,width,0,255) );
}

public void stop() {
    opencv.stop();
    super.stop();
}
