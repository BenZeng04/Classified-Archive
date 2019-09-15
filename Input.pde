int cursorX;
int cursorY;
public void mousePressed()
{
if(mode==0 && clickDelay==0 && !inAnimation && !inTransition)
{
  if(abilitySelected==-1)
  {
    for(int i = 0; i < p[playerTurn].hand.size(); i++)
    {
      int x, y;
      if(playerTurn==1)
      {
        x = i % 5 * 120 + 670; y = i / 5 * 120 + 150;
      }
      else 
      {
        x = i % 5 * 120 + 670; y = i / 5 * 120 + 150;
      }
        
      if(i==cardSelected && p[playerTurn].hand.get(i).cost <= p[playerTurn].cash)
      {
        x = x + cursorX - ogx;
        y = y + cursorY - ogy;
      }
      if(cursorX < x + 50 && cursorX > x - 50 && cursorY < y + 50 && cursorY > y - 50 && cardSelected==-1)
      {
        cardSelected = i;
        ogx = cursorX;
        ogy = cursorY;
        break;
      }
    }
    boolean temporary = true; // If pressing a choice button, the playFieldSelected isn't gonna reset.
    if(playFieldSelected != -1)
    { 
      if(choice==-1 && playField.get(playFieldSelected).player==playerTurn) // Buttons Omegalul for CHOICES
      {  
        //Move  
        if(cursorX > 705 && cursorX < 895 && cursorY > 515 && cursorY < 555 && playField.get(playFieldSelected).canMove)
        {
          choice = 1;
          temporary = false;
        }
        //attack
        if(cursorX > 905 && cursorX < 1095 && cursorY > 515 && cursorY < 555 && playField.get(playFieldSelected).attackCount > 0)
        {
          choice = 2;
          temporary = false;
        }
        
        if(playField.get(playFieldSelected).NBTTags.contains("SpecialMove"))
        {
          if(cursorX > 905 && cursorX < 1095 && cursorY > 565 && cursorY < 605 && playField.get(playFieldSelected).canSpecial)
          {
            choice = 0;
            temporary = false;
          }
          if(cursorX > 705 && cursorX < 895 && cursorY > 565 && cursorY < 605 && !hasEffect(playField.get(playFieldSelected), "Alive"))
          {
            discard(playFieldSelected);
            temporary = false;
          }
        }
        else
        {
          if(cursorX > 805 && cursorX < 995 && cursorY > 565 && cursorY < 605 && !hasEffect(playField.get(playFieldSelected), "Alive"))
          {
            discard(playFieldSelected);
            temporary = false;
          }
        }
      }
      // No Special Effects. Only attack and move.
      if(choice==0 && playField.get(playFieldSelected).player==playerTurn)
      {
        for(Card c: playField)
        {
          int sideTarget;
          if(playField.get(playFieldSelected).name.equals("Hubert")) sideTarget = playField.get(playFieldSelected).player; else sideTarget = playField.get(playFieldSelected).player % 2 + 1;
          boolean condition = true;
          if(playField.get(playFieldSelected).name.equals("Hubert")) condition = !c.NBTTags.contains("Unhealable");
          if(playField.get(playFieldSelected).name.equals("Ethan")) condition = c.cost < 5;
          if(c.player==sideTarget && !hasEffect(c, "NoEffect") && condition)
          {
            int yOfCircle = c.y * 100 + 50; if(playerTurn==2) yOfCircle = c.y * -100 + 750;
            if(dist(c.x * 100 + 50, yOfCircle, cursorX, cursorY) < 50)
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
      
      if(choice==1)
      {
        int mvmt = playField.get(playFieldSelected).MVMT;
        if(hasEffect(playField.get(playFieldSelected), "Slowdown")) mvmt -= 2; 
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
              if(n==0)
              {         
                if(c.x==mx && c.y==my - j || my <= j)
                  availible = false;
              }
              if(n==1)
              {
                if(c.x==mx && c.y==my + j || my + j > 6)
                  availible = false;
              }
              if(n==2)
              {
                if(c.x==mx - j && c.y==my || mx <= j)
                  availible = false;
              }
              if(n==3)
              {
                if(c.x==mx + j && c.y==my || mx + j > 5)
                  availible = false;
              }
            }
            if(availible)
            {
              int updateY = my; if(n==0) updateY -= j; if(n==1) updateY += j;
              int updateX = mx; if(n==2) updateX -= j; if(n==3) updateX += j;
              if(playerTurn==1)
              {
                if(dist(cursorX, cursorY, updateX * 100 + 50, updateY * 100 + 50) < 50)
                {
                  Move m = new Move();
                  m.type = 5;
                  
                  m.targeter = playFieldSelected;
                  if(n==0)
                  {
                    m.distance = -j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, -j);
                  }
                  if(n==1)
                  {
                    m.distance = j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, j);
                  }
                  if(n==2)
                  {
                    m.distance = -j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, -j);
                  }
                  if(n==3)
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
                if(dist(cursorX, cursorY, updateX * 100 + 50, updateY * -100 + 750) < 50)
                {
                  Move m = new Move();
                  m.type = 5;
                  m.targeter = playFieldSelected;
                  if(n==0)
                  {
                    m.distance = -j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, -j);
                  }
                  if(n==1)
                  {
                    m.distance = j;
                    m.sideMove = false;
                    moveCard(playFieldSelected, j);
                  }
                  if(n==2)
                  {
                    m.distance = -j;
                    m.sideMove = true;
                    moveCardSide(playFieldSelected, -j);
                  }
                  if(n==3)
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
      if(choice==2)
      {
        for(int q = 0; q < 4; q++)
        {
          int rng = playField.get(playFieldSelected).RNG;
          for(Card d: playField)
          {
            if(d.name.equals("Ridge Rhea") && playField.get(playFieldSelected) != d && !playField.get(playFieldSelected).name.equals("Ultrabright") && d.player==playField.get(playFieldSelected).player && d.x==playField.get(playFieldSelected).x) rng += 2;
          }
          if(hasEffect(playField.get(playFieldSelected), "NVW")) rng++;
          // Showing places you can attack 
          for(int i = 1; i <= rng; i++) //
          {
            int mx = playField.get(playFieldSelected).x, my = playField.get(playFieldSelected).y;
            int takeHit = 0; // Getting attacked
            boolean canAttack = false;
            boolean availible = true; // Availible doesnt mean that you can attack that spot, it just means that it won't quit.
            boolean cap; if(q==0) cap = my <= i; else if(q==1) cap = my + i > 6; else if(q==2) cap = mx + i > 5; else cap = mx <= i; // If attacking player
            if(q==0) my -= i; if( q==1) my += i; if(q==2) mx += i; if(q==3) mx -= i;// Where to attack
            if(playField.get(playFieldSelected).player != playerTurn)
              break;
            if(cap)
            {
              boolean firstTurn = true;
              if(playField.get(playFieldSelected).turnPlacedOn != p[playerTurn].turn || (playField.get(playFieldSelected).name.equals("Mr. Pegamah"))) { firstTurn = false;}
              
              if((playerTurn==1 && q==0) || (playerTurn==2 && q==1))
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
              if(c.x==mx && c.y==my)
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
                if(dist(cursorX, cursorY, 350, 50) < 50)
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
                
                int yBound; if(playerTurn==1) yBound = my * 100 + 50; else yBound = my * -100 + 750;
                if(dist(cursorX, cursorY, mx * 100 + 50, yBound) < 50)
                {
                  choice = -1;
                  temporary = false;
                  if(mode==0)
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
                  if(playField.get(playFieldSelected).name.equals("Simon"))
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
        if(playerTurn==2)
          y = playField.get(i).y * -100 + 750;
        
        if(cursorX < x + 50 && cursorX > x - 50 && cursorY < y + 50 && cursorY > y - 50)
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
      if(cursorX < 1100 && cursorX > 700 && cursorY < 765 && cursorY > 635)
      {
        handOverTurn();
      }
      if(playerSelected)
      {
        for(Card c: playField)
        {
          int correctY = 6; if(playerTurn==2) correctY = 1;
          if(c.y==correctY && c.player != playerTurn)
          {
            int yPos = c.y * 100 + 50; if(playerTurn==2) yPos = c.y * -100 + 750;
            if(dist(cursorX, cursorY, c.x * 100 + 50, yPos) < 50)
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
      if(cursorX > 115 && cursorX < 285 && cursorY > 718 && cursorY < 748 && p[playerTurn].canAttack)
      {
        playerSelected = true;
      }
    }
    else
    {
      if(playField.get(abilitySelected).name.equals("Jason C") || playField.get(abilitySelected).name.equals("Esther") || playField.get(abilitySelected).name.equals("Jefferson") || playField.get(abilitySelected).name.equals("Jawnie Dirp"))
      {
        for(Card c: playField)
        {
          int yPos = c.y * 100 + 50; if(playerTurn==2) yPos = c.y * -100 + 750;
          if(abilitySelected != -1)
          {
            if (c.player != (playField.get(abilitySelected).player) && !hasEffect(c, "NoEffect")
            ) // TRIGGERED
            {
              if(dist(c.x * 100 + 50, yPos, cursorX, cursorY) < 50)
              {
                spawnEffects(playField.get(abilitySelected).name, abilitySelected, playField.indexOf(c));
                abilitySelected = -1;
                break;
              }
            }
          }  
        }
      }
      else if(playField.get(abilitySelected).name.equals("Mandaran") || playField.get(abilitySelected).name.equals("George") || playField.get(abilitySelected).name.equals("Anthony"))
      {
        for(Card c: playField)
        {
          int yPos = c.y * 100 + 50; if(playerTurn==2) yPos = c.y * -100 + 750;
          if(abilitySelected != -1)
          {
            if (c.player==(playField.get(abilitySelected).player) && !hasEffect(c, "NoEffect")
            ) // TRIGGERED
            {
              if(dist(c.x * 100 + 50, yPos, cursorX, cursorY) < 50)
              {
                
                spawnEffects(playField.get(abilitySelected).name, abilitySelected, playField.indexOf(c));
                abilitySelected = -1;
                break;
              }
            }
          }  
        }
      }
    }
    if(dist(cursorX, cursorY, 1150, 50) < 45)
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
        if(cursorX > x - 50 && cursorX < x + 50 && cursorY > y - 50 && cursorY < y + 50 && mode==0)
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
    if(dist(cursorX, cursorY, 900, 550) < 45)
    {
      if(p[playerTurn].hand.size() > 0 && p[playerTurn].cash >= discardsUsed + 2 && playFieldSelected==-1)
      {
        discarding = true;
      }
    }
    else discarding = false; 
  }
  if(mode==1 && clickDelay==0 && !inTransition) // Fix weird bug
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
  
  if(mode==3 && clickDelay==0 && !inAnimation && !inTransition)
  {
    if(cursorX > 875 && cursorX < 1125 && cursorY > 260 && cursorY < 340) ruleset = 0;
    if(cursorX > 875 && cursorX < 1125 && cursorY > 460 && cursorY < 540) ruleset = 1;
    if(cursorX > 75 && cursorX < 325 && cursorY > 360 && cursorY < 440) { if(animationToggle) animationToggle = false; else animationToggle = true; }
    if(dist(cursorX, cursorY, 600, 400) < 150) { transitionTime = 0; inTransition = true; transitionToMode = 0; setupGame(); }
    if(cursorX > 210 && cursorX < 590 && cursorY > 600 && cursorY < 750) { transitionTime = 0; inTransition = true; transitionToMode =4; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(cursorX > 610 && cursorX < 990 && cursorY > 600 && cursorY < 750) { transitionTime = 0; inTransition = true; transitionToMode =5; scroll = 0; sort = 0; clickDelay = 2; deckSelected = -1; addingCard = false; collectionSelected = -1;}
    if(dist(cursorX, cursorY, 1140, 60) < 50)
    {
      exit();
    }
    if(dist(cursorX, cursorY, 60, 60) < 50)
    {
      mode =7;
    }
    if(dist(cursorX, cursorY, 60, 740) < 50)
    {
      mode =8;
      instructionPage = 0;
    }
    if(dist(cursorX, cursorY, 1140, 740) < 50)
    {
      mode =9;
    }
  }
  
  if((mode==4 || mode==5) && clickDelay==0 && !inAnimation && !inTransition)
  {
    if(cursorX > 1085 && cursorX < 1185 && cursorY > 440 && cursorY < 490)
    {
      scroll = max(0, scroll - 1);
    }
    if(cursorX > 1085 && cursorX < 1185 && cursorY > 510 && cursorY < 560)
    {
      int length = 0;
      if(sort==0) length = collection.length;
      if(sort==1) length = categTot[0];
      if(sort==2) length = categTot[1];
      if(sort==3) length = categTot[2];
      if(sort==4) length = categTot[4];
      if(sort==5) length = categTot[3];
      if(sort==6) length = categTot[5];
      scroll = min(max(0, (length - 1) / 5 - 4), scroll + 1);
    }
    if(cursorX > 20 && cursorX < 110 && cursorY > 455 && cursorY < 545)
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
      if(cursorX > x - 55 && cursorX < x + 55 && cursorY > y - 55 && cursorY < y + 55)
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
      if(sort==1) // Class G
        if(!collection[i].category.contains(0)) continue;
      if(sort==2) // Class H
        if(!collection[i].category.contains(1)) continue;
      if(sort==3) // Elite
        if(!collection[i].category.contains(2)) continue;
      if(sort==4) // Non-Elite
        if(!collection[i].category.contains(4)) continue;
      if(sort==5) // Hangouts
        if(!collection[i].category.contains(3)) continue;
      if(sort==6) // Normie
        if(!collection[i].category.contains(5)) continue;
      if(sort==7) // Novelty
        if(!collection[i].category.contains(6)) continue;
      int x = count % 5;
      int y = count / 5 - scroll;
      if(collectionSelected==i) { correctX = x; correctY = y; }
      count++;
    }
    if(collectionSelected != -1)
    {
      int x = correctX, y = correctY;
      x = 570 + x * 110;
      y = 280 + y * 110;
      if(y > 600) y -= 320;
      if(cursorX > x - 50 && cursorX < x + 50 && cursorY > y + 70 && cursorY < y + 100)
      {
        addingCard = true;
      }
    }
    if(!addingCard)
      collectionSelected = -1;
    int j = 0;
    for(int i = 0; i < collection.length && !addingCard; i++)
    {
      if(sort==1) // Class G
        if(!collection[i].category.contains(0)) continue;
      if(sort==2) // Class H
        if(!collection[i].category.contains(1)) continue;
      if(sort==3) // Elite
        if(!collection[i].category.contains(2)) continue;
      if(sort==4) // Non-Elite
        if(!collection[i].category.contains(4)) continue;
      if(sort==5) // Hangouts
        if(!collection[i].category.contains(3)) continue;
      if(sort==6) // Normie
        if(!collection[i].category.contains(5)) continue;
      if(sort==7) // Novelty
        if(!collection[i].category.contains(6)) continue;
      int x = j % 5;
      int y = j / 5 - scroll;
      if(collectionSelected==i) { correctX = x; correctY = y; }
      x = 570 + x * 110;
      y = 280 + y * 110;
      boolean alreadyInDeck = false;
      for(Card c: offlineDecks[playerDeck])
      {
        if(c.name.equals(collection[i].name)) { alreadyInDeck = true; break; }
      }
      if(y >= 280 && y <= 730)
      {
        if(cursorX > x - 45 && cursorX < x + 45 && cursorY > y - 45 && cursorY < y + 45)
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
    if(dist(cursorX, cursorY, 1140, 60) < 50)
    {
      transitionTime = 0; inTransition = true; transitionToMode =3;
    }
    if(dist(cursorX, cursorY, 60, 60) < 50)
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
  if((mode==7 || mode==8 || mode==9) && !inAnimation && !inTransition)
  {
    if(dist(cursorX, cursorY, 1140, 60) < 50)
    {
      mode = 3;
    }
  }
  if(mode==10 && !inAnimation && !inTransition)
  {
    if(dist(cursorX, cursorY, 1150, 50) < 45)
    {
      transitionTime = 0; inTransition = true; transitionToMode = 3;
      clickDelay = 10;
    }
  }
  
  clickDelay = 1;
}
