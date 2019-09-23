void victory()
{
  playFieldSelected = -1;
  cardSelected = -1;
  playerSelected = false;
  abilitySelected = -1;
  play(); // In Background...
  rectMode(CENTER);
  noStroke();
  fill(100, 220);
  rect(600, 400, 1200, 800);
  // Logo
  noStroke();
  fill(#FFB593, 100);
  rect(600, 400, 800, 150);
  fill(100, 190);
  rect(600 + 3, 325 + 3, 800, 10);
  rect(600 + 3, 475 + 3, 800, 10);
  fill(255);
  rect(600, 325, 800, 10);
  rect(600, 475, 800, 10);
  
  textAlign(LEFT, CENTER);
  textSize(44);
  fill(100, 190);
  text("-  V  I  C  T  O  R  Y  !  -", 220 + 3, 375 + 3);
  fill(255);
  text("-  V  I  C  T  O  R  Y  !  -", 220 , 375);
  
  textAlign(RIGHT, CENTER);
  textSize(27);
  fill(100, 190);
  text("E L I T E  P R O D U C T I O N S", 980 + 3, 435 + 3);
  fill(#FF932E);
  text("E L I T E  P R O D U C T I O N S", 980 , 435);
  
  // Back button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(1200 - 50 + 3, 50 + 3, 90, 90); // Shadow
  textSize(20);
  fill(100, 180);
  text("BACK..", 1200 - 50 + 3, 50 + 3);
  
  if(dist(mouseX, mouseY, 1150, 50) < 45) // Highlights Button
    stroke(0xff8FA5FC, 150);
  else
    stroke(255);
  noFill();
  ellipse(1200 - 50, 50, 90, 90); // Real
  fill(255);
  text("BACK..", 1200 - 50, 50);
}
