//press p to show result
color white=color(255, 255, 255);
color red=color(255, 0, 0);
float  radius=50.0, time_start=0.0, time_on, time_end, movement=0.0;
char r='r', l='l';
boolean mbl=false, mbr=false, window_change=false, l_tapping=false, r_tapping=false, show_result;
int switch_num, a_lclicks=0, a_rclicks=0;
int correct_clicks, correct_rclicks, rthreshold=5, correct_threshold=20;//*************!!correct_threshold>=2*rthreshold!!!!

establish center;
establish leftdown;
establish rightdown;
establish rightup;
establish leftup;

void setup() {
  background(183, 181, 181);
  size(displayWidth/2, displayHeight/2);
  center = new establish(0.25*displayWidth, 0.25*displayHeight, r, red, false);
  leftdown= new establish(0.25*displayWidth-0.25*displayHeight+radius, 0.5*displayHeight-radius, l, white, true);
  rightdown= new establish(0.25*displayWidth+0.25*displayHeight-radius, 0.5*displayHeight-radius, l, white, true);
  rightup= new establish(0.25*displayWidth+0.25*displayHeight-radius, radius, l, white, true);
  leftup= new establish(0.25*displayWidth-0.25*displayHeight+radius, radius, l, white, true);
}
void draw() {
  background(183, 181, 181);


  if (window_change) {
    movement+=dist(mouseX, mouseY, pmouseX, pmouseY);


    center.DIST();
    center.mousePressed();
    center.filling();

    leftdown.DIST();
    leftdown.mousePressed();
    leftdown.filling();

    rightdown.DIST();
    rightdown.mousePressed();
    rightdown.filling();

    rightup.DIST();
    rightup.mousePressed();
    rightup.filling();

    leftup.DIST();
    leftup.mousePressed();
    leftup.filling();

    color_alter();

    if (correct_clicks==correct_threshold)
    {
      window_change=false;
    }
  }
  start();//initialize the window

  println("mbl ="+mbl+" mbr= "+mbr+" movement= "+movement+" "+"primary clicks= "+a_lclicks+" secondary clicks= "+a_rclicks+" correct_clicks= "+correct_clicks+" correct_r= "+correct_rclicks+" time= "+(time_end-time_start));

  //!!!!ensure pre-tapping is not in dots,then move to dots and change color.release tapping status. 
  if (l_tapping)l_tapping=false;
  if (r_tapping)r_tapping=false;
}

class establish {
  public
    boolean cursor_on=false, color_change=false, color_alter=false, lock=false;
  float DIST, x, y;
  char d;
  color initial, _initial;

  establish(float a, float b, char dd, color c, boolean loc) {
    x=a;
    y=b;
    d=dd;
    initial=c;
    lock=loc;
    if (initial!=red) {
      _initial=red;
    }
    else {
      _initial=white;
    }
  }   
  void DIST() { 
    DIST=sqrt(sq(mouseX-x)+sq(mouseY-y));
    if (DIST<0.5*radius)
      cursor_on=true;
    else
      cursor_on=false;
  }

  void mousePressed() {
    if ((!mbl)&&l_tapping && (d=='l')&&(!lock)) {
      if (cursor_on) {
        //l_tapping=false;
        lock=true;
        correct_clicks++;//-------------------------total correct clicks
        if (!color_change) {
          color_change=true;
        }
        else {
          color_change=false;
          color_alter=true;
        }
      }
    }
    if ((!mbr)&&r_tapping && (d=='r')&&(!lock)) {
      if (cursor_on) {
        //r_tapping=false;
        lock=true;
        correct_clicks++;//-------------------------total correct clicks
        correct_rclicks++;//------------------------right correct clicks
        if (!color_change)
        { 
          color_change=true;
        }
        else {
          color_change=false;
          color_alter=true;//used for non-center dots,when color_change 1->0
        }
      }
    }
  }

  void filling() {

    if (!color_change) {

      stroke(initial);
      fill(initial);
    }
    else {
      stroke(_initial);
      fill(_initial);
    }
    ellipse(x, y, radius, radius);
    noFill();
  }
}

void color_alter() {
  randomSeed(millis());

  //correct_right click threshold to limit the number of center clicks ----------

  if (correct_rclicks==rthreshold)
    switch_num=int(random(2, 4));
  else if ((correct_threshold-correct_clicks)<=2*(rthreshold-correct_rclicks+1))//don't forget to +1 e.g(9<2*4)***->9(2*(4+1))
    switch_num=1;
  else 
    switch_num=int(random(1, 4));

  //ensure the left and right cilicks are limited---------------------------------------------------------------------  

  //leftdown-------------------------------------------------------------------
  if (leftdown.color_alter ) {

    leftdown.color_alter=false;
    switch(switch_num) {
    case 1:
      center.lock=false;
      center.color_change=false;

      break;
    case 2:
      rightdown.lock=false;
      rightdown.color_change=true;

      break;
    case 3:
      leftup.lock=false;
      leftup.color_change=true;

      break;
    }
  }

  //rightdown-----------------------------------------  
  if (rightdown.color_alter) {

    rightdown.color_alter=false;
    switch(switch_num) {
    case 1:
      center.lock=false;
      center.color_change=false;

      break;
    case 2:
      rightup.lock=false;
      rightup.color_change=true;

      break;
    case 3:
      leftdown.lock=false;
      leftdown.color_change=true;

      break;
    }
  }
  //rightup---------------------------------
  if (rightup.color_alter) {

    rightup.color_alter=false;
    switch(switch_num) {
    case 1:
      center.lock=false;
      center.color_change=false;

      break;
    case 2:
      rightdown.lock=false;
      rightdown.color_change=true;

      break;
    case 3:
      leftup.lock=false;
      leftup.color_change=true;

      break;
    }
  }
  //leftup--------------------------
  if (leftup.color_alter) {

    leftup.color_alter=false;
    switch(switch_num) {
    case 1:
      center.lock=false;
      center.color_change=false;

      break;
    case 2:
      rightup.lock=false;
      rightup.color_change=true;

      break;
    case 3:
      leftdown.lock=false;
      leftdown.color_change=true;

      break;
    }
  }

  /*center----------------------------------------------------------------at the end of alter(),
   ensure there is one corner dot.color_change is true,*/
  if (center.color_change&&(!leftdown.color_change)&&(!rightdown.color_change)
    &&(!rightup.color_change)&&(!leftup.color_change))//only one corner change
  {    
    switch_num=int(random(1, 5));
    switch(switch_num) {
    case 1:
      leftdown.color_change=true;
      leftdown.lock=false;
      break;
    case 2:
      rightdown.color_change=true;
      rightdown.lock=false;
      break;
    case 3:
      rightup.color_change=true;
      rightup.lock=false;
      break;
    case 4:
      leftup.color_change=true;
      leftup.lock=false;
      break;
    }
  }
}

void start() {
  if (!window_change) {
    stroke(white);
    fill(red);
    rectMode(CENTER);
    rect(0.25*displayWidth, 0.25*displayHeight-50, 100, 50);

    //start or finish window-------------------------------
    if (correct_clicks < correct_threshold) {
      fill(white);
      textSize(32);
      textAlign(CENTER, CENTER);
      text("START", 0.25*displayWidth, 0.25*displayHeight-50);

      if ((!mbl) &&l_tapping&&(mouseX>(0.25*displayWidth-50))&&(mouseX<(0.25*displayWidth+50))
        &&(mouseY>(0.25*displayHeight-25-50))&&(mouseY<(0.25*displayHeight+25-50))) {
        l_tapping=false;
        time_start=millis();
        window_change=true;
      }
    }
    //fetch the time_end-----------------------------------------------------------
    else if (time_end==0.0) {
      time_end=millis();//time to end
    }
    //show result--------------------------------------------
    else {
      fill(white);
      textAlign(CENTER, CENTER);
      textSize(32);
      text("END", 0.25*displayWidth, 0.25*displayHeight-50);
      //time result------------------------------------------
      if (show_result) {
        textSize(40);
        text("TIME", (0.25*displayWidth-50)/2, 50);
        time_on=time_end-time_start;
        String time=str(time_on);
        textSize(25);
        text(time, (0.25*displayWidth-50)/2, 100);
        //movement result-----------------------
        textSize(40);
        text("MOVEMENT", (0.25*displayWidth-50)/2, 200);
        String movements=str(movement);
        textSize(25);
        text(movements, (0.25*displayWidth-50)/2, 250);
        //clicks-----------------------------------------------
        textSize(40);
        text("CLICKS", (0.25*displayWidth+50)+((0.25*displayWidth-50)/2), 50);
        String PRIMARY=str(a_lclicks);
        String SECONDARY=str(a_rclicks);
        textSize(30);
        text("PRIMARY", (0.25*displayWidth+50)+((0.25*displayWidth-50)/2), 150);
        text("SECONDARY", (0.25*displayWidth+50)+((0.25*displayWidth-50)/2), 250);
        textSize(20);
        text(PRIMARY, (0.25*displayWidth+50)+((0.25*displayWidth-50)/2), 200);
        text(SECONDARY, (0.25*displayWidth+50)+((0.25*displayWidth-50)/2), 300);
      }
    }
  }
}

//for makey-makey--------------------------
void mouseReleased() {
  if (mouseButton==LEFT)
    mbl=true;
  if (mouseButton==RIGHT)mbr=true;
}

void mousePressed() {
  if ((correct_clicks!=correct_threshold)) {
    if (mouseButton==LEFT) {
      if (mbl) {
        if (window_change)
        {
          a_lclicks++;
        }//1->0,+1************************
        l_tapping=true;//when mbl 1->0,toes up to down
      }
      mbl=false;
    }
    if (mouseButton==RIGHT) {
      if (mbr) {
        if (window_change)
        {
          a_rclicks++;
        }
        r_tapping=true;
      }
      mbr=false;
    }
  }
}
//for makey-makey-------------------------------------
void keyPressed() {
  if (key=='p')
    show_result=true;
}

