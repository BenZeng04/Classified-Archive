int mouseX;
int mouseY;
public void mousePressed()
{
if(mode == 0 && clickDelay == 0 && !inAnimation && !moveAnimation && !inTransition)
{
  if(abilitySelected == -1)
  {
    for(int i = 0; i < p[playerTurn].hand.size(); i++)
    {
      int x, y;
      if(playerTurn == 1)
      {
        x = i % 5 * 120 + 670; y = i / 5 * 120 + 150;
      }
      else 
      {
        x = i % 5 * 120 + 670; y = i / 5 * 120 + 150;
      }
        
      if(i == cardSelected && p[playerTurn].hand.get(i).cost <= p[playerTurn].cash)
      {
        x = x + mouseX - ogx;
        y = y + mouseY - ogy;
      }
      if(mouseX < x + 50 && mouseX > x - 50 && mouseY < y + 50 && mouseY > y - 50 && cardSelected == -1)
      {
        cardSelected = i;
        ogx = mouseX;
        ogy = mouseY;
        break;
      }
    }
    boolean temporary = true; // If pressing a choice button, the playFieldSelected isn't gonna reset.
    if(playFieldSelected != -1)
    { 
      if(choice == -1 && playField.get(playFieldSelected).player == playerTurn) // Buttons Omegalul for CHOICES
      {  
        //Move  
        if(mouseX > 705 && mouseX < 895 && mouseY > 515 && mouseY < 555 && playField.get(playFieldSelected).canMove)
        {
          choice = 1;
          temporary = false;
        }
        //attack
        if(mouseX > 905 && mouseX < 1095 && mouseY > 515 && mouseY < 555 && playField.get(playFieldSelected).attackCount > 0)
        {
          choice = 2;
          temporary = false;
        }
        
        if(playField.get(playFieldSelected).NBTTags.contains("SpecialMove"))
        {
          if(mouseX > 905 && mouseX < 1095 && mouseY > 565 && mouseY < 605 && playField.get(playFieldSelected).canSpecial)
          {
            choice = 0;
            temporary = false;
          }
          if(mouseX > 705 && mouseX < 895 && mouseY > 565 && mouseY < 605 && !hasEffect(playField.get(playFieldSelected), "Alive"))
          {
            discard(playFieldSelected);
            temporary = false;
          }
        }
        else
        {
          if(mouseX > 805 && mouseX < 995 && mouseY > 565 && mouseY < 605 && !hasEffect(playField.get(playFieldSelected), "Alive"))
          {
            discard(playFieldSelected);
            temporary = false;
          }
        }
      }
      // No Special Effects. Only attack and move.
      if(choice == 0 && playField.get(playFieldSelected).player == playerTurn)
      {
        for(Card c: playField)
        {
          int sideTarget;
          if(playField.get(playFieldSelected).name.equals("Hubert") || playField.get(playFieldSelected).name.equals("Neil")) sideTarget = playField.get(playFieldSelected).player; else sideTarget = playField.get(playFieldSelected).player % 2 + 1;
          boolean condition = true;
          if(playField.get(playFieldSelected).name.equals("Hubert")) condition = !c.NBTTags.contains("Unhealable");
          if(playField.get(playFieldSelected).name.equals("Ethan")) condition = c.cost < 5;
          if(c.player == sideTarget && !hasEffect(c, "NoEffect") && condition)
          {
            int yOfCircle = c.y * 100 + 50; if(playerTurn == 2) yOfCircle = c.y * -100 + 750;
            if(dist(c.x * 100 + 50, yOfCircle, mouseX, mouseY) < 50)
            {
              specialAbility(playFieldSelected, playField.indexOf(c), playField.get(playFieldSelected).name);
              playField.get(playFieldSelected).canSpecial = false;
              choice = -1;
              temporary = false;
              break;
            }
          }
        }
      }
      
      if(choice == 1)
      {
        int mvmt = playField.get(playFieldSelected).MVMT;
        if(hasEffect(playField.get(playFieldSelected), "Slowdown")) mvmt -= 1; 
        for(int n = 0; n < 4; n++)
        {
          if(n > 1 && !hasEffect(playField.get(playFieldSelected), "SideMove")) break;
          for(int j = 1; j <= mvmt; j++) // Moving
          {
            int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
            boolean availible = true;
            if(playField.get(playFieldSelected).player != playerTurn)
              break;
            for(Card c: playField)
            {
              if(n == 0)
              {         
                if(c.x == mx && c.y == my - j || my <= j)
                  availible = false;
              }
              if(n == 1)
              {
                if(c.x == mx && c.y == my + j || my + j > 6)
                  availible = false;
              }
              if(n == 2)
              {
                if(c.x == mx - j && c.y == my || mx <= j)
                  availible = false;
              }
              if(n == 3)
              {
                if(c.x == mx + j && c.y == my || mx + j > 5)
                  availible = false;
              }
            }
            if(availible)
            {
              int updateY = my; if(n == 0) updateY -= j; if(n == 1) updateY += j;
              int updateX = mx; if(n == 2) updateX -= j; if(n == 3) updateX += j;
              if(playerTurn == 1)
              {
                if(dist(mouseX, mouseY, updateX * 100 + 50, updateY * 100 + 50) < 50)
                {
                  Move m = new Move();
                  m.type = 5;
                  m.targeter = playFieldSelected;
                  if(n == 0)
                  {
                    m.distance = -j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, -j);
                  }
                  if(n == 1)
                  {
                    m.distance = j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, j);
                  }
                  if(n == 2)
                  {
                    m.distance = -j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, -j);
                  }
                  if(n == 3)
                  {
                    m.distance = j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, j);
                  }
                  moves.add(m);
                  playField.get(playFieldSelected).canMove = false;
                  if(!playField.get(playFieldSelected).name.equals("Simon"))
                    playField.get(playFieldSelected).attackCount = 0;
                  choice = -1;
                  temporary = false;
                }
              }
              else
              {
                if(dist(mouseX, mouseY, updateX * 100 + 50, updateY * -100 + 750) < 50)
                {
                  Move m = new Move();
                  m.type = 5;
                  m.targeter = playFieldSelected;
                  if(n == 0)
                  {
                    m.distance = -j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, -j);
                  }
                  if(n == 1)
                  {
                    m.distance = j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, j);
                  }
                  if(n == 2)
                  {
                    m.distance = -j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, -j);
                  }
                  if(n == 3)
                  {
                    m.distance = j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, j);
                  }
                  moves.add(m);
                  playField.get(playFieldSelected).canMove = false;
                  if(!playField.get(playFieldSelected).name.equals("Simon"))
                    playField.get(playFieldSelected).attackCount = 0;
                  choice = -1;
                  temporary = false;
                }
              }
            }
            else break;
          }
        }
        
      }
      // Attacking
      if(choice == 2)
      {
        for(int q = 0; q < 4; q++)
        {
          int rng = playField.get(playFieldSelected).RNG;
          for(Card d: playField)
          {
            if(d.name.equals("Mandaran") && max(abs(playField.get(playFieldSelected).x - d.x), abs(playField.get(playFieldSelected).y - d.y)) <= 1 && playField.get(playFieldSelected).category.contains(4) && d.player == playField.get(playFieldSelected).player) 
            {
              if(!playField.get(playFieldSelected).name.equals("Ultrabright"))
                rng += 1;
            }
            if(d.name.equals("Ridge Rhea") && playField.get(playFieldSelected) != d && !playField.get(playFieldSelected).name.equals("Ultrabright") && d.player == playField.get(playFieldSelected).player && d.x == playField.get(playFieldSelected).x) rng += 2;
          }
          if(hasEffect(playField.get(playFieldSelected), "NVW")) rng++;
          // Showing places you can attack 
          for(int i = 1; i <= rng; i++) //
          {
            int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
            int takeHit = 0; // Getting attacked
            boolean canAttack = false;
            boolean availible = true; // Availible doesnt mean that you can attack that spot, it just means that it won't quit.
            boolean cap; if(q == 0) cap = my <= i; else if(q == 1) cap = my + i > 6; else if(q == 2) cap = mx + i > 5; else cap = mx <= i; // If attacking player
            if(q == 0) my -= i; if( q == 1) my += i; if(q == 2) mx += i; if(q == 3) mx -= i;// Where to attack
            if(playField.get(playFieldSelected).player != playerTurn)
              break;
            if(cap)
            {
              boolean firstTurn = true;
              if(playField.get(playFieldSelected).turnPlacedOn != p[playerTurn].turn || (playField.get(playFieldSelected).name.equals("Mr. Pegamah"))) { firstTurn = false;}
              
              if((playerTurn == 1 && q == 0) || (playerTurn == 2 && q == 1))
              {
                if(firstTurn)
                  canAttack = false;
                else
                  canAttack = true; // Attacking the player 
              }
              availible = false;
            }

            for(Card c: playField)
            {
              if(c.x == mx && c.y == my)
              {
                if((!playField.get(playFieldSelected).name.equals("Matthew") && !playField.get(playFieldSelected).name.equals("Ultrabright")) && c.player != playerTurn)
                  availible = false;
                if(c.player != playerTurn)
                {
                  canAttack = true; // Basically finds closest card that isnt yours. 
                  takeHit = playField.indexOf(c);
                }
                if(hasEffect(c, "Invincible")) canAttack = false;
              }      
            }
            
            if(canAttack) 
            {
              int opp = playerTurn % 2 + 1;
              if(cap) // Attacking Player 
              {
                if(dist(mouseX, mouseY, 350, 50) < 50)
                {
                  choice = -1;
                  temporary = false;
                  if(!playField.get(playFieldSelected).name.equals("Simon"))
                    playField.get(playFieldSelected).canMove = false; 
                  playField.get(playFieldSelected).attackCount --;
                  attackPlayer(playFieldSelected);
                }
              }
              else
              {
                
                int yBound; if(playerTurn == 1) yBound = my * 100 + 50; else yBound = my * -100 + 750;
                if(dist(mouseX, mouseY, mx * 100 + 50, yBound) < 50)
                {
                  choice = -1;
                  temporary = false;
                  if(mode == 0)
                  {
                    Move m = new Move();
                    m.type = 4;
                    m.targeter = playFieldSelected;
                    m.targeted = takeHit;
                    m.x = playField.get(playFieldSelected).x;
                    m.y = playField.get(playFieldSelected).y;
                    m.name = playField.get(playFieldSelected).name;
                    moves.add(m);
                  }
                  if(!playField.get(playFieldSelected).name.equals("Simon"))
                    playField.get(playFieldSelected).canMove = false; 
                  playField.get(playFieldSelected).attackCount --;
                  attackCard(playFieldSelected, takeHit, true);
                  
                  // Antnohy effect 
                  if(playField.get(playFieldSelected).name.equals("Antnohy") && !hasEffect(playField.get(takeHit), "Invincible"))
                  {
                    int x = playField.get(takeHit).x, y = playField.get(takeHit).y;
                    for(int l = 0; l < 9; l++)
                    {
                      if(l != 4)
                      {
                        int tx = x + l % 3 - 1;
                        int ty = y + l / 3 - 1;
                        if(findCard(tx, ty, opp) != -1)
                          attackCard(playFieldSelected, findCard(tx, ty, opp), true);
                      }
                    }
                  }
                  if(playField.get(playFieldSelected).name.equals("GeeTraveller") && !hasEffect(playField.get(takeHit), "Invincible"))
                  {
                    int x = playField.get(takeHit).x, y = playField.get(takeHit).y;
                    for(int l = 1; l <= 6; l++)
                      if(l != y)                     
                        if(findCard(x, l, opp) != -1)
                          attackCard(playFieldSelected, findCard(x, l, opp), true);
                  }
                }
              }
            }
            if(!availible)
            {
              break;
            }
          }
        }
      }
      
      }
      for(int i = 0; i < playField.size(); i++)
      {
        int x = playField.get(i).x * 100 + 50, y = playField.get(i).y * 100 + 50;
        if(playerTurn == 2)
          y = playField.get(i).y * -100 + 750;
        
        if(mouseX < x + 50 && mouseX > x - 50 && mouseY < y + 50 && mouseY > y - 50)
        {
          if(temporary)
          {
            playFieldSelected = i;
            choice = -1;
          }
          break;
        }
        else if(temporary)
        {
          playFieldSelected = -1;
          choice = -1;
        }
      }
      if(mouseX < 1100 && mouseX > 700 && mouseY < 765 && mouseY > 635)
        handOverTurn();
      if(playerSelected)
      {
        for(Card c: playField)
        {
          int correctY = 6; if(playerTurn == 2) correctY = 1;
          if(c.y == correctY && c.player != playerTurn)
          {
            int yPos = c.y * 100 + 50; if(playerTurn == 2) yPos = c.y * -100 + 750;
            if(dist(mouseX, mouseY, c.x * 100 + 50, yPos) < 50)
            {
              attackCard(-1, playField.indexOf(c), true);
              Move m = new Move();
              m.type = 4;
              m.targeter = -1;
              m.targeted = playField.indexOf(c);
              moves.add(m);
              p[playerTurn].canAttack = false;
              break;
            }
          }
        }
        playerSelected = false;
      }
      if(mouseX > 115 && mouseX < 285 && mouseY > 718 && mouseY < 748 && p[playerTurn].canAttack)
        playerSelected = true;
    }
    else
    {
      int condition;
      if(playField.get(abilitySelected).NBTTags.contains("OppTargetedEffect"))
        condition = playField.get(abilitySelected).player % 2 + 1;
      else 
        condition = playField.get(abilitySelected).player;
      for(Card c: playField)
      {
        int yPos = c.y * 100 + 50; if(playerTurn == 2) yPos = c.y * -100 + 750;
        if(abilitySelected != -1)
        {
          if(c.player == condition && !hasEffect(c, "NoEffect"))
          {
            if(dist(c.x * 100 + 50, yPos, mouseX, mouseY) < 50)
            {
              spawnEffects(playField.get(abilitySelected).name, abilitySelected, playField.indexOf(c));
              abilitySelected = -1;
              break;
            }
          }
        }  
      }
    }
    if(dist(mouseX, mouseY, 1150, 50) < 45)
    {
      transitionTime = 0; inTransition = true; transitionToMode =3;
      clickDelay = 10;
    }
    if(discarding)
    {
      int counter = 0;
      for(Card c: p[playerTurn].hand)
      {
        int x = counter % 5 * 120 + 660, y = counter / 5 * 120 + 150;
        if(mouseX > x - 50 && mouseX < x + 50 && mouseY > y - 50 && mouseY < y + 50 && mode == 0)
        {
          cardSelected = -1;
          playFieldSelected = -1;
          if(!c.summoned)
            p[playerTurn].deck.add(resetCard(c));
          p[playerTurn].hand.remove(c);
          p[playerTurn].cash -= discardsUsed + 2; 
          discardsUsed++;
          drawCard("Cycle");
          break;
        }
        counter++;
      }
      discarding = false;
    }
    if(dist(mouseX, mouseY, 900, 550) < 45)
    {
      if(p[playerTurn].hand.size() > 0 && p[playerTurn].cash >= discardsUsed + 2 && playFieldSelected == -1)
      {
        discarding = true;
      }
    }
    else discarding = false; 
  }
  if(mode == 1 && clickDelay == 0 && !inTransition) 
  {
    if(animationToggle)
    {
      mode = 2;
      copyPlayfield(playField, "currentPlayField");
      newHP1 = p[1].HP;
      newHP2 = p[2].HP;
      animateTimer = 0;
      copyPlayfield(oldPlayField, "playField");
      p[1].HP = oldHP1;
      p[2].HP = oldHP2;
    } else 
    {
      mode = 0;
      handOverEffects(playerTurn);
    }
  }
  
  if(mode == 3 && clickDelay == 0 && !inAnimation && !inTransition)
  {
    if(mouseX > 875 && mouseX < 1125 && mouseY > 260 && mouseY < 340) ruleset = 0;
    if(mouseX > 875 && mouseX < 1125 && mouseY > 460 && mouseY < 540) ruleset = 1;
    if(mouseX > 75 && mouseX < 325 && mouseY > 360 && mouseY < 440) { if(animationToggle) animationToggle = false; else animationToggle = true; }
    if(dist(mouseX, mouseY, 600, 400) < 150) { transitionTime = 0; inTransition = true; transitionToMode = 0; setupGame(); }
    if(mouseX > 210 && mouseX < 590 && mouseY > 600 && mouseY < 750) { transitionTime = 0; inTransition = true; transitionToMode =4; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(mouseX > 610 && mouseX < 990 && mouseY > 600 && mouseY < 750) { transitionTime = 0; inTransition = true; transitionToMode =5; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      exit();
    }
    if(dist(mouseX, mouseY, 60, 60) < 50)
    {
      mode =7;
    }
    if(dist(mouseX, mouseY, 60, 740) < 50)
    {
      mode =8;
      instructionPage = 0;
    }
    if(dist(mouseX, mouseY, 1140, 740) < 50)
    {
      mode =9;
    }
  }
  
  if((mode == 4 || mode == 5) && clickDelay == 0 && !inAnimation && !inTransition)
  {
    if(mouseX > 1085 && mouseX < 1185 && mouseY > 440 && mouseY < 490)
    {
      scroll = max(0, scroll - 1);
    }
    if(mouseX > 1085 && mouseX < 1185 && mouseY > 510 && mouseY < 560)
    {
      int length = 0;
      if(sort == 0) length = collection.length;
      if(sort == 1) length = categTot[0];
      if(sort == 2) length = categTot[1];
      if(sort == 3) length = categTot[2];
      if(sort == 4) length = categTot[4];
      if(sort == 5) length = categTot[3];
      if(sort == 6) length = categTot[5];
      scroll = min(max(0, (length - 1) / 5 - 4), scroll + 1);
    }
    if(mouseX > 20 && mouseX < 110 && mouseY > 455 && mouseY < 545)
    {
      sort++;
      addingCard = false;
      if(sort > categTot.length) sort = 0;
      scroll = 0;
    }
    
    deckSelected = -1;
    int playerDeck = mode - 4;
    for(int i = 0; i < offlineDecks[0].length; i++)
    {
      int x = i % 2;
      int y = i / 2;
      x = PApplet.parseInt(204 + x * 137.5f);
      y = PApplet.parseInt(294 + y * 137.5f);
      if(mouseX > x - 55 && mouseX < x + 55 && mouseY > y - 55 && mouseY < y + 55)
      {
        
        if(addingCard)
        {
          offlineDecks [playerDeck] [i] = collection [collectionSelected];
          collectionSelected = -1;
          addingCard = false;
        }
        deckSelected = i;
      }
    }
    // TEMP HARDCODING
    int correctX = 0, correctY = 0, count = 0;
    for(int i = 0; i < collection.length && !addingCard; i++)
    {
      if(sort == 1) // Class G
        if(!collection[i].category.contains(0)) continue;
      if(sort == 2) // Class H
        if(!collection[i].category.contains(1)) continue;
      if(sort == 3) // Elite
        if(!collection[i].category.contains(2)) continue;
      if(sort == 4) // Non-Elite
        if(!collection[i].category.contains(4)) continue;
      if(sort == 5) // Hangouts
        if(!collection[i].category.contains(3)) continue;
      if(sort == 6) // Normie
        if(!collection[i].category.contains(5)) continue;
      if(sort == 7) // Novelty
        if(!collection[i].category.contains(6)) continue;
      int x = count % 5;
      int y = count / 5 - scroll;
      if(collectionSelected == i) { correctX = x; correctY = y; }
      count++;
    }
    if(collectionSelected != -1)
    {
      int x = correctX, y = correctY;
      x = 570 + x * 110;
      y = 280 + y * 110;
      if(y > 600) y -= 320;
      if(mouseX > x - 50 && mouseX < x + 50 && mouseY > y + 70 && mouseY < y + 100)
      {
        addingCard = true;
      }
    }
    if(!addingCard)
      collectionSelected = -1;
    int j = 0;
    for(int i = 0; i < collection.length && !addingCard; i++)
    {
      if(sort == 1) // Class G
        if(!collection[i].category.contains(0)) continue;
      if(sort == 2) // Class H
        if(!collection[i].category.contains(1)) continue;
      if(sort == 3) // Elite
        if(!collection[i].category.contains(2)) continue;
      if(sort == 4) // Non-Elite
        if(!collection[i].category.contains(4)) continue;
      if(sort == 5) // Hangouts
        if(!collection[i].category.contains(3)) continue;
      if(sort == 6) // Normie
        if(!collection[i].category.contains(5)) continue;
      if(sort == 7) // Novelty
        if(!collection[i].category.contains(6)) continue;
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
        if(mouseX > x - 45 && mouseX < x + 45 && mouseY > y - 45 && mouseY < y + 45)
        {
          if(!alreadyInDeck)
          {
            collectionSelected = i;
            deckSelected = -1;
          }
        }
      }
      j++;
    }
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      transitionTime = 0; inTransition = true; transitionToMode =3;
    }
    if(dist(mouseX, mouseY, 60, 60) < 50)
    {
      String s [] = new String [1];
      s[0] = "";
      for(Card c: offlineDecks [mode - 4])
      {
        s[0]+=(indexOfCard(c)+" ");
      }
      saveStrings("Deck"+(mode-3)+".txt", s);
    }
  }
  if((mode == 7 || mode == 8 || mode == 9) && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      mode = 3;
    }
  }
  if(mode == 10 && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1150, 50) < 45)
    {
      transitionTime = 0; inTransition = true; transitionToMode = 3;
      clickDelay = 10;
    }
  }
  
  clickDelay = 1;
}
