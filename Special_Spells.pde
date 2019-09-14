public void useSpell(String name, int indexEffect)
{
  startAnimation(7, playField.get(indexEffect).x, playField.get(indexEffect).y, name);
  int index = -1;
  for(int i = 0; i < collection.length; i++)
  {
    if(collection[i].name == name)
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
  if(name == "German Machine Guns")
  {
    playField.get(indexEffect).attackCount++;
  }
  if(name == "Defense Position")
  {
    addEffect(-1, indexEffect, "Resurrect");
    addEffect(-1, indexEffect, "Defense");
  }
  
  if(name == "Attack Position")
  {
    playField.get(indexEffect).ATK+=6;
    addEffect(-1, indexEffect, "Attack");
  }
  if(name == "Fireball")
  {
    attackCard(-12, indexEffect, true); // -2: Fireball, -3: Holy Hand Grenade Center, -4 
  }
  if(name == "Zoo Wee Mama!")
  {
    attackCard(-8, indexEffect, true); // -2: Fireball, -3: Holy Hand Grenade Center, -4 
  }
  if(name == "Mini Gulag")
  {
    for(int l = 0; l < 9; l++)
    {
      int x = playField.get(indexEffect).x, y = playField.get(indexEffect).y;
      x += l % 3 - 1;
      y += l / 3 - 1;
      if(findCard(x, y, playField.get(indexEffect).player) != -1)
      {
        playField.get(findCard(x, y, playField.get(indexEffect).player)).ATK = max(0, playField.get(findCard(x, y, playField.get(indexEffect).player)).ATK - 4);
        playField.get(findCard(x, y, playField.get(indexEffect).player)).HP = max(0, playField.get(findCard(x, y, playField.get(indexEffect).player)).HP - 4);
      }
    }
  }
  if(name == "Holy Hand Grenade")
  {
    attackCard(-9, indexEffect, true);
    for(int l = 0; l < 9; l++)
    {
      if(l != 4)
      {
        int x = playField.get(indexEffect).x, y = playField.get(indexEffect).y;
        x += l % 3 - 1;
        y += l / 3 - 1;
        if(findCard(x, y, playField.get(indexEffect).player) != -1)
          attackCard(-6, findCard(x, y, playField.get(indexEffect).player), true);
      }
    }
  }
  if(name == "Stall")
  {
    addEffect(1, indexEffect, "Stun");
    if(mode == 0)
      drawCard();
  }
  if(name == "Miss Me")
  {
    addEffect(1, indexEffect, "Invincible");
  }
  if(name == "Dragon Wings")
  {
    playField.get(indexEffect).MVMT += 2;
    playField.get(indexEffect).RNG += 1;
  }
  if(name == "Mr. Sketch")
  {
    playField.get(indexEffect).ATK += 5;
    if(!playField.get(indexEffect).NBTTags.contains("Unhealable"))
      playField.get(indexEffect).HP += 8;
  }
  if(name == "T-Pose") 
  {
    int oppCount = 0;
    for(Card c: playField)
    {
      if(c.player != playField.get(indexEffect).player) {
        oppCount++;
        if(!hasEffect(c, "NoEffect"))
        {
          c.ATK--;
          c.HP--;
        }
      }
    }
    playField.get(indexEffect).ATK += oppCount;
    playField.get(indexEffect).HP += oppCount;
  }
  if(name == "Hit It Boys!")
  {
    addEffect(3, indexEffect, "SideMove");
  }
  if(name == "Raw Eggs and Soy Sauce")
  {
    playField.get(indexEffect).ATK += 4;
    addEffect(-1, indexEffect, "RawEggs");
  }
  if(name == "Sebastian’s Tea")
  {
    addEffect(-1, indexEffect, "Tea");
  }
  if(name == "Novelty Wings")
  {
    if(playField.get(indexEffect).category.contains(6))
      addEffect(2, indexEffect, "NVW");
    else
      addEffect(1, indexEffect, "NVW");
  }
  if(name == "Mr. Tornado")
  {
    String temp = playField.get(indexEffect).name;
    Card c = collection[searchCard(temp)].copy();
    c.summoned = true;
    if(mode == 0 && index != -1)
      p[playerTurn % 2 + 1].hand.add(c);
      
    playField.remove(indexEffect);
    playFieldSelected = playField.indexOf(c);
  }
  if(name == "Windmill")
  {
    String eName = playField.get(indexEffect).name;
    if(eName != "Ridge Rhea")
      playField.get(indexEffect).MVMT++;
    if(!playField.get(indexEffect).NBTTags.contains("Unhealable"))
      playField.get(indexEffect).HP = min(playField.get(indexEffect).HP * 2, playField.get(indexEffect).HP + 14);
  }
}

public void spawnEffects(String name, int indexName, int indexSpawn)
{
  if(mode == 0)
  {
    Move m = new Move();
    m.type = 3;
    m.targeter = indexName;
    m.targeted = indexSpawn;
    m.name = name;
    moves.add(m);
  }
  startAnimation(3, playField.get(indexSpawn).x, playField.get(indexSpawn).y);
  playFieldSelected = indexName;
  if(name == "Jason C")
  {
    playField.get(indexSpawn).ATK = max(playField.get(indexSpawn).ATK - 8, 0);
    playField.get(indexSpawn).MVMT = max(playField.get(indexSpawn).MVMT - 1, 0);
  }
  else if(name == "Esther")
  {
    Card temp = playField.get(indexName);
    int index = -1;
    for(int i = 0; i < collection.length; i++)
    {
      if(collection[i].name == playField.get(indexSpawn).name)
        { index = i; temp = collection[i].copy(); }
    }
    temp.summoned = true;
    if(mode == 0 && index != -1)
      p[playerTurn % 2 + 1].hand.add(temp);
    playField.remove(indexSpawn);
    playFieldSelected = playField.indexOf(temp);
  }
  else if(name == "Jefferson")
  {
    playField.get(indexSpawn).effects.clear();
    Effect e = new Effect();
    e.name = "NoEffect";
    e.duration = -1;
    playField.get(indexSpawn).effects.add(e);
    
    e = new Effect();
    e.name = "Nullify";
    e.duration = -1;
    playField.get(indexSpawn).effects.add(e);
  }
  else if(name == "Mandaran")
  {
    Effect e = new Effect();
    e.name = "Invincible";
    e.duration = 1;
    playField.get(indexSpawn).effects.add(e);
  }
  else if(name == "George")
  {
    playField.get(indexSpawn).ATK += 3;
    if(!playField.get(indexSpawn).NBTTags.contains("Unhealable"))
      playField.get(indexSpawn).HP += 4;
  }
  else if(name == "Anthony")
  {
    if(!playField.get(indexSpawn).NBTTags.contains("Unhealable"))
      playField.get(indexSpawn).ATK += 6;
    playField.get(indexSpawn).HP += 8;
    playField.get(indexSpawn).MVMT += 1;
  }
  else if(name == "Jawnie Dirp")
  {
    playField.get(indexSpawn).ATK -= 8; playField.get(indexSpawn).ATK = max(0, playField.get(indexSpawn).ATK);
    playField.get(indexSpawn).HP -= 8;
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
  
  if(type == "Hubert")
  {
    playFieldSelected = indexUser;
    playField.get(indexOpp).HP+=4;
    startAnimation(2, playField.get(indexOpp).x, playField.get(indexOpp).y);
  }
  if(type == "Ethan")
  {
    playField.get(indexUser).HP = 0;
    playField.get(indexOpp).HP = 0;
    playField.get(indexUser).effects.clear();
    playField.get(indexOpp).effects.clear();
    startAnimation(4, playField.get(indexOpp).x, playField.get(indexOpp).y); selfX = playField.get(indexUser).x; selfY = playField.get(indexUser).y;
  }
  if(type == "Ms. Iceberg")
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
  Effect e = new Effect();
  e.name = "Alive";
  e.duration = 1;
  playField.get(index).effects.add(e);
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
  
  if(name == "Expectations Ever Increasing")
  {
    if(mode == 0)
    {
      for(Card c: p[y].hand)
      {
        if(!c.isSpell)
        {
          c.cost+=1;
          c.ATK += 4;
          c.HP += 4;
        }
      }
    }
  }
  if(name == "Propaganda Machine")
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
  if(name == "Terminator")
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
  if(name == "Awakening")
  {
    for(Card c: playField)
    {
      if(c.player == y && c.category.contains(2) && !hasEffect(c, "noEffect"))
      {
        c.ATK += 3;
        if(!c.NBTTags.contains("Unhealable"))
          c.HP += 2;
      }
    }
  }
  if(name == "Elite's Calling" && mode == 0)
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
  if(name == "The Duality of an Illiken" && mode == 0)
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
