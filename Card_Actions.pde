public void moveCard(int index, int dist)
{
  playFieldSelected = index; // Sets the selected card as the card moving.
  startMoveAnimation(false, index, dist, playField.get(index).y);
  playField.get(index).y += dist;
}

public void moveCardSide(int index, int dist)
{
  playFieldSelected = index; // Sets the selected card as the card moving.
  startMoveAnimation(true, index, dist, playField.get(index).x);
  playField.get(index).x += dist;
}

public void placeCard(int player, Card baseCard, int x, int y, boolean spawned)
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 1;
    m.player = player;
    m.cardPlaced = baseCard; 
    m.cardSpawned = spawned;
    m.x = x;
    m.y = y;
    moves.add(m); // Puts this card into the queue, for when it is your opponents' turn. (Animating your moves to your opponent)
  }
  Card temp = baseCard.copy();
  temp.player = player;
  temp.x = x;
  temp.y = y;
  temp.attackCount = 1;
  temp.canMove = true;
  temp.turnPlacedOn = p[player].turn;
  startAnimation(5, temp.x, temp.y);
  
  // Special Targeted Effects
  int num = 0; // #of enemy cards
  for(Card c: playField)
    if(c.player == player % 2 + 1 && !hasEffect(c, "NoEffect"))
      num++;
  if(!temp.spawned)
    playFieldSelected = playField.size();
  if(temp.NBTTags.contains("OppTargetedEffect") && num > 0 && mode == 0 && !spawned) // Cards spawned cannot have their own special targeted effect.
    abilitySelected = playField.size();
  if(temp.NBTTags.contains("YouTargetedEffect") && mode == 0 && !spawned)
    abilitySelected = playField.size();
    
  // Cards' Effects - Only Effect the card being placed:
  
  // Status Effects upon Spawn
  if(temp.name.equals("Jefferson") || temp.name.equals("Mr. Ustenglibo"))
    addEffect(-1, temp, "NoEffect"); // Makes the card uneffectable
  if(temp.name.equals("Lina"))
    addEffect(-1, temp, "HealDisable"); // Special effect that goes away when card gets attacked
  if(temp.name.equals("Mr. Pegamah"))
    temp.turnPlacedOn--; // Pretends the card was placed on a different turn, so it can attack player first turn
  if(temp.name.equals("Tony") || temp.name.equals("Joseph") || temp.name.equals("Physouie") || temp.name.equals("Mr. Farewell"))
    addEffect(3, temp, "Alive"); // Dies in 3 turns
  if(temp.name.equals("Mr. Onosukoo"))
    addEffect(1, temp, "Alive"); // Dies in 1 turn
  if(temp.name.equals("Kevin") || temp.name.equals("Ilem"))
    addEffect(-1, temp, "Resurrect"); // These cards resurrect once upon dying
  if(temp.name.equals("Anny"))
    addEffect(3, temp, "2X ATK (Anny)"); // Double attack for 3 turns.
  if(temp.name.equals("Lucy"))
  {
    addEffect(-1, temp, "GetsBuffed"); // Gets buffed whenever opponents' cards with the "BuffsLucy" attacks
    for(Card c: playField)
      if(c.player != temp.player) // Gives the effect to all of the opponents' cards
        addEffect(-1, c, "BuffsLucy");
  }
  if(temp.name.equals("Snake"))
  {
    temp.turnPlacedOn = p[player % 2 + 1].turn; // Switches player
    temp.player = temp.player % 2 + 1;
    addEffect(3, temp, "Alive"); // Dead after 3 turns.
  }
  
  // Conditional Stat Values
  if(temp.name.equals("Jefferson"))
    temp.ATK++;
  if(temp.name.equals("Megan"))
    temp.HP = ceil(p[temp.player].HP / 3.0); // HP is player's HP / 2
  int countNovelty = 0;
  for(Card c: playField)
    if(c.category.contains(6) && c.player == player)
      countNovelty++;
  if(temp.name.equals("Mr. Willikens"))
    temp.ATK = countNovelty;
  if(temp.name.equals("Mr. Billikens"))
    temp.HP += countNovelty;
  if(temp.name.equals("Sharnujan"))
    for(Card c: playField)
      if(c.player == temp.player && c.cost > 4) 
      {
        temp.RNG += 4; // Sets special range if there is a $4 or more
        break;
      }
  
  for(Card c: playField) // Current cards on the playfield that have an action once you place down a card
  {
    if(!hasEffect(temp, "NoEffect"))
    {
      if(name(c, "Samuel") && c.player == player)   
        if(temp.category.contains(2)) 
          temp.ATK+=2;
        else 
          temp.ATK++;
      if(name(c, "Kenneth") && c.player == player)
      {
        temp.ATK+=2;
        if(temp.category.contains(2)) heal(temp, 2);
      }
      if(name(c, "Lucy") && c.player != player)
        addEffect(-1, temp, "BuffsLucy");
      if(name(c, "Mr. Filascario") && c.player != player)
      {
        temp.ATK -= 2; 
        temp.HP -= 2;
        temp.ATK = max(0, temp.ATK);
      }
    }
  }

  // Special Tags
  if(temp.NBTTags.contains("SpecialMove"))
    temp.canSpecial = true; // Cards with this tag have a special move, set this to true
  if(temp.name.equals("Bonnie"))
    temp.attackCount = 2; // Can attack twice
  
  playField.add(temp); // Adding Cards
  
  // Post-adding effects
  
  // Buff all cards
  if(temp.NBTTags.contains("InstantBuffer"))
  {
    for(Card c: playField)
    {
      if(c.player == player && !hasEffect(c, "NoEffect"))
      {
        if(temp.name.equals("A.L.I.C.E.") && temp == c) break;
        if(c.category.contains(temp.condition))
        {
          c.ATK += temp.conditionATKBuff;
          heal(c, temp.conditionHPBuff);
        }
        else
        {
          c.ATK += temp.ATKBuff;
          heal(c, temp.HPBuff);
        }
      }
    }
  }

  // Everything Else
  if(temp.name.equals("Mark") && mode == 0)
    for(int i = 0; i < 2; i++)
      if(p[playerTurn].deck.size() > 0) // Draws cards
          drawCard();
  if(temp.name.equals("Richard") && mode == 0)
  {
    if(p[player % 2 + 1].hand.size() > 0) // Sends a card back to their deck
    {
      int rand = PApplet.parseInt(random(p[player % 2 + 1].hand.size()));
      if(!p[player % 2 + 1].hand.get(rand).summoned)
        p[player % 2 + 1].deck.add(resetCard(p[player % 2 + 1].hand.get(rand)));
      p[player % 2 + 1].hand.remove(rand);
    }
  }
  
  if(temp.name.equals("Mr. Valentino"))
    if(mode == 0)
      for(Card c: playField)
        if(c.player == temp.player && c.category.contains(6) && !hasEffect(c, "NoEffect"))
          c.attackCount++;
  if(temp.name.equals("Mr. Facto"))
  {
    ArrayList <Card> tempC = new ArrayList<Card>();
    if(mode == 0)
    {
      tempC = new ArrayList<Card>();
      for(Card d: collection)
        if(d.category.contains(6))
          tempC.add(d);
      Card c = tempC.get(PApplet.parseInt(random(tempC.size()))).copy();
      c.summoned = true;
      c.cost -= 3; if(c.cost < 0) c.cost = 0;
      p[temp.player].hand.add(c);
    }
  }
  
  if(temp.name.equals("Mr. Stirrychigg"))
  {
    Card a = collection[searchCard("Mr. Utnapis")].copy();
    a.summoned = true;
    a.spawned = true;
    int summonY = temp.y, summonX = temp.x; if(temp.player == 1) summonY--; else summonY++; 
    if(findCard(summonX, summonY) == -1 && mode == 0) placeCard(player, a, summonX, summonY, true);
  }
  
  if(temp.name.equals("Yebanow") && mode == 0)
  {
    ArrayList <Card> tempC = new ArrayList<Card>();
    tempC = new ArrayList<Card>();
    for(Card d: collection)
      if(!d.isSpell && d.cost == 1)
        tempC.add(d);
    for(int i = 0; i < 4; i++)
    {
      int summonX = temp.x; int summonY = temp.y; if(i == 0) summonX++; if(i == 1) summonX--; if(i == 2) summonY++; if(i == 3) summonY--;
      int rand = PApplet.parseInt(random(tempC.size()));
      Card a = tempC.get(rand).copy();
      a.summoned = true;
      a.spawned = true;
      boolean canUse = true; if(summonX > 5 || summonX < 1 || summonY > 6 || summonY < 1 || findCard(summonX, summonY, 1) != -1 || findCard(summonX, summonY, 2) != -1) canUse = false;
      if(canUse) placeCard(player, a, summonX, summonY, true);
    }
  }

  if(temp.name.equals("Jason P"))
  {
    for(Card c: playField)
      if(c.player != temp.player)
          addEffect(1, c, "Slowdown");
    if(temp.player == 1)
    {
      for(int i = 2; i <= 6; i++)
      {
        for(Card c: playField)
        {
          if(c.player == 2 && c.y == i && !hasEffect(c, "NoEffect"))
          {
            int maxDistMove = 0;
            for(int j = i - 1; j >= 1; j--)
            {
              boolean canMove = true;
              for(Card d: playField)
                if(d.x == c.x && d.y == j)
                  canMove = false;
              if(canMove)
                maxDistMove = j - c.y;
              else break;
            }
            if(maxDistMove != 0)
            {
              startMoveAnimation(false, playField.indexOf(c), maxDistMove, c.y);
              c.y += maxDistMove;
            }
          }
        }
      }
    }
    else 
    {
      for(int i = 5; i >= 1; i--)
      {
        for(Card c: playField)
        {
          if(c.player == 1 && c.y == i && !hasEffect(c, "NoEffect"))
          {
            int maxDistMove = 0;
            for(int j = i + 1; j <= 6; j++)
            {
              boolean canMove = true;
              for(Card d: playField)
                if(d.x == c.x && d.y == j)
                  canMove = false;
              if(canMove)
                maxDistMove = j - c.y;
              else break;
            }
            if(maxDistMove != 0)
            {
              startMoveAnimation(false, playField.indexOf(c), maxDistMove, c.y);
              c.y += maxDistMove;
            }
          }
        }
      }
    }
  }
  if(temp.name.equals("Moonlight"))
    p[temp.player].HP += 6; // Increase player HP
    
  // Cards with an alternative ability whenever you place down a card, that effects IT and not the card being placed.  
  
  // Mr. Bing
  for(Card c: playField)
  {
    if(name(c, "Mr. Bing") && c.player == player)
    {
      c.ATK += 2;
      heal(c, 2);
    }
  }

  // Mr. Farewell 
  if(!spawned && mode == 0) // Cards must NOT be spawned out of any spell/card.
  {
    ArrayList <Card> toSummon = new ArrayList <Card>();
    for(Card c: collection)
      if(c.cost <= 2 && !c.isSpell) toSummon.add(c);

    ArrayList <Card> add = new ArrayList<Card>();
    for(Card d: playField)
    {
      if(name(d, "Mr. Farewell") && d.player == player && d != temp)
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
        if(findCard(i, yPos) == -1) availible.add(i);
      if(availible.size() > 0)
      {
        int i = availible.get(PApplet.parseInt(random(availible.size())));
        placeCard(player, add.get(0), i, yPos, true);
        availible.remove(availible.indexOf(i));
      } else break;
      add.remove(0);
    }
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
  int atk = playField.get(attacker).ATK;
  
  
  for(Card c: playField)
  {
    if(c.name.equals("Ben 2.0") && c.player == opp)
    {
      attackCard(attacker, playField.indexOf(c), true); // If Ben 2.0 Is on field, Swap methods.
      return;
    }
  }
  startAnimation(1, -1, -1); 
  
  // Figuring out correct attack needed
  
  // Special damage towards player
  if(name.equals("Andrew")) atk += 5;
  if(name.equals("Mr. Pegamah")) atk = 8;
  
  
  if(name.equals("A.L.I.C.E."))
    for(Card d: playField)
      if(d.name.equals("Moonlight") && d.player == playField.get(attacker).player)
        atk *= 2;
  if(name.equals("Ben"))
    for(Card d: playField)
      if(d.category.contains(2) && d.player == playField.get(attacker).player)
        atk++;

  if(!hasEffect(playField.get(attacker), "NoEffect"))
  {
    for(Card c: playField)
    {
      if(c.name.equals("Ben") && playField.get(attacker).category.contains(2) && playField.get(attacker).player == c.player) atk += 3;
      if(c.name.equals("Rita") && c.player != playField.get(attacker).player) atk = max(0, atk - 2);
      if(hasEffect(playField.get(attacker), "BuffsLucy")) if(c.player == opp && hasEffect(c, "GetsBuffed")) c.ATK++;
    }
  }
  
  if(hasEffect(playField.get(attacker), "2X ATK") || hasEffect(playField.get(attacker), "2X ATK (Anny)")) atk *= 2;
  
  p[opp].HP -= atk; // Doing the damage
  
  // Effects upon attacking
  if(name.equals("Jennifer"))
    playField.get(attacker).ATK+=2;
    
  if(name.equals("Vithiya") && mode == 0)
    drawCard();
    
  if(name.equals("Mr. Utnapis"))
  {
    playField.get(attacker).ATK+=2;
    playField.get(attacker).HP+=2;
  }

  if(name.equals("Kabilan"))
    playField.get(attacker).RNG++;
    
    
  if(name.equals("Moonlight"))
  {
    p[playField.get(attacker).player].HP += atk / 2;
    playField.get(attacker).HP += atk / 2;
  }
  
  for(Card c: playField)
  {
    if(c.name.equals("Mr. Valentino") && c.player == playField.get(attacker).player && playField.get(attacker).category.contains(6) && c != playField.get(attacker))
    {
      playField.get(attacker).HP++;
      c.HP++;
    }
  }
}

public void attackCard(int attacker, int takeHit, boolean loop) // Logic for when a CARD GETS ATTACKED BY ANYTHING. This can be the PLAYER, SPELLS, AND CARDS
{
  // Preattacking Logic
  Card hit, def;
  boolean hasBen20 = false;
  int indexOfBen20 = -1;
  for(Card c: playField)
  {
    if(c.name.equals("Ben 2.0") && c.player == playField.get(takeHit).player)
    {
      if(playField.get(takeHit) != c)  
      {
        indexOfBen20 = playField.indexOf(c);
        hasBen20 = true;
      }
    }
  }
  
  def = playField.get(takeHit);
  int opp = playField.get(takeHit).player;
  String defName = playField.get(takeHit).name;
  String atkName; 
  
  // Direct damage spells or effects. Basically whenever there isn't a card attacking, or it is a special effect that is doing the damage, not the card itself.
  
  int spellAttack = -1;
  // Here, nullified cards automatically get their effects removed as their name is changed. Some cards still need to be hardcoded however.
  if(attacker == -1) playerSelected = true;
  if(attacker < -1) { spellAttack = attacker; attacker = -1; loop = false;} // FIREBALL
  if(attacker == -1)
    atkName = "NonCard";
  else 
    atkName = playField.get(attacker).name;
   
  int atk;
  hit = new Card();
  if(attacker != -1)
  {
    hit = playField.get(attacker);
    atk = hit.ATK; // Card Attack
  } 
  else 
    atk = 5; // Player Attack
  if(spellAttack < -1) atk = spellAttack * -1; // Spell Attack
  
  if(hasBen20) {
    takeHit = indexOfBen20; defName = "Ben 2.0"; def = playField.get(indexOfBen20);
  }
  if(spellAttack == -1) 
    startAnimation(1, playField.get(takeHit).x, playField.get(takeHit).y);
    
  // Precalculations - How much damage needs to be dealt! NO OTHER EFFECTS HERE.  
  
  if(attacker > -1) // Setting up attack nerfs/ buffs. Generally this requires the attacker to be a card and not a spell.
  {
    if(!hasEffect(playField.get(attacker), "NoEffect")) // "If Alive" Sort of cards, which buff/nerf all cards.
    {
      for(Card c: playField)
      {
        if(c.name.equals("Mandaran") && max(abs(c.x - hit.x), abs(c.y - hit.y)) <= 1 && hit.category.contains(3) && hit.player == c.player) atk += 3;
        if(c.name.equals("Ben") && playField.get(attacker).category.contains(2) && playField.get(attacker).player == c.player) atk += 3;
        if(c.name.equals("Rita") && c.player != playField.get(attacker).player) atk = max(0, atk - 2);
        if(hasEffect(playField.get(attacker), "BuffsLucy")) if(c.player == opp && hasEffect(c, "GetsBuffed")) c.ATK++;
      }
    }
    
    // Duo Cards: Gets higher attack value if you have specific cards on the field.
    if(atkName.equals("Ben"))
      for(Card d: playField)
        if(d.category.contains(2) && d.player == hit.player)
          atk++;
    if(atkName.equals("Ms. Nicke"))
    {
      for(Card d: playField)
      {
        if(d.name.equals("Esther") && d.player == hit.player)
        {
          if(def.category.contains(2))
            atk += 12;
          else 
            atk += 7;
        }
      }
    }
    if(atkName.equals("Joseph"))
      for(Card d: playField)
        if(d.name.equals("Annika") && d.player == hit.player)
          atk *= 3;
    if(atkName.equals("A.L.I.C.E."))
      for(Card d: playField)
        if(d.name.equals("Moonlight") && d.player == hit.player)
          atk *= 2;
    if(hasEffect(playField.get(attacker), "2X ATK") || hasEffect(playField.get(attacker), "2X ATK (Anny)")) atk *= 2;
    
    // Buffs/nerfs reliant on the defender having specific properties.
    if(def.cost > 4 && atkName.equals("Antnohy")) atk += 3;
    if(atkName.equals("Andrew") && def.category.contains(2)) atk += 3;
    if(defName.equals("Selina") && playField.get(attacker).cost <= 2) atk = 0; 
    if(defName.equals("Bonnie") && playField.get(attacker).HP > 8) atk = 0;
    if(playField.get(attacker).category.contains(1) && defName.equals("Florence")) atk = 3;
  }
  // General Damage reduction effects that are not reliant on there being an attacker.
  boolean has8H = false;
  for(Card c: playField)
  {
    if(c.name.equals("Angela") && !hasEffect(def, "NoEffect") && !def.NBTTags.contains("Unhealable") && max(abs(c.x - def.x), abs(c.y - def.y)) <= 1 && def.player == c.player)
    {
      atk = max(0, atk - 3);
      if(def.category.contains(3)) atk = max(0, atk - 1);
      if(def.category.contains(1)) atk = max(0, atk - 1);
    }
    if(c.category.contains(1) && c != playField.get(takeHit) && defName.equals("Vinod")) has8H = true;
    if(c.player == playField.get(takeHit).player && c.name.equals("A.L.I.C.E.") && !def.NBTTags.contains("Unhealable")) atk = max(0, atk - 3);
  }
  if(has8H) atk = max(0, atk - 8);
  if(hasEffect(def, "RawEggs")) atk += 3;
  if(hasBen20) atk /= 2;
  if(defName.equals("Steven")) atk = max(0, atk - 1);
  if(defName.equals("Mandaran")) atk = max(0, atk - 5);
  if(hasEffect(def, "Defense")) atk = max(0, atk - 3);

  playField.get(takeHit).HP -= atk; // Dealing Damage
  
  // Card effects that aren't damage reduction/buffing: THE ATTACKER.
  
  
  if(attacker != -1)
  {
    // Buffed upon attacking card doing their attack
    if(atkName.equals("Jennifer"))
      playField.get(attacker).ATK += 2; 
    if(atkName.equals("Uzziah"))
      playField.get(attacker).HP += 2; 
    if(atkName.equals("Mr. Utnapis"))
    {
      playField.get(attacker).ATK+=2;
      playField.get(attacker).HP+=2;
    }
    if(atkName.equals("Kabilan"))
      playField.get(attacker).RNG++;
      
    // Other Effects
    if(atkName.equals("Moonlight"))
    {
      p[playField.get(takeHit).player % 2 + 1].HP += atk / 2;
      playField.get(attacker).HP += atk / 2;
    }
    if(atkName.equals("Ms. Fillip"))
      p[def.player].HP--;
    if(atkName.equals("Vithiya") && mode == 0)
      drawCard(hit.player);
    if(atkName.equals("J.Flipped"))
      addEffect(1, takeHit, "HitStun");
      
    // Upon Killing
    if(playField.get(takeHit).HP <= 0 && !hasEffect(playField.get(takeHit), "Resurrect"))
    {
      if(atkName.equals("Mark") && mode == 0)
        if(p[playerTurn].deck.size() > 0)
            drawCard();
      if(atkName.equals("Esther") && mode == 0)
          p[playerTurn].cash += 3;
      if(atkName.equals("Yousif") && p[opp].hand.size() > 0 && mode == 0)
      {
        int tempValue;
        tempValue = PApplet.parseInt(random(p[opp].hand.size()));
        if(!p[opp].hand.get(tempValue).summoned)
          p[opp].deck.add(resetCard(p[opp].hand.get(tempValue)));
        p[opp].hand.remove(tempValue);
      }
    }
    
    if(!hasEffect(playField.get(takeHit), "NoEffect")) // Attacking card effecting the defending card
    { 
      if(atkName.equals("Odelia"))
      {
        playField.get(takeHit).ATK = max(0, playField.get(takeHit).ATK - 4);
        addEffect(1, takeHit, "Stun");
      }
      if(atkName.equals("Annika") && !playField.get(takeHit).returningToHand && (playField.get(takeHit).HP > 0 || hasEffect(playField.get(takeHit), "Resurrect")))
      {
        playField.get(takeHit).returningToHand = true;
        specialRemove.add(takeHit);
        for(Card c: collection)
        {
          if(c.name.equals(def.displayName))
          {
            Card copy = c.copy();
            copy.summoned = true; 
            if(mode == 0)
              p[opp].hand.add(copy);
            break;
          }
        }
      }
      if(atkName.equals("Ms. Aftner") && !(playField.get(takeHit).HP <= 0 && !hasEffect(playField.get(takeHit), "Resurrect")))
      {
        int knockback = 2; // Modify this to balance
        addEffect(1, takeHit, "Slowdown");
        if(playField.get(takeHit).player == 1)
        {
          int py = playField.get(takeHit).y, px = playField.get(takeHit).x;
          int distKnock = -127;
          for(int i = py + 1; i <= py + knockback; i++) // Basically checks tiles from the card being hit's position + 1, to their position + knockback value. If there is availible space all the way, teleport them there.
          {
            if(findCard(px, i) == -1 && i <= 6) 
              distKnock = i - playField.get(takeHit).y;              
            else break; 
          }
          if(distKnock != -127)
          {
            startMoveAnimation(false, takeHit, distKnock, playField.get(takeHit).y);
            playField.get(takeHit).y += distKnock;
          }
        }
        if(playField.get(takeHit).player == 2)
        {
          int py = playField.get(takeHit).y, px = playField.get(takeHit).x;
          int distKnock = -127;
          for(int i = py - 1; i >= py - knockback; i--)
          {
            if(findCard(px, i) == -1 && i >= 1) 
              distKnock = i - playField.get(takeHit).y; 
            else break; 
          }
          if(distKnock != -127)
          {
            startMoveAnimation(false, takeHit, distKnock, playField.get(takeHit).y);
            playField.get(takeHit).y += distKnock;
          }
        }
      }
    }
    if(loop) // Very Special!
    {
      for(Card c: playField) // Cards that have an effect when you attack a card/your card gets attacked that ISN'T The attacker or defender
      {
        if(c.player == def.player && hit.player != c.player) // When Getting Hit
        {
          if(c.name.equals("Hexagonal"))
          {
            int index = playField.indexOf(c);
            playField.get(index).HP -= 2;
            if(index > -1 && attacker > -1)
              attackCard(index, attacker, false);
          }
        }
        if(c.player != def.player && hit.player == c.player && c != playField.get(attacker)) // When Hitting
        {
          if(hit.category.contains(6))
          {
            if(c.name.equals("Ms. Fillip"))
            {
              int index = playField.indexOf(c);
              if(index > -1 && attacker > -1)
                attackCard(index, takeHit, false);
            }
            if(c.name.equals("Mr. Valentino"))
            {
              heal(hit, 1);
              heal(c, 1);
            }  
          }
        }
      }
    }
  }

  // Card effects that aren't damage reduction/buffing: THE DEFENDER.
  
  // Buffed when getting hit
  if(defName.equals("Kevin"))
    playField.get(takeHit).ATK += 2;
  if(defName.equals("Chad"))
    playField.get(takeHit).ATK += 3;
  if(defName.equals("Crystal Clear"))
    playField.get(takeHit).ATK += 12;
  if(hasEffect(playField.get(takeHit), "Attack"))
    playField.get(takeHit).ATK += 2;
  
  // Other 
  if(defName.equals("Ilem") && loop)
  {
    for(int i = 0; i < 30; i++)
    {
      int xPos = i % 5 + 1;
      int yPos = i / 5 + 1;
      if(findCard(xPos, yPos, def.player % 2 + 1) != -1)
        attackCard(-3, findCard(xPos, yPos, def.player % 2 + 1), true);
    }
  }
    
  for(Effect e: playField.get(takeHit).effects)
  {
    if(e.name.equals("HealDisable"))
    {
      def.effects.remove(e);
      break;
    }
  }
}

public boolean name(Card c, String name)
{
  if(c.name.equals(name)) return true; else return false;
}

public void checkDeaths() // Death Effects, and removing cards when dead
{
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
      if(c.name.equals("Hexagonal"))
      {
        for(int i = 0; i < 30; i++)
        {
          int xPos = i % 5 + 1;
          int yPos = i / 5 + 1;
          if(findCard(xPos, yPos, c.player % 2 + 1) != -1)
            attackCard(-4, findCard(xPos, yPos, c.player % 2 + 1), true);
        }
      }
      if(c.name.equals("Mr. Ustenglibo"))
        for(Card d: playField)
          if(c.player == d.player && d.category.contains(6) && !hasEffect(d, "NoEffect"))
            addEffect(1, d, "Invincible");
      if(c.name.equals("Physouie") && mode == 0)
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
      if(c.name.equals("Mr. Websterien") && mode == 0)
      {
        Card a = collection[searchCard("Mr. Pegamah")].copy();
        a.RNG++;
        a.summoned = true;
        p[c.player].hand.add(a); 
      }
      if(hasEffect(c, "Resurrect"))
      {
        if(c.name.equals("Kevin"))  
          c.ATK += 5;          
        c.HP = 1;
        if(c.name.equals("Ilem"))
        {
          for(Card d: playField)
            if(d.category.contains(2) && d.player == c.player && !hasEffect(d, "NoEffect"))
              d.ATK += 2;
          c.ATK = 20;
          c.HP = 20;
        }
        int index = 0;
        for(Effect e: c.effects)
          if(e.name.equals("Resurrect"))
            index = c.effects.indexOf(e);
        c.effects.remove(index);
      }
      else
      {
        playFieldSelected = -1;
        cardSelected = -1;
        if(!c.returningToHand)
          tempRemove.add(c);
      }
    }
  }
  for(int i: specialRemove)
  {
    tempRemove.add(playField.get(i));
    playFieldSelected = -1;
  }
  specialRemove.clear();
  for(Card c: tempRemove)
    playField.remove(c); // BOOOM DEAD CARD
}
