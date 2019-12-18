/*
Table of Contents:
 7 - 300: General Decoration
 301 - 343: Animations (Specifically Moving)
 344 - 409: Drawing cards on playfield. This requires accounting for cards' who have abilities that do not permanently change a card's stats, in order to properly display their stats.
 410 - 449: Drawing cards in hand. Easy and Simple, no special things needed.
 450 - 529: Drawing the selected card (HAND)'s special stats, such as categories, ability, etc.
 530 - 785: Drawing the selected card in playfield's special things. This includes effects, ACTIONS (Like moving, attacking), Hitcircles when in attacking or moving move, etc.
 If you want to add a new action for a card, scroll to 631. This is where Hubert, Ethan, Ms. Iceberg, and Neil's special actions are displayed. In terms of the actual input and button pressing logic, NOTHING is neccesary, unless there are special conditions for which cards can be targeted. In that case, go to Input Line 80.
 786 - 817: Player attacking, and targeted effects upon spawning.
 818 - 1011: General Design for circles and cards.
 1012 - End: Placing card logic. NOT the effects! This only checks if you can place the card or not. 
 */
public void play()
{  
  timer++;
  textAlign(CENTER, CENTER);
  if (mode == 0 && !inTransition) // Victory
  {
    if (p[1].HP <= 0 || p[2].HP <= 0)
    {
      transitionTime = 0; 
      inTransition = true; 
      transitionToMode = 10;
    }
  }
  checkDeaths();
  draggingCards();
  if (needToFinishAnimate)
    finishAnimate();
  if (inAnimation)
    aniTimer++;
  if (moveAnimation)
    moveAniTimer++;
  // BASIC GRAPHICS
  background(menuBG);

  tint(255, 160);
  image(playFieldIcon, 350, 400);
  noTint();

  rectMode(CORNER);
  noStroke();
  
  if (playerSelected && mode == 0) 
  {
    fill(255, 0, 0, (sin(timer / 10.0) + 1) * 50 + 60); 
    rect(100, 400, 500, 300);
  }
  else
  {
    if (cardSelected != -1 && animationOn())
    {
      if (!p[playerTurn].hand.get(cardSelected).isSpell && p[playerTurn].cash >= p[playerTurn].hand.get(cardSelected).cost)
      {
        boolean canPlaceDown = true;
        boolean hasExpensiveCard = false;
        for (Card c : playField)
        {
          int temp = resetCard(p[playerTurn].hand.get(cardSelected)).cost;
          if (c.name.equals("Snake") && c.player == playerTurn)
          {
            if (temp < 5)
              canPlaceDown = false;
          }
          if (c.cost >= 5 && c.player == playerTurn) hasExpensiveCard = true;
        }
        if (p[playerTurn].hand.get(cardSelected).name.equals("UNNAMED") && !hasExpensiveCard) canPlaceDown = false;
        if (canPlaceDown) fill(#FFB700, (sin(timer / 10.0) + 1) * 120);
        else fill(#FF0000, (sin(timer / 10.0) + 1) * 60);
      }
      else noFill();
    }
    else 
      fill(#FFB700, 200);  
    rect(100, 600, 500, 100);
  }

  // Player Attacking
  rectMode(CENTER);
  textSize(14);
  // Shadow
  noStroke();
  fill(100, 190);
  rect(203, 736, 170, 30);

  fill(100, 190);
  text("PLAYER "+playerTurn+" (You!)", 203, 736);

  // Not Shadow
  if (p[playerTurn].canAttack)
  {
    if (playerTurn == 1)
      fill(#FF5555, 150);
    else 
      fill(#5A55FF, 150);
  } else fill(150, 170);
  strokeWeight(3);
  if (p[playerTurn].canAttack)
  {
    if (playerTurn == 1)
      stroke(#C40A04, 150);
    else 
    stroke(#0904C4, 150);
  } else stroke(100, 220);

  rect(200, 733, 170, 30);
  if(playerSelected) 
  {
    if(mode == 0)
    {
      noStroke();
      fill(#761717, 150);
      rect(200, 733, 170, 30);
      
      strokeWeight(20);
      if(animationOn())
      {
        fill(0xffFFC400, 170 + (sin(timer / 10.00) + 1) * 60);
        stroke(0xffFFC400, 120 + (sin(timer / 10.00) + 1) * 60);
      }
      else
      {
        fill(0xffFFC400, 170);
        stroke(0xffFFC400, 120);
      }
      ellipse(350, 747, 80, 80);
    }
    else
    {
      strokeWeight(20);
      if(animationOn())
      {
        fill(0xffFFC400, 170 + (sin(timer / 10.00) + 1) * 60);
        stroke(0xffFFC400, 120 + (sin(timer / 10.00) + 1) * 60);
      }
      else
      {
        fill(0xffFFC400, 170);
        stroke(0xffFFC400, 120);
      }
      ellipse(350, 50, 80, 80);
    }
  }

  fill(255);
  text("ATTACK WITH PLAYER!", 200, 733);

  // 
  if (animationOn())
  {
    tint(100, 190);
    image(health, 353, 56, 5 * (sin(timer / 10.00) + 1) + 60, 5 * (sin(timer / 10.00) + 1) + 60);
    image(health, 353, 746, 5 * (sin(timer / 10.00) + 1) + 60, 5 * (sin(timer / 10.00) + 1) + 60);
    noTint();
    image(health, 350, 53, 5 * (sin(timer / 10.00) + 1) + 60, 5 * (sin(timer / 10.00) + 1) + 60);
    image(health, 350, 743, 5 * (sin(timer / 10.00) + 1) + 60, 5 * (sin(timer / 10.00) + 1) + 60);
  } else
  {
    tint(100, 190);
    image(health, 353, 56, 60, 60);
    image(health, 353, 746, 60, 60);
    noTint();
    image(health, 350, 53, 60, 60);
    image(health, 350, 743, 60, 60);
  }

  noStroke();
  fill(100, 190);
  if (animationOn())
  {
    ellipse(53, 403, 83 + 5 * sin(timer / 13.00), 83 + 5 * sin(timer / 13.00));
    stroke(255);
    strokeWeight(3);
    fill(#FFC548, 190);
    ellipse(50, 400, 80 + 5 * sin(timer / 13.00), 80 + 5 * sin(timer / 13.00));
  } else
  {
    ellipse(53, 403, 83, 83);
    stroke(255);
    strokeWeight(3);
    fill(#FFC548, 190);
    ellipse(50, 400, 80, 80);
  }

  textSize(24);
  fill(100, 190);
  text("$"+p[playerTurn].cash, 53, 403);
  text(p[playerTurn].HP, 353, 743); 
  text(p[playerTurn % 2 + 1].HP, 353, 53); 
  text("Cards:", 903, 53);
  fill(255);
  text("$"+p[playerTurn].cash, 50, 400);
  text(p[playerTurn].HP, 350, 740); 
  text(p[playerTurn % 2 + 1].HP, 350, 50); 
  text("Cards:", 900, 50);

  // You and Opponent

  textSize(14);
  // Shadow
  noStroke();
  fill(100, 190);
  rect(203, 56, 150, 30);

  fill(100, 190);
  text("PLAYER "+(playerTurn % 2 + 1), 203, 56);

  fill(100, 190);
  rect(503, 736, 150, 30);

  fill(100, 190);
  text("PLAYER "+playerTurn+" (You!)", 503, 736);

  // Not Shadow
  if (playerTurn == 2)
    fill(#FF5555, 150);
  else 
  fill(#5A55FF, 150);
  strokeWeight(3);
  if (playerTurn == 2)
    stroke(#C40A04, 150);
  else 
  stroke(#0904C4, 150);
  rect(200, 53, 150, 30);

  fill(255);
  text("PLAYER "+(playerTurn % 2 + 1), 200, 53);

  if (playerTurn == 1)
    fill(#FF5555, 150);
  else 
  fill(#5A55FF, 150);
  strokeWeight(3);
  if (playerTurn == 1)
    stroke(#C40A04, 150);
  else 
  stroke(#0904C4, 150);
  rect(500, 733, 150, 30);

  fill(255);
  text("PLAYER "+playerTurn+" (You!)", 500, 733);


  // Back button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(1200 - 50 + 3, 50 + 3, 90, 90); // Shadow
  textSize(20);
  fill(100, 180);
  text("BACK..", 1200 - 50 + 3, 50 + 3);

  if (dist(mouseX, mouseY, 1150, 50) < 45) // Highlights Button
    stroke(0xff8FA5FC, 150);
  else
    stroke(255);
  noFill();
  ellipse(1200 - 50, 50, 90, 90); // Real
  fill(255);
  text("BACK..", 1200 - 50, 50);

  // Clear card button
  textAlign(CENTER, CENTER);
  strokeWeight(8);
  noFill();
  stroke(100, 180);
  ellipse(900 + 3, 550 + 3, 90, 90); // Shadow
  textSize(12);
  fill(100, 180);
  text("DISCARD & CYCLE ($"+(discardsUsed + 2)+")", 900 + 3, 550 + 3, 100, 100);

  if (dist(mouseX, mouseY, 900, 550) < 45) // Highlights Button
    stroke(0xff8FA5FC, 150);
  else
    stroke(255);
  noFill();
  ellipse(900, 550, 90, 90); // Real
  fill(255);
  text("DISCARD & CYCLE ($"+(discardsUsed + 2)+")", 900, 550, 100, 100);
  //900, 550
  // Timer for Game
  strokeWeight(3);

  rectMode(CENTER);
  stroke(100, 180);
  fill(100, 180);
  rect(600 + 3, 50 + 3, 120, 30); // Shadow

  stroke(255);
  fill(#CB9F0C);
  rect(600, 50, 120, 30); // Real

  // Displays Time Left

  textSize(16);
  fill(255);
  int minsLeft = timer / 3600;
  int secsLeft = timer / 60 - (minsLeft * 60);
  if (secsLeft >= 10)
    text("Time: "+minsLeft+":"+secsLeft, 600, 50);
  else
    text("Time: "+minsLeft+":0"+secsLeft, 600, 50);

  // Drawing the grid
  pushMatrix(); // SHADOW
  translate(3, 3);
  textAlign(CENTER, CENTER);
  strokeWeight(7);
  stroke(100, 190);
  noFill();
  rectMode(CORNER);
  rect(100, 100, 500, 600);
  for (int i = 0; i < 4; i++)
  {
    line(200 + 100 * i, 100, 200 + 100 * i, 700);
  }
  for (int i = 0; i < 5; i++)
  {
    line(100, 200 + 100 * i, 600, 200 + 100 * i);
  }
  popMatrix();

  textAlign(CENTER, CENTER); // NOT SHADOW
  stroke(255);
  rectMode(CORNER);
  rect(100, 100, 500, 600);
  for (int i = 0; i < 4; i++)
  {
    line(200 + 100 * i, 100, 200 + 100 * i, 700);
  }
  for (int i = 0; i < 5; i++)
  {
    line(100, 200 + 100 * i, 600, 200 + 100 * i);
  }

  rectMode(CENTER);
  strokeWeight(3);
  fill(100, 30);
  strokeWeight(10);
  stroke(100, 190);
  rect(900 + 3, 700 + 3, 400, 130);

  fill(100, 190);
  textSize(18);
  text("Round "+p[playerTurn].turn, 900 + 3, 610 + 3);
  textSize(48);
  text("Hand Over Turn!", 900 + 3, 700 + 3);

  fill(255, 50);
  strokeWeight(10);
  stroke(255);
  rect(900, 700, 400, 130);

  fill(255);
  textSize(18);
  text("Round "+p[playerTurn].turn, 900, 610);
  textSize(48);
  text("Hand Over Turn!", 900, 700);

  for (Card c : playField) // Default display positions
  {
    c.displayY = c.y * 100 + 50; 
    if (playerTurn == 2) c.displayY = c.y * -100 + 750;
    c.displayX = c.x * 100 + 50;
  }

  ArrayList<moveAnimation> removeMoves = new ArrayList<moveAnimation>();
  boolean finishedAllMoves = true;
  if (moveAnimation) // This (MOVING) is a very different type of animation than everything else. Changes to a new display position
  {
    for (moveAnimation m : moveTargets)
    {
      Card moving = playField.get(m.index);
      if (!m.toSide)
      {
        // Overriding the display positions if the card is being moved
        moving.displayY = m.originalPos * 100 + 50; 
        if (playerTurn == 2) moving.displayY = m.originalPos * -100 + 750;
        int destination = (m.originalPos + m.distance) * 100 + 50; 
        if (playerTurn == 2) destination = (m.originalPos + m.distance) * -100 + 750;
        int multiplier;
        if (m.distance < 0) multiplier = -20; 
        else multiplier = 20;
        if (playerTurn == 2) multiplier *= -1;
        moving.displayY += multiplier * moveAniTimer;
        if (moving.displayY == destination)
          removeMoves.add(m);
        else finishedAllMoves = false;
      } else
      {
        moving.displayX = m.originalPos * 100 + 50;
        int destination = (m.originalPos + m.distance) * 100 + 50;
        int multiplier;
        if (m.distance < 0) multiplier = -20; 
        else multiplier = 20;
        moving.displayX += multiplier * moveAniTimer;
        if (moving.displayX == destination)
          removeMoves.add(m);
        else finishedAllMoves = false;
      }
    }
    for (moveAnimation m : removeMoves) // Once each individual move animation is finished, remove it from the target list.
      moveTargets.remove(m);
  }

  if (finishedAllMoves)
  {
    moveAnimation = false;
    moveTargets.clear();
  }

  // Drawing cards on playfield

  for (Card c : playField)
  {
    int atk = calculateAttack(c); 
    int rng = calculateRange(c); 
    int mvmt = calculateMovement(c); // Applying temporary card buffs. 
    
    // Setting the display position of the cards being drawn

    if (playField.indexOf(c) == playFieldSelected) 
    {
      strokeWeight(20); // Bigger Strokeweight
      stroke(0xffFFC400, 220);
    } else
    {
      strokeWeight(3); // Normal Strokeweight
      stroke(255);
    }

    if (c.player == 1)
      fill(255, 0, 0, 75);
    else
      fill(0, 0, 255, 125);
    rect(c.displayX, c.displayY, 95, 95);

    cardDisplay(c.displayX, c.displayY, 1, c, atk, mvmt, rng);
  }

  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  strokeWeight(15);
  if (inAnimation)
    actionAnimate();

  // Drawing cards in hand
  for (int i = 0; i < p[playerTurn].hand.size(); i++)
  {
    int x = i % 5 * 120 + 660, y = i / 5 * 120 + 150;
    if (i == cardSelected && p[playerTurn].hand.get(i).cost <= p[playerTurn].cash)
    {
      x = x + mouseX - ogx;
      y = y + mouseY - ogy;
    }

    Card c = p[playerTurn].hand.get(i);    
    cardDisplay(x, y, 1, c, 0);

    noFill();  
    noStroke();
    if (p[playerTurn].hand.get(i).cost > p[playerTurn].cash) 
    {
      fill(100, 190);
      rect(x, y, 95, 95);
    }

    if (discarding)
    {
      noFill();
      cardSelected = -1;
      strokeWeight(20);
      stroke(0xffFFC400, 150);
      rect(x, y, 95, 95);
    }
  }

  if (cardSelected != -1) // Drawing the selected card OVER everything else
  {
    int x = cardSelected % 5 * 120 + 660;
    int y = cardSelected / 5 * 120 + 150;

    if (p[playerTurn].hand.get(cardSelected).cost <= p[playerTurn].cash)
    {
      x += mouseX - ogx;
      y += mouseY - ogy;
    }

    strokeWeight(20); // Bigger Strokeweight
    stroke(0xffFFC400, 150); 

    noFill();
    rectMode(CENTER);
    rect(x, y, 95, 95);

    cardDisplay(x, y, 1, p[playerTurn].hand.get(cardSelected), 0);

    fill(100, 100);
    stroke(255);
    strokeWeight(4);
    rect(x, y + 160, 300, 200);
    textSize(12);
    fill(100, 190);
    text(p[playerTurn].hand.get(cardSelected).ability, x + 1, y + 160 + 1, 295, 195);
    fill(255);
    text(p[playerTurn].hand.get(cardSelected).ability, x, y + 160, 295, 195);

    int counter = 0;
    for (int i : p[playerTurn].hand.get(cardSelected).category)
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

    if (p[playerTurn].hand.get(cardSelected).isSpell)
    {
      if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("You")) // placed on your own cards
      {
        String name = p[playerTurn].hand.get(cardSelected).name;
        for (Card c : playField)
        {
          if (c.player == playerTurn && !hasEffect(c, "NoEffect") && !(name.equals("Defense Position") && !c.NBTTags.contains("Unhealable")) && !(name.equals("Dragon Wings") && (c.name.equals("Ultrabright"))))
            hitCircle(c.x, c.y);
        }
      } else if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("All")) // Can be placed anywhere
      {
        rectMode(CORNER);
        strokeWeight(20); // Bigger Strokeweight
        stroke(0xffFFC400, 150); 
        noFill();
        rect(100, 100, 500, 600);
        rectMode(CENTER);
      } else if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("Opp"))
      {
        for (Card c : playField)
        {
          if (c.player != playerTurn && !hasEffect(c, "NoEffect"))
            hitCircle(c.x, c.y);
        }
      }
    }
  }

  // Displaying options for the currently selected card

  if (playFieldSelected != -1)  
  {
    if (choice == -1)
    {
      fill(100, 100);
      stroke(255);
      strokeWeight(4);
      rect(900, 400, 300, 200);
      textSize(12);
      fill(100, 190);
      text(playField.get(playFieldSelected).ability, 901, 401, 295, 195); 
      fill(255);
      text(playField.get(playFieldSelected).ability, 900, 400, 295, 195); 

      int counter = 0;
      for (Effect e : playField.get(playFieldSelected).effects)
      {
        textSize(8);
        noFill();
        stroke(255);
        strokeWeight(1);
        rect(775 + (50 * counter), 475, 50, 50);
        fill(100, 190);
        text(e.name, 775 + (50 * counter) + 1, 465 + 1); 
        text(e.duration, 775 + (50 * counter) + 1, 485 + 1); 
        fill(255);
        text(e.name, 775 + (50 * counter), 465); 
        text(e.duration, 775 + (50 * counter), 485); 
        counter++;
      }

      counter = 0;
      for (int i : playField.get(playFieldSelected).category)
      {
        String categName = categNames[i];
        textSize(8);
        noFill();
        stroke(255);
        strokeWeight(1);
        rect(775 + (50 * counter), 325, 50, 50);

        fill(100, 190);
        text(categName, 775 + (50 * counter) + 1, 325 + 1); 

        fill(255);
        text(categName, 775 + (50 * counter), 325); 
        counter++;
      }
    }

    if (choice == -1 && playField.get(playFieldSelected).player == playerTurn) // Buttons
    {  

      // Move
      // Checking if there are availible slots
      boolean availibleMoveSlot = false;
      for (int n = 0; n < 4; n++)
      {
        if (n > 1 && !hasEffect(playField.get(playFieldSelected), "SideMove")) break;
        for (int j = 1; j <= calculateMovement(playField.get(playFieldSelected)); j++) // Moving
        {
          int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
          if (availibleMove(mx, my, n, j))
            availibleMoveSlot = true;
          else break;
        }
      }
      textSize(15); 
      textAlign(CENTER, CENTER);
      if (playField.get(playFieldSelected).canMove && availibleMoveSlot) // Graying out if you already moved, or there isnt anywhere to move
      {
        fill(0xffFF981A);
        stroke(0xff744908);
      } else { 
        stroke(0xff464B4D); 
        fill(0xffB6B8B9);
      }

      strokeWeight(3);
      rect(800, 535, 190, 40); 
      if (playField.get(playFieldSelected).canMove && availibleMoveSlot) fill(0xff744908); 
      else fill(0xff464B4D); 
      
      if(availibleMoveSlot)
        text("Move", 800, 535);
      else
        text("Nowhere to Move!", 800, 535);

      // Attack
      // Checking if there are availible slots
      boolean availibleAttackSlot = false;
      for (int q = 0; q < 4; q++)
      {
        int rng = calculateRange(playField.get(playFieldSelected));
        // Showing places you can attack 
        for (int i = 1; i <= rng; i++)
        {
          int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
          if (q == 0) my -= i; 
          if (q == 1) my += i; 
          if (q == 2) mx += i; 
          if (q == 3) mx -= i; // Where to attack
          if (canAttack(mx, my, q))
            availibleAttackSlot = true;
          if (!availibleAttack(mx, my, q))
            break;
        }
      }
      if (playField.get(playFieldSelected).attackCount > 0 && availibleAttackSlot) // Graying out if you already attack, or there isnt anywhere to attack
      {
        fill(0xffFF4D4D);
        stroke(0xff740808);
      } else { 
        stroke(0xff464B4D); 
        fill(0xffB6B8B9);
      }

      rect(1000, 535, 190, 40); 
      if (playField.get(playFieldSelected).attackCount > 0 && availibleAttackSlot) fill(0xff740808); 
      else fill(0xff464B4D); 
      
      if(availibleAttackSlot)
        text("Attack", 1000, 535);
      else
        text("Nothing to Attack!", 1000, 535);

      // Discard

      boolean canDiscard = !hasEffect(playField.get(playFieldSelected), "Alive");
      if ((playField.get(playFieldSelected).NBTTags.contains("SpecialMove")))
      {
        if (canDiscard)
        {
          fill(0xffB516F5);
          stroke(0xff46095F);
        } else { 
          stroke(0xff464B4D); 
          fill(0xffB6B8B9);
        }

        rect(800, 585, 190, 40); 
        if (canDiscard) fill(0xff46095F); 
        else fill(0xff464B4D); 
        text("Discard (1 Turn)", 800, 585);
      } else {
        if (canDiscard)
        {
          fill(0xffB516F5);
          stroke(0xff46095F);
        } else { 
          stroke(0xff464B4D); 
          fill(0xffB6B8B9);
        }

        rect(900, 585, 190, 40); 
        if (canDiscard) fill(0xff46095F); 
        else fill(0xff464B4D); 
        text("Discard (1 Turn)", 900, 585);
      }

      // Special
      boolean availibleSpecialSlot = false;
      // Checking if there are availible special effect slots
      for (Card c : playField)
      {
        if (canSpecial(c))
          availibleSpecialSlot = true;
      }
      String pName = playField.get(playFieldSelected).name;
      String displayText = "";
      color darker = 0;
      color lighter = 0;
      // To add new SPECIAL effects, please enter here
      if (pName.equals("Hubert")) darker = 0xff095A81; 
      if (pName.equals("Ethan")) darker = 0xff013107;
      if (pName.equals("Neil")) darker = #6C590D; 
      if (pName.equals("Ms. Iceberg")) darker = 0xff810945;
      if (pName.equals("UNNAMED")) darker = #3B1383; 
      if (pName.equals("Hubert")) lighter = 0xff03ADFF; 
      if (pName.equals("Ethan")) lighter = 0xff36A744;
      if (pName.equals("Neil")) lighter = #E3CA67; 
      if (pName.equals("UNNAMED")) lighter = #762BFA;
      if (pName.equals("Ms. Iceberg")) lighter = 0xffFF0582;
      if (pName.equals("Hubert")) displayText = "Heal"; 
      if (pName.equals("Ethan")) displayText = "Bomb";
      if (pName.equals("Neil")) displayText = "Buff"; 
      if (pName.equals("Ms. Iceberg")) displayText = "Special Attack";
      if (pName.equals("UNNAMED")) displayText = "Destroy";

      if (playField.get(playFieldSelected).NBTTags.contains("SpecialMove"))
      {
        if (playField.get(playFieldSelected).canSpecial && availibleSpecialSlot)
        {
          fill(lighter);
          stroke(darker);
        } else { 
          stroke(0xff464B4D); 
          fill(0xffB6B8B9);
        }
        rect(1000, 585, 190, 40); 
        if (playField.get(playFieldSelected).canSpecial && availibleSpecialSlot) fill(darker); 
        else fill(0xff464B4D); 
        
        if(availibleSpecialSlot)
          text(displayText, 1000, 585);
        else
          text("Nothing to target!", 1000, 585);
      }
    }

    if (choice == 0)
    {
      for (Card c : playField)
      {
        if (canSpecial(c))
          hitCircle(c.x, c.y);
      }
    }
    if (choice == 1)
    {   
      int mvmt = calculateMovement(playField.get(playFieldSelected));
      // Showing places you can move to. 
      for (int n = 0; n < 4; n++)
      {
        if (n > 1 && !hasEffect(playField.get(playFieldSelected), "SideMove")) break;
        for (int i = 1; i <= mvmt; i++) // Moving
        {
          int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
          if (availibleMove(mx, my, n, i))
          {
            int updateY = my; 
            if (n == 0) updateY -= i; 
            if (n == 1) updateY += i;
            int updateX = mx; 
            if (n == 2) updateX -= i; 
            if (n == 3) updateX += i;
            hitCircle(updateX, updateY);
          } else break;
        }
      }
    }
    // Attacking 
    if (choice == 2)
    {
      for (int q = 0; q < 4; q++)
      {
        int rng = calculateRange(playField.get(playFieldSelected));
        // Showing places you can attack 
        for (int i = 1; i <= rng; i++)
        {
          int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
          if (q == 0) my -= i; 
          if (q == 1) my += i; 
          if (q == 2) mx += i; 
          if (q == 3) mx -= i;// Where to attack
          if (canAttack(mx, my, q))
          {
            if (outOfField(mx, my, q)) 
              hitCircle(3, 0, true);
            else
              hitCircle(mx, my);
          }
          if (!availibleAttack(mx, my, q))
            break;
        }
      }
    }
  } else choice = -1;

  if (playerSelected)
  {
    for (Card c : playField)
    {
      int correctY = 6; if(playerTurn == 2) correctY = 1;
      int playerRange = 3;
      if(abs(c.y - correctY) < playerRange && c.player != playerTurn)
        hitCircle(c.x, c.y);
    }
  }

  if (abilitySelected != -1) // Jason C, Jefferson, George, Anthony, Etc.
  {
    int playerCondition;
    if (playField.get(abilitySelected).NBTTags.contains("OppTargetedEffect"))
      playerCondition = playField.get(abilitySelected).player % 2 + 1;
    else 
    playerCondition = playField.get(abilitySelected).player;
    for (Card c : playField)
    {
      boolean targetCondition = true; 
      if (playField.get(abilitySelected).name.equals("UNNAMED")) targetCondition = c.cost >= 5 && c != playField.get(abilitySelected);
      if (c.player == playerCondition && !hasEffect(c, "NoEffect") && targetCondition)
        hitCircle(c.x, c.y);
    }
  }
}

public void hitCircle(int x, int y)
{
  noFill();
  strokeWeight(15);
  stroke(100, 190);
  if (playerTurn == 1)
    ellipse(x * 100 + 50 + 3, y * 100 + 50 + 3, 80, 80);
  else
    ellipse(x * 100 + 50 + 3, y * -100 + 750 + 3, 80, 80);
  if (playerTurn == 1)
  {
    if ((dist(mouseX, mouseY, x * 100 + 50, y * 100 + 50) < 50)) stroke(170, 190); 
    else stroke(255);
  } else
  {
    if ((dist(mouseX, mouseY, x * 100 + 50, y * -100 + 750) < 50)) stroke(170, 190); 
    else stroke(255);
  }
  if (playerTurn == 1)
    ellipse(x * 100 + 50, y * 100 + 50, 80, 80);
  else
    ellipse(x * 100 + 50, y * -100 + 750, 80, 80);
}
public void hitCircle(int x, int y, boolean ignore)
{
  noFill();
  strokeWeight(15);
  stroke(100, 190);
  ellipse(x * 100 + 50 + 3, y * 100 + 50 + 3, 80, 80);
  if ((dist(mouseX, mouseY, x * 100 + 50, y * 100 + 50) < 50)) stroke(170, 190); 
  else stroke(255);
  ellipse(x * 100 + 50, y * 100 + 50, 80, 80);
}
public void cardDisplay(int x, int y, float scale, Card c, int specialCase)
{
  textAlign(CENTER, CENTER);

  pushMatrix();
  translate(x, y); // Scaling to the correct scale
  scale(scale);

  strokeWeight(3); 
  stroke(255);
  fill(150, 100);

  rectMode(CENTER);
  rect(0, 0, 95, 95); // Square Outline

  tint(255, 100);
  image(c.icon, 0, 0, 95, 95);
  noTint();
  // Icons
  imageMode(CENTER);
  textSize(12);
  int textThickness = (int) (textWidth(c.displayName) / 90) * 20 + 20;
  int co = 0; // Colour
  for (int index : c.category) co = categColour[index];
  if (co != 0)
    fill(co, 190);
  else fill(100, 190);

  boolean minimize = false;
  if (specialCase == 1) if (collectionSelected == -1) minimize = true; 
  else if (collection[collectionSelected] != c) minimize = true; // Minimizing in the deck selection

  if (c.isSpell || minimize)
    rect(0, 0 - 5, 95, textThickness);
  else
    rect(0, 0 - 20, 95, textThickness);// Name
  ellipse(0, 0 + 42, 30, 30); // Money
  if (!c.isSpell && !minimize)
  {
    image(attack, 0 - 37, 0 + 15, 25, 25);
    image(health, 0 - 12, 0 + 15, 25, 25);
    image(movement, 0 + 12, 0 + 15, 25, 25);
    image(range, 0 + 37, 0 + 15, 25, 25);
  }

  // Stats (Text)
  textSize(12);
  fill(100, 190);
  if (!c.isSpell && !minimize)
  {
    textSize(12);
    text(c.displayName, 0 + 1, 0 - 20 + 1, 90, 90);
    textSize(18);
    text(c.ATK, 0 - 37 + 2, 0 + 15 + 2);
    text(c.HP, 0 - 12 + 2, 0 + 15 + 2);
    text(c.MVMT, 0 + 12 + 2, 0 + 15 + 2);
    text(c.RNG, 0 + 37 + 2, 0 + 15 + 2);
  } else text(c.displayName, 0 + 1, 0 - 5 + 1, 90, 90);
  textSize(15);
  text("$"+c.cost, 0 + 1, 0 + 42 + 1);

  textSize(12);
  fill(255);

  if (!c.isSpell && !minimize)
  {
    textSize(12);
    text(c.displayName, 0, 0 - 20, 90, 90);
    textSize(18);
    text(c.ATK, 0 - 37, 0 + 15);
    text(c.HP, 0 - 12, 0 + 15);
    text(c.MVMT, 0 + 12, 0 + 15);
    text(c.RNG, 0 + 37, 0 + 15);
  } else text(c.displayName, 0, 0 - 5, 90, 90);
  textSize(15);

  if (cardSelected != -1) // If the card selected is the card being drawn, and you don't have enough cash.
  {
    if (p[playerTurn].cash < p[playerTurn].hand.get(cardSelected).cost && c == p[playerTurn].hand.get(cardSelected))
      fill(#FF0D00, (sin(timer / 10.0) + 1) * 100 + 40); // A red aura around the money is drawn to suggest that the card is too expensive.
  }
  text("$"+c.cost, 0, 0 + 42);
  popMatrix();
}
public void cardDisplay(int x, int y, float scale, Card c, int atk, int mvmt, int rng) // Displaying a card with special attack, movement, or range.
{
  textAlign(CENTER, CENTER);

  pushMatrix();
  translate(x, y); // Scaling to the correct scale
  scale(scale);

  strokeWeight(3); 
  stroke(255);
  fill(150, 100);

  rectMode(CENTER);
  rect(0, 0, 95, 95); // Square Outline

  tint(255, 100);
  image(c.icon, 0, 0, 95, 95);
  noTint();
  // Icons
  imageMode(CENTER);
  textSize(12);
  int textThickness = (int) (textWidth(c.displayName) / 90) * 20 + 20;
  int co = 0; // Colour
  for (int index : c.category) co = categColour[index];
  if (co != 0)
    fill(co, 190);
  else fill(100, 190);

  if (c.isSpell)
    rect(0, 0 - 5, 95, textThickness);
  else
    rect(0, 0 - 20, 95, textThickness);// Name
  ellipse(0, 0 + 42, 30, 30); // Money
  boolean cardProtected = false; // If damage will be negated
  boolean hasBen20 = false; 
  if(c.name.equals("Steven") || c.name.equals("Mandaran")) cardProtected = true;
  if(hasEffect(c, "Defense")) cardProtected = true;
  for(Card d: playField)
  {
    if(d.player == c.player)
    {
      if(!hasEffect(c, "NoEffect") && !c.NBTTags.contains("Unhealable"))
      {
        if(c.name.equals("Vinod") && d.category.contains(1) && c != d) cardProtected = true;
        if(d.name.equals("Angela") && max(abs(c.x - d.x), abs(c.y - d.y)) <= 1) cardProtected = true;
        if(d.name.equals("A.L.I.C.E.")) cardProtected = true;
      }
      if(d.name.equals("Ben 2.0") && d != c) hasBen20 = true;
    }
  }
  if (!c.isSpell)
  {
    image(attack, 0 - 37, 0 + 15, 25, 25);
    if(hasBen20)
      image(lock, 0 - 12, 0 + 8, 38, 38);
    else 
    {
      image(health, 0 - 12, 0 + 15, 25, 25);
      if(cardProtected)
        image(shield, 0 - 12, 0 + 10, 23, 23);
    }
    image(movement, 0 + 12, 0 + 15, 25, 25);
    image(range, 0 + 37, 0 + 15, 25, 25);
  }

  // Stats (Text)
  textSize(12);
  fill(100, 190);
  if (!c.isSpell)
  {
    textSize(12);
    text(c.displayName, 0 + 1, 0 - 20 + 1, 90, 90);
    textSize(18);
    text(atk, 0 - 37 + 2, 0 + 15 + 2);
    text(c.HP, 0 - 12 + 2, 0 + 15 + 2);
    text(mvmt, 0 + 12 + 2, 0 + 15 + 2);
    text(rng, 0 + 37 + 2, 0 + 15 + 2);
  } else text(c.displayName, 0 + 1, 0 - 5 + 1, 90, 90);
  textSize(15);
  text("$"+c.cost, 0 + 1, 0 + 42 + 1);

  textSize(12);
  fill(255);

  if (!c.isSpell)
  {
    textSize(12);
    text(c.displayName, 0, 0 - 20, 90, 90);
    textSize(18);
    text(atk, 0 - 37, 0 + 15);
    text(c.HP, 0 - 12, 0 + 15);
    text(mvmt, 0 + 12, 0 + 15);
    text(rng, 0 + 37, 0 + 15);
  } else text(c.displayName, 0, 0 - 5, 90, 90);
  textSize(15);

  if (cardSelected != -1) // If the card selected is the card being drawn, and you don't have enough cash.
  {
    if (p[playerTurn].cash < p[playerTurn].hand.get(cardSelected).cost && c == p[playerTurn].hand.get(cardSelected))
      fill(#FF0D00, (sin(timer / 10.0) + 1) * 100 + 40); // A red aura around the money is drawn to suggest that the card is too expensive.
  }
  text("$"+c.cost, 0, 0 + 42);
  popMatrix();
}

public void draggingCards()
{
  int x = cardSelected % 5 * 120 + 660, y = cardSelected / 5 * 120 + 150;
  // Setting x (Position of card that is being dragged)
  if (cardSelected != -1)
  {
    x += mouseX - ogx;
    y += mouseY - ogy;
  }

  if (!mousePressed && cardSelected != -1) // When a card is released
  {
    boolean spaceEmpty = true;
    for (int i = 0; i<playField.size(); i++) // Checks if the place which the card is at already contains a card
    {
      if (playerTurn == 1)
      {
        if (((x / 100 - 1) % 5 + 1) == playField.get(i).x && ((y / 100 - 1) + 1) == playField.get(i).y)
          spaceEmpty = false;
      } else
      {
        if (((x / 100 - 1) % 5 + 1) == playField.get(i).x && (6 - (y / 100 - 1)) == playField.get(i).y)
          spaceEmpty = false;
      }
    }

    boolean canPlaceDown = true;
    boolean hasExpensiveCard = false;
    // Figuring out whether not a given card can be placed
    if (p[playerTurn].hand.get(cardSelected).name.equals("UNNAMED") && !hasExpensiveCard) canPlaceDown = false;
    for (Card c : playField)
    {
      int temp = resetCard(p[playerTurn].hand.get(cardSelected)).cost;
      if (c.name.equals("Snake") && c.player == playerTurn)
      {
        if (temp < 5)
          canPlaceDown = false;
      }
      if (c.cost >= 5 && c.player == playerTurn) hasExpensiveCard = true;
    }
    
    if (p[playerTurn].hand.get(cardSelected).isSpell && p[playerTurn].hand.get(cardSelected).cost <= p[playerTurn].cash && canPlaceDown)
    {
      if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("All"))
      {
        if (x < 600 && x > 100 && y > 100 && y < 700)
        {
          removeFromHand(playerTurn, cardSelected);
          useSpell(playerTurn, p[playerTurn].hand.get(cardSelected).name);
        }
      } 
      else // bad coding ben 
      {
        if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("You")) // placed on your own cards
        {
          String name = p[playerTurn].hand.get(cardSelected).name;
          for (Card c : playField)
          {
            if (c.player == playerTurn && !hasEffect(c, "NoEffect") && !(p[playerTurn].hand.get(cardSelected).NBTTags.contains("AttackBoostSpell") && c.NBTTags.contains("Unbuffable")) && !(name.equals("Defense Position") && c.NBTTags.contains("Unhealable")) && !(name.equals("Dragon Wings") && (c.name.equals("Ultrabright"))))
            {
              int yPos = c.y * 100 + 50; 
              if (playerTurn == 2) yPos = c.y * -100 + 750;
  
              if (dist(c.x * 100 + 50, yPos, mouseX, mouseY) < 50)
              {
                useSpell(p[playerTurn].hand.get(cardSelected).name, playField.indexOf(c));
                removeFromHand(playerTurn, cardSelected);
                break;
              }
            }
          }
        } 
        else if (p[playerTurn].hand.get(cardSelected).spellTarget.equals("Opp"))
        {
          for (Card c : playField)
          {
            if (c.player != playerTurn && !hasEffect(c, "NoEffect"))
            {
              int yPos = c.y * 100 + 50; 
              if (playerTurn == 2) yPos = c.y * -100 + 750;
  
              if (dist(c.x * 100 + 50, yPos, mouseX, mouseY) < 50)
              {
                useSpell(p[playerTurn].hand.get(cardSelected).name, playField.indexOf(c));
                removeFromHand(playerTurn, cardSelected);
                break;
              }
            }
          }
        }
      }
    } 
    else if (x < 600 && x > 100 && y > 600 && y < 700 && p[playerTurn].hand.get(cardSelected).cost <= p[playerTurn].cash && canPlaceDown && spaceEmpty) // Places the card down if it's in a valid spot
    {
      int tempy;
      if (playerTurn == 1) tempy = (y / 100 - 1) + 1; 
      else tempy = 6 - (y / 100 - 1);

      placeCard(playerTurn, p[playerTurn].hand.get(cardSelected), (x / 100 - 1) % 5 + 1, tempy, false);
      removeFromHand(playerTurn, cardSelected);
    }
    cardSelected = -1; // Sets no card to be selected
  }
}

private void removeFromHand(int playerTurn, int cardSelected)
{
  p[playerTurn].cash -= p[playerTurn].hand.get(cardSelected).cost;   
  if(!p[playerTurn].hand.get(cardSelected).summoned)
    p[playerTurn].deck.add(resetCard(p[playerTurn].hand.get(cardSelected)));
  p[playerTurn].hand.remove(cardSelected);
}
