public void mainMenu()
{
  rectMode(CENTER);
  
  background(menuBG);
  // Logo
  noStroke();
  fill(#FFB593, 100);
  rect(600, 125, 800, 150);
  fill(100, 190);
  rect(600 + 3, 50 + 3, 800, 10);
  rect(600 + 3, 200 + 3, 800, 10);
  fill(255);
  rect(600, 50, 800, 10);
  rect(600, 200, 800, 10);
  
  textAlign(LEFT, CENTER);
  textSize(44);
  fill(100, 190);
  text("-  J  E  U     D  '    8  G  H  !  -", 220 + 3, 100 + 3);
  fill(255);
  text("-  J  E  U     D  '    8  G  H  !  -", 220 , 100);
  
  textAlign(RIGHT, CENTER);
  textSize(27);
  fill(100, 190);
  text("E L I T E  P R O D U C T I O N S", 980 + 3, 160 + 3);
  fill(0xffF08372);
  text("E L I T E  P R O D U C T I O N S", 980 , 160);
  
  strokeWeight(15);
  stroke(100, 190);
  noFill();
  ellipse(600 + 3, 400 + 3, 300, 300);
  
  if(dist(mouseX, mouseY, 600, 400) < 150)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  ellipse(600, 400, 300, 300);
  
  fill(#FFB593, 100);
  strokeWeight(7);
  stroke(100, 190);
  rect(400 + 3, 675 + 3, 380, 150);
  
  if(mouseX > 210 && mouseX < 590 && mouseY > 600 && mouseY < 750)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  rect(400, 675, 380, 150);
  
  stroke(100, 190);
  rect(800 + 3, 675 + 3, 380, 150);
  
  if(mouseX > 610 && mouseX < 990 && mouseY > 600 && mouseY < 750)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  rect(800, 675, 380, 150);
  
  noFill();
  strokeWeight(5);
  stroke(100, 190);
  rect(1000 + 3, 300 + 3, 250, 80);
  rect(1000 + 3, 500 + 3, 250, 80);
  
  if(mouseX > 875 && mouseX < 1125 && mouseY > 260 && mouseY < 340)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  if(ruleset == 0) fill(#FF6D29, 220); else
  fill(200, 190);
  rect(1000, 300, 250, 80);
  
  if(mouseX > 875 && mouseX < 1125 && mouseY > 460 && mouseY < 540)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  if(ruleset == 1) fill(#FF6D29, 220); else
  fill(200, 190);
  rect(1000, 500, 250, 80);
  
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(100, 190);
  text("CHANGE PLAYER 1's DECK!", 400 + 3, 675 + 3, 380, 150);
  
  fill(255);
  text("CHANGE PLAYER 1's DECK!", 400, 675, 380, 150);
  
  fill(100, 190);
  text("CHANGE PLAYER 2's DECK!", 800 + 3, 675 + 3, 380, 150);
  
  fill(255);
  text("CHANGE PLAYER 2's DECK!", 800, 675, 380, 150);
 
  textSize(25);
  fill(100, 190);
  text("CLASSIC MODE!", 1000 + 3, 300 + 3);
  
  fill(255);
  text("CLASSIC MODE!", 1000, 300);
  
  fill(100, 190);
  text("SANDBOX MODE!", 1000 + 3, 500 + 3);
  
  fill(255);
  text("SANDBOX MODE!", 1000, 500);
 
  noStroke();
  fill(100, 190);
  triangle(540 + 3, 330 + 3, 540 + 3, 470 + 3, 680 + 3, 400 + 3);
  if(dist(mouseX, mouseY, 600, 400) < 150)
    fill(0xffFFC60A, 150);
  else
    fill(255);
  triangle(540, 330, 540, 470, 680, 400);
  
  // Settings
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(60 + 3, 60 + 3, 100, 100); // Shadow
  textSize(24);
  
  if(dist(mouseX, mouseY, 60, 60) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(60, 60, 100, 100); // Real
  
  imageMode(CENTER);
  image(icon, 60, 60, 90, 90);
  
  // Instructions
  noFill();
  stroke(100, 180);
  ellipse(60 + 3, 740 + 3, 100, 100); // Shadow
  textSize(24);
  
  if(dist(mouseX, mouseY, 60, 740) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(60, 740, 100, 100); // Real
  
  imageMode(CENTER);
  image(qMark, 60, 740, 90, 90);
  
  
  // Credits
  noFill();
  stroke(100, 180);
  ellipse(1140 + 3, 740 + 3, 100, 100); // Shadow
  textSize(24);
  
  if(dist(mouseX, mouseY, 1140, 740) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(1140, 740, 100, 100); // Real
  
  imageMode(CENTER);
  image(credit, 1140, 740, 90, 90);
  
  // QUIT button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(1200 - 60 + 3, 60 + 3, 100, 100); // Shadow
  textSize(24);
  fill(100, 180);
  text("QUIT!", 1200 - 60 + 3, 60 + 3);
  
  if(dist(mouseX, mouseY, 1200 - 60, 60) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(1200 - 60, 60, 100, 100); // Real
  fill(255);
  text("QUIT!", 1200 - 60, 60);
}

int scroll = 0;
int sort = 0;
int collectionSelected = -1;
boolean addingCard = false;
int deckSelected = -1;

public void chooseDeck(int playerDeck)
{
  background(menuBG);
  // Logo
  rectMode(CENTER);
  noStroke();
  fill(100, 190);
  rect(600 + 3, 50 + 3, 800, 10);
  rect(600 + 3, 200 + 3, 800, 10);
  fill(255);
  rect(600, 50, 800, 10);
  rect(600, 200, 800, 10);
  fill(#FFB593, 100);
  rect(600, 125, 800, 150);
  
  textAlign(LEFT, CENTER);
  textSize(44);
  fill(100, 190);
  text("D  E  C  K    S  E  L  E  C  T", 220 + 3, 100 + 3);
  fill(255);
  text("D  E  C  K    S  E  L  E  C  T", 220 , 100);
  
  textAlign(RIGHT, CENTER);
  textSize(27);
  fill(100, 190);
  text("E L I T E  P R O D U C T I O N S", 980 + 3, 160 + 3);
  fill(0xffF08372);
  text("E L I T E  P R O D U C T I O N S", 980 , 160);

  strokeWeight(8);
  
  noFill();
  stroke(100, 190);
  rect(272 + 3, 500 + 3, 285, 560);
  if(addingCard)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  rect(272, 500, 285, 560);
  
  noStroke();
  fill(100, 55);
  rect(790 + 3, 500 + 3, 560, 560);
  
  fill(255, 75);
  rect(790, 500, 560, 560);
  
  fill(100, 190);
  rect(1135 + 3, 465 + 3, 100, 50);
  rect(1135 + 3, 535 + 3, 100, 50);
  
  fill(0xffF08372);
  rect(1135, 465, 100, 50);
  rect(1135, 535, 100, 50);
  
  fill(100, 190);
  triangle(1100 + 3, 480 + 3, 1170 + 3, 480 + 3, 1135 + 3, 450 + 3);
  triangle(1100 - 3, 520 - 3, 1170 - 3, 520 - 3, 1135 - 3, 550 - 3);
  fill(255);
  triangle(1100, 480, 1170, 480, 1135, 450);
  triangle(1100, 520, 1170, 520, 1135, 550);
  
  strokeWeight(3);
  String sortBy = "";
  if(sort == 0) sortBy = "All"; 
  else sortBy = categNames[sort - 1];
  noFill();
  stroke(100, 190);
  rect(65 + 3, 500 + 3, 90, 90);
  textSize(15);
  fill(100, 190);
  textAlign(CENTER, CENTER);
  text("Sorting By: ", 65 + 3, 497 + 3, 80, 80);
  textSize(13);
  text(sortBy, 65 + 3, 510 + 3, 80, 80);
  
  int co = 0; 
  if(sort == 0) co = 0xff767676; 
  else co = categColour[sort - 1];
  fill(co, 190);
  stroke(255);
  rect(65, 500, 90, 90);
  textSize(15);
  fill(255);
  text("Sorting By: ", 65, 497, 80, 80);
  textSize(13);
  text(sortBy, 65 , 510 , 80, 80);
  
  // Back button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(1200 - 60 + 3, 60 + 3, 100, 100); // Shadow
  textSize(24);
  fill(100, 180);
  text("BACK..", 1200 - 60 + 3, 60 + 3);
  
  if(dist(mouseX, mouseY, 1140, 60) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(1200 - 60, 60, 100, 100); // Real
  fill(255);
  text("BACK..", 1200 - 60, 60);
  
  // Save button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(60 + 3, 60 + 3, 100, 100); // Shadow
  textSize(24);
  fill(100, 180);
  text("SAVE!", 60 + 3, 60 + 3);
  
  if(dist(mouseX, mouseY, 60, 60) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(60, 60, 100, 100); // Real
  fill(255);
  text("SAVE!", 60, 60);
  
  for(int i = 0; i < offlineDecks[0].length; i++)
  {
    int x = i % 2;
    int y = i / 2;
    x = parseInt(204 + x * 137.5f);
    y = parseInt(294 + y * 137.5f);
    
    if(!addingCard)
      fill(255, 40);
    else fill(100, 100);
    strokeWeight(3);

    stroke(100, 190);
    rect(x + 3, y + 3, 110, 110);
    stroke(255);
    rect(x, y, 110, 110);
    textSize(15);
    
    if(!addingCard)
      fill(100, 190);
    else
      fill(50, 90);
    cardDisplay(x, y, 1.1, offlineDecks [playerDeck] [i], 0);
  }
  int j = 0;
  int correctX = 0, correctY = 0;
  for(int i = 0; i < collection.length; i++)
  {
    if(!collection[i].category.contains(sort - 1) && sort != 0) continue;
    if(collection[i].NBTTags.contains("Unobtainable")) continue;
    int x = j % 5;
    int y = j / 5 - scroll;
    if(collectionSelected == i) { correctX = x; correctY = y; }
    x = 570 + x * 110;
    y = 280 + y * 110;
    boolean alreadyInDeck = false;
    for(Card c: offlineDecks[playerDeck])
    {
      if(c.name.equals(collection[i].name)) { alreadyInDeck = true; break; }
    }
    
    if(y >= 280 && y <= 730)
    {
      int cC = 0;
      for(int index: collection[i].category) cC = categColour[index];
      
      fill(cC, 50);
      if(collection[i].isSpell) noFill();
      if(alreadyInDeck) fill(100, 100);
      
      strokeWeight(3);
      if(!alreadyInDeck)
        stroke(100, 190);
      else
        stroke(50, 90);
      rect(x + 3, y + 3, 90, 90);
      if(!alreadyInDeck)
        stroke(255);
      else
        stroke(205, 155); 
      rect(x, y, 90, 90);
      textSize(12); 
      cardDisplay(x, y, 0.95, collection[i], 1);
    }
    
    j++;
  }
  if(addingCard)
  {
    noStroke(); 
    fill(100, 100);
    rect(790, 500, 560, 560);
  }
  
  if(deckSelected != -1)
  {
    int x = deckSelected % 2;
    int y = deckSelected / 2;
    x = parseInt(204 + x * 137.5f);
    y = parseInt(294 + y * 137.5f);
    textAlign(CENTER, CENTER);
    strokeWeight(20); // Bigger Strokeweight
    stroke(0xffFFC400, 150); 
    noFill();
    rect(x, y, 110, 110);
    fill(100, 200);
    stroke(255);
    strokeWeight(4);
    if(y > 500) y -= 320;
    rect(x, y + 160, 300, 200);
    textSize(12);
    fill(100, 190);
    text(offlineDecks[playerDeck] [deckSelected].ability, x + 1, y + 160 + 1, 295, 195);
    fill(255);
    text(offlineDecks[playerDeck] [deckSelected].ability, x, y + 160, 295, 195);
    
    int counter = 0;
    for(int i: offlineDecks[playerDeck] [deckSelected].category)
    {
      String categName = categNames[i];
      textSize(8);
      noFill();
      stroke(255);
      strokeWeight(1);
      rect(x - 125 + (50 * counter), y + 85, 50, 50);
      
      fill(100, 190);
      text(categName, x - 125 + (50 * counter) + 1, y + 85 + 1); 
      fill(255);
      text(categName, x - 125 + (50 * counter), y + 85); 
      counter++;
    }
  }
  
  if(collectionSelected != -1)
  {
    int x = correctX;
    int y = correctY;
    x = 570 + x * 110;
    y = 280 + y * 110;
    strokeWeight(20); // Bigger Strokeweight
    stroke(0xffFFC400, 150); 
    noFill();
    rect(x, y, 90, 90);
    fill(100, 200);
    stroke(255);
    strokeWeight(4);
    if(y > 600) y -= 320;
    if(!addingCard)
    {
      rect(x, y + 160, 300, 200);
      textSize(12);
      fill(100, 190);
      
      text(collection [collectionSelected].ability, x + 1, y + 160 + 1, 295, 195);
      fill(255);
      text(collection [collectionSelected].ability, x, y + 160, 295, 195);
      
      noFill();
      strokeWeight(2);
      stroke(100, 190);
      rect(x + 2, y + 160 - 75 + 2, 100, 30);
      stroke(255);
      rect(x, y + 85, 100, 30);
      
      textSize(15);
      fill(100, 190);
      text("Place Card!", x + 3, y + 160 - 75 + 3);
      fill(255);
      text("Place Card!", x, y + 160 - 75);
      
      int counter = 0;
      for(int i: collection[collectionSelected].category)
      {
        String categName = categNames[i];
        textSize(8);
        noFill();
        stroke(255);
        strokeWeight(1);
        rect(x - 125 + (50 * counter), y + 85, 50, 50);
        
        fill(100, 190);
        text(categName, x - 125 + (50 * counter) + 1, y + 85 + 1); 
        fill(255);
        text(categName, x - 125 + (50 * counter), y + 85); 
        counter++;
      }
    }
  }
}

int instructionPage = 0;

public void options(String type)
{
  // bg
  mainMenu();
  
  noStroke();
  fill(100, 190);
  rectMode(CORNER);
  rect(0, 0, 1200, 800);
  
  //Main
  strokeWeight(10);
  stroke(0xffFFB07E);
  
  fill(0xffFF6D12);
  rectMode(CENTER);
  beginShape();
  vertex(320, 60);
  vertex(880, 60);
  vertex(1040, 400);
  vertex(880, 740);
  vertex(320, 740);
  vertex(160, 400);
  endShape(CLOSE);
  
  noStroke();
  
  fill(100, 190);
  ellipse(600 + 7, 80 + 7, 130, 130);
  
  strokeWeight(5);
  stroke(0xffFFDEC9);
  
  fill(0xffF2B690);
  ellipse(600, 80, 130, 130);
  
  PImage correctIcon = icon;
  if(mode == 8) correctIcon = qMark;
  if(mode == 9) correctIcon = credit;
  image(correctIcon, 600, 80, 120, 120);
  
  // white line
  rectMode(CENTER);
  textSize(45);
  noStroke();
  fill(100, 190);
  rect(425 + 3, 100 + 3, 150, 10);
  rect(775 + 3, 100 + 3, 150, 10);
  rect(600 + 3, 250 + 3, 500, 10);
  text(type, 600 + 3, 175 + 3);
  fill(100 , 140);
  rect(437 + 2, 120 + 2, 125, 5); 
  rect(763 + 2, 120 + 2, 125, 5); 
  rect(600 + 2, 230 + 2, 450, 5);
  
  
  noStroke();
  // real
  fill(255);
  rect(425, 100, 150, 10);
  rect(775, 100, 150, 10);
  rect(600, 250, 500, 10);
  
  fill(#FCC496, 200);
  rect(600, 230, 450, 5);
  rect(437, 120, 125, 5); 
  rect(763, 120, 125, 5); 
  fill(255);
  text(type, 600, 175);
  
  // Back button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(1200 - 60 + 3, 60 + 3, 100, 100); // Shadow
  textSize(24);
  fill(100, 180);
  text("BACK..", 1200 - 60 + 3, 60 + 3);
  
  if(dist(mouseX, mouseY, 1140, 60) < 50)
    stroke(0xffFFC60A, 150);
  else
    stroke(255);
  noFill();
  ellipse(1200 - 60, 60, 100, 100); // Real
  fill(255);
  text("BACK..", 1200 - 60, 60);
  
  if(mode == 7) // 900, 320 | 900, 400
  {
    strokeWeight(3);
    rectMode(CORNER);
    noStroke();
    fill(100, 190);
    rect(290 + 6, 290 + 6, 500, 60);
    rect(290 + 6, 370 + 6, 500, 60);
    
    stroke(#F2B68E);
    fill(#E8640C);
    rect(290, 290, 500, 60);
    rect(290, 370, 500, 60);
    
    textSize(30);
    textAlign(LEFT, CENTER);
    fill(100, 190);
    text("Toggle Animations!", 300 + 3, 320 + 3);
    text("Toggle Action Replay!", 300 + 3, 400 + 3);
    fill(255);
    text("Toggle Animations!", 300, 320);
    text("Toggle Action Replay!", 300, 400);
    
    
    
    for(Button b: settings) b.drawButton();
  }
  if(mode == 8)
  {
    textSize(48);
    fill(100, 190);
    text("Coming Soon!", 600 + 3, 400 + 3);
    fill(255);
    text("Coming Soon!", 600, 400);
  }
  if(mode == 9)
  {
    fill(100, 190);
    textSize(32);
    text("Lead Developer: Ben Zeng", 600 + 3, 330 + 3);
    textSize(16);
    text("Based off of the card game, 'Jeu d'8GH!', by Anthony Chen", 600 + 3, 700 + 3);
    fill(255);
    textSize(32);
    text("Lead Developer: Ben Zeng", 600, 330);
    textSize(16);
    text("Based off of the card game, 'Jeu d'8GH!', by Anthony Chen", 600, 700);
  }
}
Button[] settings = new Button[2];
class Button
{
  private final int RECT_SIZE = 50;
  private final int HALF_RECT = 25;
  private final int SHADOW_OFFSET = 3;
  private final int DIAMETER = 36;
  private int x, y;
  private int scroll = -25;
  private boolean inAnimation = false;
  boolean on = true;
  public Button(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  public void onClickEvent()
  {
    if(touchingMouse() && !inAnimation) 
    {
      on = !on;
      inAnimation = true;
    }
  }
  public void drawButton()
  {
    rectMode(CENTER);
    ellipseMode(CENTER);
    noStroke();
    // Shadow
    fill(110, 190);
    rect(x + SHADOW_OFFSET, y + SHADOW_OFFSET, RECT_SIZE, DIAMETER);
    arc(x - HALF_RECT + SHADOW_OFFSET, y + SHADOW_OFFSET, DIAMETER, DIAMETER, HALF_PI, HALF_PI * 3);
    arc(x + HALF_RECT + SHADOW_OFFSET, y + SHADOW_OFFSET, DIAMETER, DIAMETER, -HALF_PI, HALF_PI);
    
    fill(#FFCC24, 220);
    rect(x, y, RECT_SIZE, DIAMETER);
    arc(x - HALF_RECT, y, DIAMETER, DIAMETER, HALF_PI, HALF_PI * 3);
    arc(x + HALF_RECT, y, DIAMETER, DIAMETER, -HALF_PI, HALF_PI);
    
    fill(#FFE89B);
    ellipse(x + scroll, y, 27, 27);
    textSize(18);
    if(on)
    {
      textAlign(CENTER, CENTER);
      text("ON!", x + 16, y);
    }
    else
    {
      textAlign(CENTER, CENTER);
      text("OFF!", x - 16, y);
    }
    if(inAnimation) animate();
  }
  private void animate()
  {
    if(on)
    {
      scroll -= 5;
      if(scroll <= -HALF_RECT) inAnimation = false;
    }
    else
    {
      scroll += 5;
      if(scroll >= HALF_RECT) inAnimation = false;
    }
  }
  private boolean touchingMouse()
  {
    boolean touchingArc1 = dist(mouseX, mouseY, x - HALF_RECT, y) <= DIAMETER / 2; 
    boolean touchingArc2 = dist(mouseX, mouseY, x + HALF_RECT, y) <= DIAMETER / 2; 
    boolean touchingRect = mouseX >= x - HALF_RECT && mouseX <= x + HALF_RECT && mouseY >= y - DIAMETER / 2 && mouseY <= y + DIAMETER / 2;
    return touchingArc1 || touchingArc2 || touchingRect;
  }
}
