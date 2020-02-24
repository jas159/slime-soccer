import fisica.*;

boolean up, down, left, right, wkey, akey, skey, dkey;
boolean leftCanJump, rightCanJump, lresetGame, rresetGame;
FBox lground, rground, lwall, rwall, ceiling, lcrossbar, rcrossbar,lbacknet,rbacknet;
FCircle lplayer, rplayer, ball;
int timer, rscore, lscore;

color blue   = color(29, 178, 242);
color brown  = color(166, 120, 24);
color green  = color(74, 163, 57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);

FWorld world;

PImage sball;

void setup() {
  size(1000,800);


 sball = loadImage("sball.png");
  sball.resize(30,30);
  
  timer =60;

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);

  //setup terrain
  lground = new FBox(600, 100);
  lground.setNoStroke();
  lground.setPosition(300, 775);
  lground.setStatic(true);
  world.add(lground);

  rground = new FBox(600, 100);
  rground.setNoStroke();
  rground.setPosition(700, 775);
  rground.setStatic(true);
  world.add(rground);

  lwall = new FBox (50, 1400);
  lwall.setNoStroke();
  lwall.setPosition(-25, 0);
  lwall.setStatic(true);
  lwall.setFill(0);
  world.add(lwall);

  rwall = new FBox (50, 1400);
  rwall.setNoStroke();
  rwall.setPosition(1025, 0);
  rwall.setStatic(true);
  rwall.setFill(0);
  world.add(rwall);


  lplayer = new FCircle(75);
  lplayer.setNoStroke();
  lplayer.setPosition(200, 400);
  lplayer.setFill(231, 234, 40);
  lplayer.setRotatable(false);
  lplayer.setFriction(0.9);
  world.add(lplayer);

  rplayer = new FCircle(75);
  rplayer.setNoStroke();
  rplayer.setPosition(600, 400);
  rplayer.setFill(234, 40, 56);
  rplayer.setRotatable(false);
  rplayer.setFriction(0.9);
  world.add(rplayer);

  ball = new FCircle(30);
  ball.setNoStroke();
  ball.setRestitution(1);
  ball.setPosition(lplayer.getX(), 100);
  ball.setFill(255);
  ball.attachImage(sball);
  world.add(ball);

  lcrossbar = new FBox(90,3);
  lcrossbar.setStrokeWeight(1);
  lcrossbar.setPosition(77, 550);
  lcrossbar.setStatic(true);
  world.add(lcrossbar);

  rcrossbar = new FBox(90,3);
  rcrossbar.setStrokeWeight(1);
  rcrossbar.setPosition(923, 550);
  rcrossbar.setStatic(true);
  world.add(rcrossbar);
  
  lbacknet = new FBox();
  rbacknet= new FBox();

  ceiling = new FBox(1000, 100);
  ceiling.setNoStroke();
  ceiling.setPosition(400, -50);
  ceiling.setStatic(true);
  world.add(ceiling);
}

void draw() {
  timer--;
  if (timer<0) {
    background(#2DB9DE);

    fill(255);
    strokeWeight(1);
    //left post
    rect(123, 547, 8, 180);
    //right post
    rect(869, 547, 8, 180);
    
   
    leftCanJump = false;
    ArrayList<FContact> lcontacts = lplayer.getContacts();

    int i = 0;
    while (i < lcontacts.size()) {
      FContact c = lcontacts.get(i);
      if (c.contains(lground) || c.contains (rground)) leftCanJump = true;
      i++;
    }

    if (wkey && leftCanJump) lplayer.addImpulse(0, -2500);
    if (akey) lplayer.addImpulse(-250, 0);
    if (skey) ;
    if (dkey) lplayer.addImpulse(250, 0);

    rightCanJump = false;
    ArrayList<FContact> rcontacts = rplayer.getContacts();

    int j = 0;
    while (j < rcontacts.size()) {
      FContact c = rcontacts.get(j);
      if (c.contains(rground) || c.contains(lground)) rightCanJump = true;
      j++;
    }

    if (up && rightCanJump) rplayer.addImpulse(0, -2500);
    if (left) rplayer.addImpulse(-250, 0);
    if (down) ;
    if (right) rplayer.addImpulse(250, 0);


    world.step();
    world.draw();
  }

  fill(255);
  textSize(25);
  text("BRAZIL:"+lscore, 100, 100);
  text("ARGENTINA:"+rscore, 600, 100);

  if (lscore==3) {
    text("BRAZIL WINS", 320, 250);
    timer=100;
    timer++;
    text("restart", 350, 400);
    if (mousePressed) {
      lscore=0;
      rscore=0;
      lplayer.setPosition(200, 485);
      rplayer.setPosition(600, 485);
      ball.setPosition(200, 100);
      timer=60;
    }
  }
  if (rscore==3) {
    text("ARGENTINA WINS", 320, 250);
    text("restart", 350, 400);
    if (mousePressed) { 
      lscore=0;
      rscore=0;
      lplayer.setPosition(200, 485);
      rplayer.setPosition(600, 485);
      ball.setPosition(600, 100);
      timer=60;
    }

    timer=100;
    timer++;
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w' ) wkey = true;
  if (key == 'S' || key == 's' ) skey = true;
  if (key == 'A' || key == 'a' ) akey = true;
  if (key == 'D' || key == 'd' ) dkey = true;
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == RIGHT) right = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w' ) wkey = false;
  if (key == 'S' || key == 's' ) skey = false;
  if (key == 'A' || key == 'a' ) akey = false;
  if (key == 'D' || key == 'd' ) dkey = false;
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == RIGHT) right = false;
}
