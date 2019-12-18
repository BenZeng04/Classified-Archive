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
            if(canSpecial(c))
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
          // Logic when clicking on places you can move to.
          for(int n = 0; n < 4; n++)
          {
            if(n > 1 && !hasEffect(playField.get(playFieldSelected), "SideMove")) break;
            for(int j = 1; j <= calculateMovement(playField.get(playFieldSelected)); j++) // Moving
            {
              int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
              if(availibleMove(mx, my, n, j))
              {
                int updateY = my; if(n == 0) updateY -= j; if(n == 1) updateY += j;
                int updateX = mx; if(n == 2) updateX -= j; if(n == 3) updateX += j;
                int circleY = updateY * 100 + 50; if(playerTurn == 2) circleY = updateY * -100 + 750;
                if(dist(mouseX, mouseY, updateX * 100 + 50, circleY) < 50)
                {
                  int moveMultiplier = 1; // Multiplier for the amount of tiles moved. 
                  if(n % 2 == 0) moveMultiplier = -1; // Negative if n (move type, since it runs through all 4 of them to check for availible move slots) is a multiple of 2
                  if(n < 2) moveCard(playFieldSelected, j * moveMultiplier); // If n < 2, the move type is normal moving, not side moving.
                  else moveCardSide(playFieldSelected, j * moveMultiplier);
                  // Adding the move
                  if(mode == 0)
                  {
                    Move m = new Move();
                    m.type = 5;
                    m.targeter = playFieldSelected;
                    m.sideMove = false;
                    m.distance = j * moveMultiplier;
                    moves.add(m);
                  }
                  // Effects
                  playField.get(playFieldSelected).canMove = false;
                  if(!playField.get(playFieldSelected).name.equals("Simon"))
                    playField.get(playFieldSelected).attackCount = 0;
                  choice = -1;
                  temporary = false;
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
            int rng = calculateRange(playField.get(playFieldSelected));
            // Showing places you can attack 
            for(int i = 1; i <= rng; i++) //
            {
              int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
              if(q == 0) my -= i; if(q == 1) my += i; if(q == 2) mx += i; if(q == 3) mx -= i;// Where to attack
              if(canAttack(mx, my, q)) 
              {
                int opp = playerTurn % 2 + 1;
                if(outOfField(mx, my, q)) // Attacking Player 
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
                      m.targeted = findCard(mx, my);
                      m.x = playField.get(playFieldSelected).x;
                      m.y = playField.get(playFieldSelected).y;
                      m.name = playField.get(playFieldSelected).name;
                      moves.add(m);
                    }
                    if(!playField.get(playFieldSelected).name.equals("Simon"))
                      playField.get(playFieldSelected).canMove = false; 
                    playField.get(playFieldSelected).attackCount --;
                    attackCard(playFieldSelected, findCard(mx, my), true);
                    
                    // Antnohy effect 
                    if(playField.get(playFieldSelected).name.equals("Antnohy") && !hasEffect(playField.get(findCard(mx, my)), "Invincible"))
                    {
                      int x = mx, y = my;
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
                    if(playField.get(playFieldSelected).name.equals("GeeTraveller") && !hasEffect(playField.get(findCard(mx, my)), "Invincible"))
                    {
                      int x = mx, y = my;
                      for(int l = 1; l <= 6; l++)
                        if(l != y)                     
                          if(findCard(x, l, opp) != -1)
                            attackCard(playFieldSelected, findCard(x, l, opp), true);
                    }
                  }
                }
              }
              if(!availibleAttack(mx, my, q))
                break;
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
          int playerRange = 3;
          if(abs(c.y - correctY) < playerRange && c.player != playerTurn)
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

        boolean targetCondition = true; 
        if(playField.get(abilitySelected).name.equals("UNNAMED")) targetCondition = c.cost >= 5 && c != playField.get(abilitySelected);
        if(abilitySelected != -1)
        {
          if(c.player == condition && !hasEffect(c, "NoEffect") && targetCondition)
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
      transitionTime = 0; inTransition = true; transitionToMode = 3;
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
  else if(mode == 1 && clickDelay == 0 && !inTransition) 
  {
    if(replayOn())
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
  else if(mode == 3 && clickDelay == 0 && !inAnimation && !inTransition)
  {
    if(mouseX > 875 && mouseX < 1125 && mouseY > 260 && mouseY < 340) ruleset = 0;
    if(mouseX > 875 && mouseX < 1125 && mouseY > 460 && mouseY < 540) ruleset = 1;
    if(dist(mouseX, mouseY, 600, 400) < 150) { transitionTime = 0; inTransition = true; transitionToMode = 0; setupGame(); }
    if(mouseX > 210 && mouseX < 590 && mouseY > 600 && mouseY < 750) { transitionTime = 0; inTransition = true; transitionToMode = 4; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(mouseX > 610 && mouseX < 990 && mouseY > 600 && mouseY < 750) { transitionTime = 0; inTransition = true; transitionToMode = 5; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      exit();
    }
    if(dist(mouseX, mouseY, 60, 60) < 50)
    {
      mode = 7;
    }
    if(dist(mouseX, mouseY, 60, 740) < 50)
    {
      mode = 8;
      instructionPage = 0;
    }
    if(dist(mouseX, mouseY, 1140, 740) < 50)
    {
      mode = 9;
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
      else length = categTot[sort - 1];
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
    if(collectionSelected == -1) addingCard = false;
    for(int i = 0; i < offlineDecks[0].length; i++)
    {
      int x = i % 2;
      int y = i / 2;
      x = parseInt(204 + x * 137.5f);
      y = parseInt(294 + y * 137.5f);
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
    int correctX = 0, correctY = 0, count = 0;
    for(int i = 0; i < collection.length && !addingCard; i++)
    {
      if(!collection[i].category.contains(sort - 1) && sort != 0) continue;
      if(collection[i].NBTTags.contains("Unobtainable")) continue;
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
        addingCard = true;
      else addingCard = false;
    }
    if(!addingCard)
      collectionSelected = -1;
    
    int j = 0;
    for(int i = 0; i < collection.length && !addingCard; i++)
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
      transitionTime = 0; inTransition = true; transitionToMode = 3;
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
  else if(mode == 7 && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      mode = 3;
    }
    for(Button b: settings)
    {
      b.onClickEvent();
    }
  }
  else if(mode == 8 && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      mode = 3;
    }
  }
  else if(mode == 9 && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1140, 60) < 50)
    {
      mode = 3;
    }
  }
  else if(mode == 10 && !inAnimation && !inTransition)
  {
    if(dist(mouseX, mouseY, 1150, 50) < 45)
    {
      transitionTime = 0; inTransition = true; transitionToMode = 3;
      clickDelay = 10;
    }
  }
  
  clickDelay = 1;
}
