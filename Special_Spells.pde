public void useSpell(String name, int indexEffect)
{
  Card Effected = playField.get(indexEffect);
  startAnimation(7, Effected.x, Effected.y, name);
  int index = -1;
  for(int i = 0; i < collection.length; i++)
  {
    if(collection[i].name.equals(name))
      index = i;
  }
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 2;
    m.targeted = indexEffect;
    m.name = name;
    moves.add(m);
  }
  if(name.equals("German Machine Guns"))
  {
    Effected.attackCount++;
  }
  if(name.equals("Defense Position"))
  {
    addEffect(-1, indexEffect, "Resurrect");
    addEffect(-1, indexEffect, "Defense");
  }  
  if(name.equals("Attack Position"))
  {
    Effected.ATK+=6;
    addEffect(-1, indexEffect, "Attack");
  }
  if(name.equals("Fireball"))
  {
    attackCard(-12, indexEffect, true); // -2: Fireball, -3: Holy Hand Grenade Center, -4 
  }
  if(name.equals("Zoo Wee Mama!"))
  {
    attackCard(-8, indexEffect, true); // -2: Fireball, -3: Holy Hand Grenade Center, -4 
  }
  if(name.equals("Mini Gulag"))
  {
    for(int l = 0; l < 9; l++)
    {
      int x = Effected.x, y = Effected.y;
      x += l % 3 - 1;
      y += l / 3 - 1;
      if(findCard(x, y, Effected.player) != -1)
      {
        playField.get(findCard(x, y, Effected.player)).ATK = max(0, playField.get(findCard(x, y, Effected.player)).ATK - 4);
        playField.get(findCard(x, y, Effected.player)).HP = max(0, playField.get(findCard(x, y, Effected.player)).HP - 4);
      }
    }
  }
  if(name.equals("Holy Hand Grenade"))
  {
    attackCard(-9, indexEffect, true);
    for(int l = 0; l < 9; l++)
    {
      if(l != 4)
      {
        int x = Effected.x, y = Effected.y;
        x += l % 3 - 1;
        y += l / 3 - 1;
        if(findCard(x, y, Effected.player) != -1)
          attackCard(-6, findCard(x, y, Effected.player), true);
      }
    }
  }
  if(name.equals("Stall"))
  {
    addEffect(1, indexEffect, "Stun");
    if(mode == 0)
      drawCard();
  }
  if(name.equals("Miss Me"))
  {
    addEffect(1, indexEffect, "Invincible");
  }
  if(name.equals("Dragon Wings"))
  {
    Effected.MVMT += 2;
    Effected.RNG += 1;
  }
  if(name.equals("Mr. Sketch"))
  {
    Effected.ATK += 5;
    heal(Effected, 8);
  }
  if(name.equals("T-Pose"))
  {
    int oppCount = 0;
    for(Card c: playField)
    {
      if(c.player != Effected.player) {
        oppCount++;
        if(!hasEffect(c, "NoEffect"))
        {
          c.ATK--;
          c.HP--;
        }
      }
    }
    Effected.ATK += oppCount;
    heal(Effected, oppCount);
  }
  if(name.equals("Hit It Boys!"))
    addEffect(3, indexEffect, "SideMove");
  if(name.equals("Raw Eggs and Soy Sauce"))
  {
    Effected.ATK += 4;
    addEffect(-1, indexEffect, "RawEggs");
  }
  if(name.equals("Sebastian's Tea"))
    addEffect(-1, indexEffect, "Tea");
  if(name.equals("Novelty Wings"))
  {
    if(Effected.category.contains(6))
      addEffect(2, indexEffect, "NVW");
    else
      addEffect(1, indexEffect, "NVW");
  }
  if(name.equals("Mr. Tornado"))
  {
    String temp = Effected.name;
    Card c = collection[searchCard(temp)].copy();
    c.summoned = true;
    if(mode == 0 && index != -1)
      p[playerTurn % 2 + 1].hand.add(c);
      
    playField.remove(indexEffect);
    playFieldSelected = playField.indexOf(c);
  }
  if(name.equals("Windmill"))
  {
    String eName = Effected.name;
    if(!eName.equals("Ridge Rhea"))
      Effected.MVMT++;
    heal(Effected, min(Effected.HP, 14));
  }
}

public void spawnEffects(String name, int indexName, int indexSpawn)
{
  Card Effected = playField.get(indexSpawn);
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 3;
    m.targeter = indexName;
    m.targeted = indexSpawn;
    m.name = name;
    moves.add(m);
  }
  startAnimation(3, Effected.x, Effected.y);
  playFieldSelected = indexName;
  if(name.equals("Jason C"))
  {
    Effected.ATK = max(Effected.ATK - 8, 0);
    Effected.MVMT = max(Effected.MVMT - 1, 0);
  }
  else if(name.equals("Esther"))
  {
    Card temp = playField.get(indexName);
    int index = -1;
    for(int i = 0; i < collection.length; i++)
    {
      if(collection[i].name.equals(Effected.displayName))
        { index = i; temp = collection[i].copy(); }
    }
    temp.summoned = true;
    if(mode == 0 && index != -1)
      p[playerTurn % 2 + 1].hand.add(temp);
    playField.remove(indexSpawn);
    playFieldSelected = playField.indexOf(temp);
  }
  else if(name.equals("Jefferson"))
  {
    Effected.effects.clear();
    Effected.name = "Nullified";
    Effected.HP -= 5;
  }
  else if(name.equals("Mandaran"))
  {
    Effect e = new Effect();
    e.name = "Invincible";
    e.duration = 1;
    Effected.effects.add(e);
  }
  else if(name.equals("George"))
  {
    Effected.ATK += 3;
    heal(Effected, 4);
    if(Effected.category.contains(4))
    {
      Effected.ATK += 1;
      heal(Effected, 1);
    }
  }
  else if(name.equals("Anthony"))
  {
    Effected.ATK += 6;
    heal(Effected, 8);
    if(Effected.category.contains(2))
    {
      Effected.ATK += 2;
      heal(Effected, 2);
    }
    Effected.MVMT += 1;
  }
  else if(name.equals("Jawnie Dirp"))
  {
    Effected.ATK -= 6; Effected.ATK = max(0, Effected.ATK);
    Effected.HP -= 6;
  }
}

public void specialAbility(int indexUser, int indexOpp, String type)
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 11;
    m.targeter = indexUser;
    m.targeted = indexOpp;
    m.name = type;
    moves.add(m);
  }
  
  if(type.equals("Hubert"))
  {
    playFieldSelected = indexUser;
    heal(playField.get(indexOpp), 4);
    startAnimation(2, playField.get(indexOpp).x, playField.get(indexOpp).y);
  }
  if(type.equals("Ethan"))
  {
    playField.get(indexUser).HP = 0;
    playField.get(indexOpp).HP = 0;
    playField.get(indexUser).effects.clear();
    playField.get(indexOpp).effects.clear();
    startAnimation(4, playField.get(indexOpp).x, playField.get(indexOpp).y); selfX = playField.get(indexUser).x; selfY = playField.get(indexUser).y;
  }
  if(type.equals("Ms. Iceberg"))
  {
    playFieldSelected = indexUser;
    attackCard(-4, indexOpp, false);
    startAnimation(10, playField.get(indexOpp).x, playField.get(indexOpp).y);
  }
}

public void discard(int index)
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 6;
    m.targeter = index;
    moves.add(m);
  }
  playFieldSelected = index;
  addEffect(1, index, "Alive");
  startAnimation(6, playField.get(index).x, playField.get(index).y);
}

public void useSpell(int y, String name) // y is player.
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 2;
    m.player = y;
    m.name = name;
    m.nonTargeted = true;
    moves.add(m);
  }
  if(playerTurn == 1)
    startAnimation(7, 3, 4, name);
  else 
    startAnimation(7, 3, 3, name);
  
  if(name.equals("Expectations Ever Increasing"))
  {
    if(mode == 0)
    {
      for(Card c: p[y].hand)
      {
        if(!c.isSpell)
        {
          c.cost+=1;
          c.ATK += 4;
          heal(c, 4);
        }
      }
    }
  }
  if(name.equals("Propaganda Machine"))
  {
    if(mode == 0)
    {
      ArrayList<Card> temporary = new ArrayList<Card>();
      for(Card c: collection)
      {
        if(c.cost >= 3 && c.cost <= 5) temporary.add(c);
      }
      Card c = temporary.get(PApplet.parseInt(random(temporary.size()))).copy();
      c.cost --;
      c.summoned = true;
      p[y].hand.add(c);
    }
  }
  if(name.equals("Terminator"))
  {
    for(int i = 0; i < 30; i++)
    {
      int xPos = i % 5 + 1;
      int yPos = i / 5 + 1;
      if(findCard(xPos, yPos) != -1)
      {
        if(!hasEffect(playField.get(findCard(xPos, yPos)), "NoEffect"))
        {
          attackCard(-6, findCard(xPos, yPos), true);
        }
      }
    }
  }
  if(name.equals("Awakening"))
  {
    for(Card c: playField)
    {
      if(c.player == y && c.category.contains(2) && !hasEffect(c, "noEffect"))
      {
        c.ATK += 3;
        heal(c, 2);
      }
    }
  }
  if(name.equals("Elite's Calling") && mode == 0)
  {
    ArrayList <Card> Elites = new ArrayList <Card>();
    for(Card c: collection)
    {
      if(c.category.contains(2) && c.cost <= 4) Elites.add(c);
    }
    ArrayList <Integer> availible = new ArrayList<Integer>();
    int yPos = 6; if(y == 2) yPos = 1;
    for(int i = 1; i <= 5; i++)
    {
      if(findCard(i, yPos) == -1) availible.add(i);
    }
    // Ben
    if(availible.size() > 0)
    {
      Card c = collection[searchCard("Ben")].copy();
      c.summoned = true;
      c.spawned = true;
      int i = availible.get(PApplet.parseInt(random(availible.size())));
      availible.remove(availible.indexOf(i));
      placeCard(y, c, i, yPos, true);
    }
    // Hubert
    if(availible.size() > 0)
    {
      Card c = collection[searchCard("Hubert")].copy();
      c.summoned = true;
      c.spawned = true;
      int i = availible.get(PApplet.parseInt(random(availible.size())));
      availible.remove(availible.indexOf(i));
      placeCard(y, c, i, yPos, true);
    }
    // Randoms
    for(int i = 0; i < 3; i++)
    {
      if(availible.size() > 0)
      {
        Card c = Elites.get(PApplet.parseInt(random(Elites.size()))).copy();
        c.summoned = true;
        c.spawned = true;
        int j = availible.get(PApplet.parseInt(random(availible.size())));
        availible.remove(availible.indexOf(j));
        placeCard(y, c, j, yPos, true);
      }
    }
    
  }
  if(name.equals("The Duality of an Illiken") && mode == 0)
  {
    ArrayList <Integer> availible = new ArrayList<Integer>();
    int yPos = 6; if(y == 2) yPos = 1;
    for(int i = 1; i <= 5; i++)
    {
      if(findCard(i, yPos) == -1) availible.add(i);
    }
    // Williken
    if(availible.size() > 0)
    {
      Card c = collection[searchCard("Mr. Willikens")].copy();
      c.summoned = true;
      c.spawned = true;
      c.player = y;
      addEffect(1, c, "Invincible");
      int i = availible.get(PApplet.parseInt(random(availible.size())));
      availible.remove(availible.indexOf(i));
      placeCard(y, c, i, yPos, true);
    }
    // Billiken
    if(availible.size() > 0)
    {
      Card c = collection[searchCard("Mr. Billikens")].copy();
      c.summoned = true;
      c.spawned = true;
      c.player = y;
      addEffect(1, c, "Invincible");
      int i = availible.get(PApplet.parseInt(random(availible.size())));
      availible.remove(availible.indexOf(i));
      placeCard(y, c, i, yPos, true);
    }
  }
}

public void heal(Card c, int hp)
{
  if(!c.NBTTags.contains("Unhealable") && !hasEffect(c, "NoEffect"))
    c.HP += hp;
}
