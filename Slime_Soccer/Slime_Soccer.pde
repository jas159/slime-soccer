import fisica.*;

boolean up, down, left, right, wkey, akey, skey, dkey;
boolean leftCanJump, rightCanJump, lresetGame, rresetGame;
FBox lground, rground, lwall, rwall, ceiling, lcrossbar, rcrossbar, lbacknet, rbacknet;
FCircle lplayer, rplayer, ball;
int timer, rscore, lscore;

color blue   = color(29, 178, 242);
color brown  = color(166, 120, 24);
color green  = color(74, 163, 57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);

FWorld world;

PImage sball, arg, bra;

void setup() {
  size(1000, 800);


  sball = loadImage("sball.png");
  sball.resize(30, 30);

  arg = loadImage("asball.png");
  arg.resize(75, 75);

  bra= loadImage("bsball.png");
  bra.resize(75, 75);

  timer =60;
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);

  //setup terrain
  lground = new FBox(500, 100);
  lground.setNoStroke();
  lground.setPosition(250, 775);
  lground.setFill(21, 131, 70);
  lground.setStatic(true);
  world.add(lground);

  rground = new FBox(500, 100);
  rground.setNoStroke();
  rground.setPosition(750, 775);
  rground.setFill(21, 131, 70);
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
  lplayer.attachImage(bra);
  lplayer.setRotatable(false);

  lplayer.setFriction(2);
  world.add(lplayer);

  rplayer = new FCircle(75);
  rplayer.setNoStroke();
  rplayer.setPosition(800, 400);
  rplayer.attachImage(arg);
  rplayer.setRotatable(false);
  rplayer.setFriction(2);
  world.add(rplayer);

  ball = new FCircle(30);
  ball.setNoStroke();
  ball.setRestitution(1.1);
  ball.setPosition(lplayer.getX(), 100);
  ball.attachImage(sball);
  world.add(ball);

  lcrossbar = new FBox(90, 3);
  lcrossbar.setStrokeWeight(1);
  lcrossbar.setPosition(77, 549);
  lcrossbar.setStatic(true);
  world.add(lcrossbar);

  rcrossbar = new FBox(90, 3);
  rcrossbar.setStrokeWeight(1);
  rcrossbar.setPosition(923, 549);
  rcrossbar.setStatic(true);
  world.add(rcrossbar);

  ceiling = new FBox(1500, 100);
  ceiling.setNoStroke();
  ceiling.setPosition(400, -50);
  ceiling.setStatic(true);
  world.add(ceiling);

  lbacknet = new FBox(90, 3);
  lbacknet.setStrokeWeight(1);
  lbacknet.setPosition(25, 549);
  lbacknet.setStatic(true);
  //world.add(lbacknet);

  rbacknet= new FBox(90, 3);
  rbacknet.setStrokeWeight(1);
  rbacknet.setPosition(975, 549);
  rbacknet.setStatic(true);
  //world.add(rbacknet);

  //leftbacknet
  FPoly pl = new FPoly();
  pl.vertex(32, 547);
  pl.vertex(35, 547);
  pl.vertex(3, 725);
  pl.vertex(0, 725);
  pl.setStatic(true);
  world.add(pl);

  //rightbacknet
  FPoly pr = new FPoly();
  pr.vertex(968, 547);
  pr.vertex(971, 547);
  pr.vertex(1000, 725);
  pr.vertex(997, 725);
  pr.setStatic(true);
  world.add(pr);
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

    
    ArrayList<FContact> ballcontacts = ball.getContacts();

    int q = 0;
    while (q < ballcontacts.size()) {
      FContact c = ballcontacts.get(q); 
      if (c.contains(lcrossbar)) {
        ball.setVelocity(0,0);
        ball.setPosition(200, 200);
        lplayer.setPosition(200, 485);
        lplayer.setVelocity(0, 0);
        rplayer.setPosition(800, 485 );
        rplayer.setVelocity(0, 0);
      }
      q++;
    }
    
    int o = 0;
    while (o < ballcontacts.size()) {
      FContact c = ballcontacts.get(o);
      if (c.contains(rcrossbar)) {
       ball.setVelocity(0,0);
       ball.setPosition(800,200);
       lplayer.setPosition(200, 485);
        lplayer.setVelocity(0, 0);
        rplayer.setPosition(800, 485 );
        rplayer.setVelocity(0, 0);
      }
      o++;
    }
   

    if (ball.getX() < 93 && ball.getY() > 549) {
      rscore++;
      ball.setVelocity(0, 0);
      ball.setRotatable(false);
      timer = 60;
      if (timer >= 0) {
        ball.setPosition(200, 200);
        lplayer.setPosition(200, 485);
        lplayer.setVelocity(0, 0);
        rplayer.setPosition(800, 485 );
        rplayer.setVelocity(0, 0);
      }
    }


    if (ball.getX() > 899 && ball.getY() > 549) {
      lscore++;
      ball.setVelocity(0, 0);
      ball.setRotatable(false);
      timer = 60;
      if (timer >= 0) {
        ball.setPosition(800, 200);
        //ball.setRotatable(false);
        lplayer.setPosition(200, 485);
        lplayer.setVelocity(0, 0);
        rplayer.setPosition(800, 485 );
        rplayer.setVelocity(0, 0);
      }
    }

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
      rplayer.setPosition(800, 485);
      ball.setPosition(800, 200);
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
      rplayer.setPosition(800, 485);
      ball.setPosition(200, 200);
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
