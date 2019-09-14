public void moveCard(int index, int dist)
{
  playFieldSelected = index; // Sets the selected card as the card moving.
  distMove = dist; // Sets the distance to be moved.
  moveType = 0; // Vertical Movement
  indexMove = index; inAnimation = true; animationMode = 0; aniTimer = 0; // Starts the animation
}

public void moveCardSide(int index, int dist)
{
  playFieldSelected = index; // Sets the selected card as the card moving.
  distMove = dist; // Sets the distance to be moved.
  moveType = 1; // Horizontal Movement
  indexMove = index; inAnimation = true; animationMode = 0; aniTimer = 0; // Starts the animation
}

public void placeCard(int player, Card baseCard, int x, int y, boolean spawned)
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 1;
    m.player = player;
    m.cardPlaced = baseCard; 
    m.x = x;
    m.y = y;
    moves.add(m); // Puts this card into the queue, for when it is your opponents' turn. (Animating your moves to your opponent)
  }
  
  Card temp = baseCard.copy();
  temp.player = player;
  temp.x = x;
  temp.y = y;
  targetX = temp.x; targetY = temp.y; inAnimation = true; aniTimer = 0; animationMode = 5; // Starts Animation
  temp.attackCount = 1;
  temp.canMove = true;
  temp.turnPlacedOn = p[player].turn;
  
  // Cards' Effects!!!
  
  if(temp.name == "Kevin" || temp.name == "Ilem") 
  {
    addEffect(-1, temp, "Resurrect"); // These cards resurrect once upon dying
  }
  
  if(temp.name == "Anny") 
  {
    addEffect(3, temp, "2X ATK (Anny)"); // Double attack for 3 turns.
  }
  
  if(temp.name == "Snake")
  {
    temp.turnPlacedOn = p[player % 2 + 1].turn; // Switches player
    temp.player = temp.player % 2 + 1;
    addEffect(3, temp, "Alive"); // Dead after 3 turns.
  }
  
  if(temp.name == "Megan")
  {
    temp.HP = ceil(p[temp.player].HP / 2); // HP is player's HP / 2
  }
  
  if(temp.name == "Richard" && mode == 0)
  {
    if(p[player % 2 + 1].hand.size() > 0) // Sends a card back to their deck
    {
      int rand = PApplet.parseInt(random(p[player % 2 + 1].hand.size()));
      
      if(!p[player % 2 + 1].hand.get(rand).summoned)
        p[player % 2 + 1].deck.add(resetCard(p[player % 2 + 1].hand.get(rand)));
      p[player % 2 + 1].hand.remove(rand);
    }
  }
  
  if(temp.name == "Sharnujan")
  {
    for(Card c: playField)
    {
      if(c.player == temp.player && c.cost > 4) 
      {
        temp.RNG += 4; // Sets special range if there is a $4 or more
        break;
      }
    }
  }
  
  if(temp.name == "Moonlight")
  {
    p[temp.player].HP += 6; // Increase player HP
  }
  if(temp.name == "Jefferson" || temp.name == "Mr. Ustenglibo")
  {
    addEffect(-1, temp, "NoEffect"); // Makes the card uneffectable
  }
  if(temp.name == "Lina")
  {
    addEffect(-1, temp, "HealDisable"); // Special effect that goes away when card gets attacked
  }
  
  if(temp.name == "Lucy")
  {
    addEffect(-1, temp, "GetsBuffed"); // Gets buffed whenever opponents' cards with the "BuffsLucy" attacks
    for(Card c: playField)
    {
      if(c.player != temp.player) // Gives the effect to all of the opponents' cards
      {
        addEffect(-1, c, "BuffsLucy");
      }
    }
  }
  if(temp.name == "Mr. Pegamah")
  {
    temp.turnPlacedOn--; // Pretends the card was placed on a different turn, so it can attack player first turn
  }
  if(temp.name == "Tony" || temp.name == "Joseph" || temp.name == "Physouie" || temp.name == "Mr. Farewell")
  {
    addEffect(3, temp, "Alive"); // Dies in 3 turns
  }
  
  if(temp.name == "Mr. Onosukoo")
  {
    addEffect(1, temp, "Alive"); // Dies in 1 turn
  }
  if(temp.NBTTags.contains("SpecialMove"))
    temp.canSpecial = true; // Cards with this tag have a special move, set this to true
  if(temp.name == "Bonnie")
    temp.attackCount = 2; // Can attack twice
  if(temp.name == "Mark" && mode == 0)
  {
    for(int i = 0; i < 2; i++)
    {
      if(p[playerTurn].deck.size() > 0) // Draws cards
          drawCard();
    }
  }
  int num = 0; // #of enemy cards
  for(Card c: playField)
  {
    if(c.player == player % 2 + 1 && !hasEffect(c, "NoEffect"))
      num++;
  }
  
  if(!temp.spawned)
    playFieldSelected = playField.size();
  if((temp.name == "Jason C" || temp.name == "Esther" || temp.name == "Jefferson" || temp.name == "Jawnie Dirp") && num > 0 && mode == 0 && !spawned) // Cards spawned cannot have their own special targeted effect.
    abilitySelected = playField.size();

  if((temp.name == "Mandaran" || temp.name == "George" || temp.name == "Anthony") && mode == 0 && !spawned)
    abilitySelected = playField.size();
    
  for(Card c: playField) // Buff all cards / effect all cards
  {
    if(name(c, "Mr. Bing") && c.player == player)
    {
      c.ATK += 2;
      c.HP += 2;
    }
    if(!hasEffect(temp, "NoEffect"))
    {
      if(name(c, "Samuel") && c.player == player)
      {
        temp.ATK++;
        if(temp.category.contains(2)) temp.ATK++;
      }
      if(name(c, "Kenneth") && c.player == player)
      {
        temp.ATK+=2;
        if(temp.category.contains(2)) temp.HP+=2;
      }
      if(name(c, "Lucy") && c.player != player)
      {
        addEffect(-1, temp, "BuffsLucy");
      }
      if(name(c, "Mr. Filascario") && c.player != player)
      {
        temp.ATK -= 4; 
        temp.HP -= 4;
        temp.ATK = max(0, temp.ATK);
      }
    }
  }
  
  playField.add(temp);
  
  if(temp.name == "Jonathan" || temp.name == "Samuel")
  {
    for(Card c: playField)
    {
      if(c.player == player && !hasEffect(c, "NoEffect"))
      {
        c.ATK++;
        if(temp.name == "Jonathan" && c.category.contains(4))
        {
          c.ATK++;
          c.HP++;
        }
        if(temp.name == "Samuel" && c.category.contains(2)) c.ATK++;
      }
    }
  }
  
  if(temp.name == "Kenneth")
  {
    for(Card c: playField)
    {
      if(c.player == player && !hasEffect(c, "NoEffect"))
      {
        c.ATK += 2;
        if(c.category.contains(2)) c.HP += 2;
      }
    }
  }
  
  if(temp.name == "Mr. Willikens")
  {
    int countNovelty = 0;
    for(Card c: playField)
    {
      if(c.category.contains(6) && c.player == player)
      {
        countNovelty++;
        if(!c.NBTTags.contains("Unhealable") && !hasEffect(c, "NoEffect")) c.HP += 3;
      }
    }
    temp.ATK = countNovelty;
  }
  
  if(temp.name == "Mr. Billikens")
  {
    int countNovelty = 0;
    for(Card c: playField)
    {
      if(c.category.contains(6) && c.player == player)
      {
        countNovelty++;
        c.ATK += 3;
      }
    }
    temp.HP += countNovelty;
  }
  
  if(temp.name == "A.L.I.C.E.")
  {
    for(Card c: playField)
    {
      if(c.player == player && !(c.x == temp.x && c.y == temp.y))
      {
        c.ATK += 3;
        if(!c.NBTTags.contains("Unhealable"))
          c.HP += 3;
        if(c.category.contains(5))
        {
          c.ATK += 3;
          if(!c.NBTTags.contains("Unhealable"))
            c.HP += 3;
        }
      }
    }
  }
  if(temp.name == "Mr. Valentino")
  {
    if(mode == 0)
    {
      for(Card c: playField)
      {
        if(c.player == temp.player && c.category.contains(6))
        {
          c.attackCount++;
        }
      }
    }
  }
  
  if(temp.name == "Mr. Facto")
  {
    ArrayList <Card> tempC = new ArrayList<Card>();
    if(mode == 0)
    {
      tempC = new ArrayList<Card>();
      for(Card d: collection)
      {
        if(d.category.contains(6))
        {
          tempC.add(d);
        }
      }
      Card c = tempC.get(PApplet.parseInt(random(tempC.size()))).copy();
      c.summoned = true;
      c.cost -= 3; if(c.cost < 0) c.cost = 0;
      p[temp.player].hand.add(c);
    }
  }
  
  if(temp.name == "Mr. Stirrychigg")
  {
    Card a = collection[searchCard("Mr. Utnapis")].copy();
    a.summoned = true;
    a.spawned = true;
    int summonY = temp.y, summonX = temp.x; if(temp.player == 1) summonY--; else summonY++; 
    
    if(findCard(summonX, summonY) == -1 && mode == 0) placeCard(player, a, summonX, summonY, true);
  }
  
  if(temp.name == "Yebanow")
  {
    for(Card c: playField)
    {
      if(c.category.contains(3) && c.player == player && !hasEffect(c, "NoEffect"))
      {
        c.ATK++;
        if(!c.NBTTags.contains("Unhealable")) c.HP++;
      }
    }
    ArrayList <Card> tempC = new ArrayList<Card>();
    if(mode == 0)
    {
      tempC = new ArrayList<Card>();
      for(Card d: collection)
      {
        if(!d.isSpell && d.cost == 1)
        {
          tempC.add(d);
        }
      }
      for(int i = 0; i < 4; i++)
      {
        int summonX = temp.x; int summonY = temp.y; if(i == 0) summonX++; if(i == 1) summonX--; if(i == 2) summonY++; if(i == 3) summonY--;
        int rand = PApplet.parseInt(random(tempC.size()));
        Card a = tempC.get(rand).copy();
        a.summoned = true;
        a.spawned = true;
        boolean canUse = true; if(summonX > 5 || summonX < 1 || summonY > 6 || summonY < 1 || findCard(summonX, summonY, 1) != -1 || findCard(summonX, summonY, 2) != -1) canUse = false;
        if(canUse && mode == 0) placeCard(player, a, summonX, summonY, true);
      }
    }
  }
  
  if(temp.name == "Jefferson")
  {
    temp.ATK++;
    for(Card c: playField)
    {
      if(c.player == player && !hasEffect(c, "NoEffect") && c.category.contains(2))
        c.ATK++;
    }
  }
  
  // Mr. Farewell 
  if(!spawned && mode == 0) // Cards must NOT be spawned out of any spell/card.
  {
    ArrayList <Card> toSummon = new ArrayList <Card>();
    for(Card c: collection)
    {
      if(c.cost <= 2 && !c.isSpell) toSummon.add(c);
    }
    ArrayList <Card> add = new ArrayList<Card>();
    for(Card d: playField)
    {
      if(d.name == "Mr. Farewell" && d.player == player && !hasEffect(d, "Nullify") && d != temp)
      {
        Card c = toSummon.get(PApplet.parseInt(random(toSummon.size()))).copy();
        c.summoned = true;
        c.spawned = true;
        c.player = y;
        add.add(c);
        
      }
    }
    while(add.size() > 0)
    {
      ArrayList <Integer> availible = new ArrayList<Integer>();
      int yPos = 6; if(player == 2) yPos = 1;
      for(int i = 1; i <= 5; i++)
      {
        if(findCard(i, yPos) == -1) availible.add(i);
      }
      if(availible.size() > 0)
      {
        int i = availible.get(PApplet.parseInt(random(availible.size())));
        placeCard(player, add.get(0), i, yPos, true);
        availible.remove(availible.indexOf(i));
      } else break;
      
      add.remove(0);
    }
    
  }
  
  if(temp.name == "Jason P")
  {
    for(Card c: playField)
    {
      if(c.player != temp.player && !hasEffect(c, "NoEffect") && !hasEffect(c, "Stun"))
      {
          addEffect(1, c, "JPStun");
      }
    }
    if(temp.player == 1)
    {
      for(int i = 2; i <= 6; i++)
      {
        for(Card c: playField)
        {
          if(c.player == 2 && c.y == i && !hasEffect(c, "NoEffect"))
          {
            for(int j = i - 1; j >= 1; j--)
            {
              boolean canMove = true;
              for(Card d: playField)
              {
                if(d.x == c.x && d.y == j)
                  canMove = false;
              }
              if(canMove)
                c.y = j;
              else break;
            }
          }
        }
      }
    } else {
      for(int i = 5; i >= 1; i--)
      {
        for(Card c: playField)
        {
          if(c.player == 1 && c.y == i && !hasEffect(c, "NoEffect"))
          {
            for(int j = i + 1; j <= 6; j++)
            {
              boolean canMove = true;
              for(Card d: playField)
              {
                if(d.x == c.x && d.y == j)
                  canMove = false;
              }
              if(canMove)
                c.y = j;
              else break;
            }
          }
        }
      }
    }
    
    
    //////
  }
}

public void attackPlayer(int attacker)
{
  boolean hasBen20 = false;

  if(mode == 0)
  {
    Move m = new Move();
    m.type = 7;
    m.targeter = attacker;
    moves.add(m);
  }
  playFieldSelected = attacker;
  
  int opp = playField.get(attacker).player % 2 + 1;
  String name = playField.get(attacker).name;
  if(hasEffect(playField.get(attacker), "Nullify")) name = "Nulled";
  int atk = playField.get(attacker).ATK;
  
  if(name == "Andrew") atk += 5;
  if(name == "Mr. Pegamah") atk*=2;
  for(Card c: playField)
  {
    if(c.name == "Ben 2.0" && c.player == opp && !hasEffect(c, "Nullify"))
    {
      hasBen20 = true;
    }
  }
  if(hasBen20)
  {
    attackCard(attacker, -1, true);
  } else { ATKX.add(-1); ATKY.add(-1); inAnimation = true; animationMode = 1; aniTimer = 0; }
  
  if(name == "A.L.I.C.E.")
  {
    for(Card d: playField)
    {
      if(d.name == "Moonlight" && d.player == playField.get(attacker).player)
        atk *= 2;
    }
  }
  
  if(name == "Vithiya" && mode == 0)
  {
    if(p[playerTurn].deck.size() > 0)
    {
      drawCard();
    }
  }
  
  if(name == "Ben")
  {
    for(Card d: playField)
    {
      if(d.category.contains(2) && d.player == playField.get(attacker).player)
        atk++;
    }
  }

  if(!hasEffect(playField.get(attacker), "NoEffect"))
  {
    for(Card c: playField)
    {
      if(c.name == "Ben" && playField.get(attacker).category.contains(2) && playField.get(attacker).player == c.player && !hasEffect(c, "Nullify")) atk += 3;
    }
    for(Card d: playField)
    {
      if(d.name == "Rita" && d.player != playField.get(attacker).player && !hasEffect(d, "Nullify")) atk = max(0, atk - 1);
    }
  }
  
  if(hasEffect(playField.get(attacker), "2X ATK") || hasEffect(playField.get(attacker), "2X ATK (Anny)")) atk *= 2;
  
  if(!hasBen20)
    p[opp].HP -= atk; 
  
  // Effects upon attacking
  if(name == "Jennifer")
    playField.get(attacker).ATK+=2;
    
  if(name == "Mr. Utnapis")
  {
    playField.get(attacker).ATK+=2;
    playField.get(attacker).HP+=2;
  }

  if(name == "Kabilan")
    playField.get(attacker).RNG++;
    
    
  if(name == "Moonlight")
  {
    p[playField.get(attacker).player].HP += atk / 2;
    playField.get(attacker).HP += atk / 2;
  }
  
  if(hasEffect(playField.get(attacker), "BuffsLucy"))
  {
    for(Card c:playField)
    {
      if(c.player == opp && hasEffect(c, "GetsBuffed"))
      {
        c.ATK++;
      }
    }
  }
  
  for(Card c: playField)
  {
    if(c.name == "Mr. Valentino" && c.player == playField.get(attacker).player && playField.get(attacker).category.contains(6) && !hasEffect(c, "Nullify") && c != playField.get(attacker))
    {
      playField.get(attacker).HP++;
      c.HP++;
    }
  }
}

public void attackCard(int attacker, int takeHit, boolean loop) // Logic for when a CARD GETS ATTACKED BY ANYTHING. This can be the PLAYER, SPELLS, AND CARDS
{
  Card hit, def;
  boolean hasBen20 = false;
  int indexOfBen20 = -1;
  int tempPlayer;
  if(takeHit == -1) tempPlayer = playField.get(attacker).player % 2 + 1; else tempPlayer = playField.get(takeHit).player;
  for(Card c: playField)
  {
    if(c.name == "Ben 2.0" && c.player == tempPlayer && !hasEffect(c, "Nullify"))
    {
      if(takeHit == -1) // This redirects player to ben 2.0
      {
        indexOfBen20 = playField.indexOf(c);
        hasBen20 = true;
      }
      else if(playField.get(takeHit) != c)  
      {
        indexOfBen20 = playField.indexOf(c);
        hasBen20 = true;
      }
    }
  }
  if(takeHit == -1) takeHit = indexOfBen20;
  
  def = playField.get(takeHit);
  int opp = playField.get(takeHit).player;
  String defName = playField.get(takeHit).name;
  String atkName; 
  
  // Direct damage spells or effects. Basically whenever there isn't a card attacking, or it is a special effect that is doing the damage, not the card itself.
  
  int spellAttack = -1;
  // Here, nullified cards automatically get their effects removed as their name is changed. Some cards still need to be hardcoded however.
  if(attacker == -1) playerSelected = true;
  if(attacker < -1) { spellAttack = attacker; attacker = -1; loop = false;} // FIREBALL
  if(spellAttack == -1) {
  ATKX.add(playField.get(takeHit).x); ATKY.add(playField.get(takeHit).y); inAnimation = true; animationMode = 1; aniTimer = 0; }
  
  if(attacker == -1)
    atkName = "NonCard";
  else 
    atkName = playField.get(attacker).name;
    
  if(hasEffect(playField.get(takeHit), "Nullify"))
    defName = "Nulled";
   
  int atk;
  hit = new Card();
  if(attacker != -1)
  {
    hit = playField.get(attacker);
    if(hasEffect(playField.get(attacker), "Nullify"))
      atkName = "Nulled";
    atk = hit.ATK; // Card Attack
  } 
  else 
    atk = 5; // Player Attack
  if(spellAttack < -1) atk = spellAttack * -1; // Spell Attack
  
  if(hasBen20) {takeHit = indexOfBen20; defName = "Ben 2.0"; def = playField.get(indexOfBen20);}
  
  if(def.cost > 4 && atkName == "Antnohy")
    atk += 3;
  
  if(atkName == "Ben")
  {
    for(Card d: playField)
    {
      if(d.category.contains(2) && d.player == hit.player)
        atk++;
    }
  }
  
  if(atkName == "Ms. Nicke")
  {
    for(Card d: playField)
    {
      if(d.name == "Esther" && d.player == hit.player)
      {
        if(def.category.contains(2))
          atk += 12;
        else 
          atk += 7;
      }
    }
  }
  
  if(atkName == "Joseph")
  {
    for(Card d: playField)
    {
      if(d.name == "Annika" && d.player == hit.player)
        atk *= 3;
    }
  }
 
  if(atkName == "Ms. Fillip")
  {
    p[def.player].HP--;
  }
  if(atkName == "A.L.I.C.E.")
  {
    for(Card d: playField)
    {
      if(d.name == "Moonlight" && d.player == hit.player)
        atk *= 2;
    }
  }
  
  if(hasEffect(def, "RawEggs")) atk += 3;
  
  if(atkName == "Andrew" && def.category.contains(2)) atk += 3;
  
  boolean oppHas8H = false;
  
  if(attacker > -1) // Setting up attack nerfs/ buffs. Generally this requires the attacker to be a card and not a spell.
  {
    for(Card c: playField)
    {
      if(loop)
      {     
        if(c.name == "Hexagonal" && c.player == def.player && hit.player != c.player && !hasEffect(c, "Nullify"))
        {
          int index = playField.indexOf(c);
          playField.get(index).HP -= 2;
          if(index > -1 && attacker > -1)
            attackCard(index, attacker, false);
        }
        if(c.name == "Ms. Fillip" && c.player != def.player && hit.player == c.player && hit.category.contains(6) && !hasEffect(c, "Nullify") && c != playField.get(attacker))
        {
          int index = playField.indexOf(c);
          if(index > -1 && attacker > -1)
            attackCard(index, takeHit, false);
        }
      }
      if(c.name == "Mr. Valentino" && c.player != def.player && hit.player == c.player && hit.category.contains(6) && !hasEffect(c, "Nullify") && c != playField.get(attacker))
      {
        playField.get(attacker).HP++;
        c.HP++;
      }  
    }
    
    if(hasEffect(playField.get(attacker), "2X ATK") || hasEffect(playField.get(attacker), "2X ATK (Anny)")) atk *= 2;
      
    if(!hasEffect(playField.get(attacker), "NoEffect"))
    {
      for(Card c: playField)
      {
        if(c.name == "Ben" && playField.get(attacker).category.contains(2) && playField.get(attacker).player == c.player && !hasEffect(c, "Nullify")) atk += 3;
        if(c.name == "Rita" && c.player != playField.get(attacker).player && !hasEffect(c, "Nullify")) atk = max(0, atk - 1);
        
        if(hasEffect(playField.get(attacker), "BuffsLucy")) if(c.player == opp && hasEffect(c, "GetsBuffed")) c.ATK++;
      }
    }
    
    if(hit.name == "Mr. Pegamah" && !hasEffect(hit, "Nullify")) atk = 4;
    
    if(defName == "Selina" && playField.get(attacker).cost <= 2) atk = 0; 
    if(defName == "Bonnie")
    {
      if(playField.get(attacker).HP > 8)
        atk = 0;
    }
    
    if(playField.get(attacker).category.contains(0) && defName == "Neil")
      atk = 2;
    if(playField.get(attacker).category.contains(1) && defName == "Florence")
      atk = 3;
  }
  for(Card c: playField)
  {
    if(c.category.contains(1) && c != playField.get(takeHit)) oppHas8H = true;
    if(c.player == playField.get(takeHit).player && c.name == "A.L.I.C.E." && !hasEffect(c, "Nullify") && !def.NBTTags.contains("Unhealable")) atk = max(0, atk - 3);
  }
  
  if(defName == "Vinod" && oppHas8H)
    atk = max(0, atk - 8);
  
  if(hasBen20) atk /= 2;
  
  if(atkName == "Moonlight")
  {
    p[playField.get(takeHit).player % 2 + 1].HP += atk / 2;
    playField.get(attacker).HP += atk / 2;
  }
  
  if(defName == "Steven") atk = max(0, atk - 1);
  
  if(hasEffect(def, "Defense"))
    atk = max(0, atk - 3);
  
  
  for(int i = -1; i <= 1 && !hasEffect(def, "NoEffect") && !def.NBTTags.contains("Unhealable"); i++)
  {
    for(int j = -1; j <= 1; j++)
    {
      int index = findCard(def.x + i, def.y + j, def.player);
      if(index != -1)
      {
        if(playField.get(index).name == "Angela" && !hasEffect(playField.get(index), "Nullify")) atk = max(0, atk - 3);
      }
    }
  }
  
  // Precalculations
  playField.get(takeHit).HP -= atk; 
  // Actual Effects
  
  if(atkName == "Vithiya" && mode == 0)
  {
    if(p[playerTurn].deck.size() > 0)
    {
      p[playerTurn].hand.add(p[playerTurn].deck.get(0));
      p[playerTurn].deck.remove(0);
    }
  }
  
  if(atkName == "Odelia")
  {
    playField.get(takeHit).ATK = max(0, playField.get(takeHit).ATK - 4);
    addEffect(1, takeHit, "Stun");
  }
  
  if(defName == "Ilem" && loop)
  {
    for(int i = 0; i < 30; i++)
    {
      int xPos = i % 5 + 1;
      int yPos = i / 5 + 1;
      if(findCard(xPos, yPos, def.player % 2 + 1) != -1)
      {
        attackCard(-3, findCard(xPos, yPos, def.player % 2 + 1), true);
      }
    }
  }
  
  if(atkName == "J.Flipped")
    addEffect(1, takeHit, "HitStun");
    
  for(Effect e: playField.get(takeHit).effects)
  {
    if(e.name == "HealDisable")
    {
      def.effects.remove(e);
      break;
    }
  }
  
  // Buff upon hit or getting hit
  if(defName == "Kevin")
    playField.get(takeHit).ATK += 2;
  
  if(defName == "Chad")
    playField.get(takeHit).ATK += 3;
  
  if(defName == "Crystal Clear")
    playField.get(takeHit).ATK += 8;
  
  if(hasEffect(playField.get(takeHit), "Attack"))
    playField.get(takeHit).ATK += 2;
  
  if(atkName == "Jennifer")
    playField.get(attacker).ATK += 2; 
  
  if(atkName == "Mr. Utnapis")
  {
    playField.get(attacker).ATK+=2;
    playField.get(attacker).HP+=2;
  }
    
  if(atkName == "Kabilan")
    playField.get(attacker).RNG++;
  
  if(atkName == "Mark" && mode == 0)
  {
    if(playField.get(takeHit).HP <= 0 && !hasEffect(playField.get(takeHit), "Resurrect"))
    {
      if(p[playerTurn].deck.size() > 0)
        drawCard();
    }
  }
  
  if(atkName == "Yousif" && p[opp].hand.size() > 0 && mode == 0)
  {
    if(playField.get(takeHit).HP <= 0 && !hasEffect(playField.get(takeHit), "Resurrect"))
    {
      int tempValue;
      tempValue = PApplet.parseInt(random(p[opp].hand.size()));
      if(!p[opp].hand.get(tempValue).summoned)
        p[opp].deck.add(resetCard(p[opp].hand.get(tempValue)));
      p[opp].hand.remove(tempValue);
    }
  }
  
  if(defName == "Uzziah" && (playField.get(takeHit).HP > 0 || hasEffect(playField.get(takeHit), "Resurrect")))// If it died ofc it wont go back to their hand
  {
    if(mode == 0)
    {
      Card c = playField.get(takeHit).copy();
      c.ATK += 2;
      c.HP += 2;
      c.summoned = true;
      p[opp].hand.add(c); 
    }
    specialRemove = takeHit;
  }
  
  if(!hasEffect(playField.get(takeHit), "NoEffect"))
  { 
    if(atkName == "Annika" && (playField.get(takeHit).HP > 0 || hasEffect(playField.get(takeHit), "Resurrect")) && defName != "Uzziah")
    {
      Card temp;
      if(attacker != -1)
      {
        temp = playField.get(attacker);
        playField.remove(takeHit);
        playFieldSelected = playField.indexOf(temp);
        attacker = playFieldSelected;
      }
      else
      {
        playField.remove(takeHit);
        playFieldSelected = -1;
        attacker = playFieldSelected;
      }
      if(defName == "Money Farm" && mode == 0) p[opp].cash += 4;
      for(Card c: collection)
      {
        if(c.name == defName)
        {
          Card copy = c.copy();
          copy.summoned = true; 
          if(mode == 0)
            p[opp].hand.add(copy);
          break;
        }
      }
    }
    if(atkName == "Ms. Aftner" && !(playField.get(takeHit).HP <= 0 && !hasEffect(playField.get(takeHit), "Resurrect")))
    {
      addEffect(1, takeHit, "Stun");
      if(playField.get(takeHit).player == 1)
      {
        int py = playField.get(takeHit).y, px = playField.get(takeHit).x;
        for(int i = py + 1; i <= py + 2; i++)
        {
          // YEs this is neccesary lmao
          if(findCard(px, i) == -1 && i <= 6) 
          {
            playField.get(takeHit).y = i; 
          }
          else break; 
        }
      }
      if(playField.get(takeHit).player == 2)
      {
        int py = playField.get(takeHit).y, px = playField.get(takeHit).x;
        for(int i = py - 1; i >= py - 2; i--)
        {
          if(findCard(px, i) == -1 && i >= 1) 
          {
            playField.get(takeHit).y = i; 
          }
          else break; 
        }
      }
    }
  }
}

public boolean name(Card c, String name)
{
  if(c.name == name && !hasEffect(c, "Nullify")) return true; else return false;
}

public void checkDeaths()
{
  if(specialRemove != -1)
  {
    playField.remove(specialRemove);
    specialRemove = -1;
    playFieldSelected = -1;
  }
  ArrayList <Card> tempRemove = new ArrayList <Card>(); // Adding all cards that are about to die, in this list.
  for(Card c: playField)
  { 
    c.ATK = max(c.ATK, 0); // No negative attacks.
    if(hasEffect(c, "Stun")) // No moving if stunned.
      c.canMove = false;
    if(hasEffect(c, "HitStun")) // No attacking if stunned.
      c.attackCount = 0;
    if(c.HP <= 0)
    {
      if(c.name == "Hexagonal" && !hasEffect(c, "Nullify"))
      {
        for(int i = 0; i < 30; i++)
        {
          int xPos = i % 5 + 1;
          int yPos = i / 5 + 1;
          if(findCard(xPos, yPos, c.player % 2 + 1) != -1)
          {
            attackCard(-4, findCard(xPos, yPos, c.player % 2 + 1), true);
          }
        }
      }
      if(c.name == "Mr. Ustenglibo" && !hasEffect(c, "Nullify"))
      {
        for(Card d: playField)
        {
          if(c.player == d.player && d.category.contains(6) && !hasEffect(d, "NoEffect"))
          {
            addEffect(1, d, "Invincible");
          }
        }
      }
      if(c.name == "Physouie" && !hasEffect(c, "Nullify") && mode == 0)
      {
        ArrayList <Card> temp = new ArrayList<Card>();
        for(Card d: collection)
        {
          if(d.category.contains(2))
          {
            temp.add(d);
          }
        }
        for(int i = 0; i < 3; i++)
        {
          int rand = PApplet.parseInt(random(temp.size()));
          Card a = temp.get(rand).copy();
          a.ATK+=2;
          a.HP+=2;
          a.cost = max(0, a.cost - 2);
          a.summoned = true;
          p[c.player].hand.add(a);
        }
      }
      if(c.name == "Mr. Websterien" && !hasEffect(c, "Nullify") && mode == 0)
      {
        Card a = collection[searchCard("Mr. Pegamah")].copy();
        a.RNG++;
        a.summoned = true;
        p[c.player].hand.add(a); 
      }
      if(hasEffect(c, "Resurrect") && !hasEffect(c, "Nullify"))
      {
        if(c.name == "Kevin")
        {          
          c.ATK += 5;          
        }
        c.HP = 1;
        if(c.name == "Ilem")
        {
          for(Card d: playField)
          {
            if(d.category.contains(2) && d.player == c.player && !hasEffect(d, "NoEffect"))
              d.ATK += 2;
          }
          c.ATK = 20;
          c.HP = 20;
        }
        int index = 0;
        for(Effect e: c.effects)
        {
          if(e.name == "Resurrect")
            index = c.effects.indexOf(e);
        }
        c.effects.remove(index);
      }
      else
      {
        playFieldSelected = -1;
        cardSelected = -1;
        tempRemove.add(c);
      }
    }
  }
  
  if(tempRemove.size() > 0)
  {
    for(Card c: tempRemove)
    {
      playField.remove(c); // BOOOM DEAD CARD
    }
  }
}
