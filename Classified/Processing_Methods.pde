private int calculateAttack(Card c)
{
  int atk = c.ATK;
  
  // Duo Cards which get buffed from other cards
    if (c.name.equals("Joseph"))
      for (Card d : playField)
        if (d.name.equals("Annika") && d.player == c.player)
          atk *= 3;
    if (c.name.equals("A.L.I.C.E."))
      for (Card d : playField)
        if (d.name.equals("Moonlight") && d.player == c.player)
          atk *= 2;
    if (c.name.equals("Ms. Nicke"))
      for (Card d : playField)
        if (d.name.equals("Esther") && d.player == c.player)
          atk += 7;
    if (c.name.equals("Ben"))
      for (Card d : playField)
        if (d.category.contains(2) && d.player == c.player)
          atk++;

    if (hasEffect(c, "2X ATK") || hasEffect(c, "2X ATK (Anny)")) atk *= 2;

    // Cards which buff all other cards
    if (!hasEffect(c, "NoEffect"))
    {
      for (Card d : playField)
        if (d.name.equals("Mandaran") && max(abs(c.x - d.x), abs(c.y - d.y)) <= 1 && c.category.contains(3) && d.player == c.player) 
          atk += 3;
      for (Card d : playField)
        if (d.name.equals("Ben") && c.category.contains(2) && d.player == c.player) atk += 3;
      for (Card d : playField)
        if (d.name.equals("Rita") && d.player != c.player) atk = max(0, atk - 2);
    }
    if(c.turnPlacedOn == p[c.player].turn && !c.NBTTags.contains("OverrideBuffer")) atk /= 2;
    return atk;
}
private int calculateMovement(Card c)
{
  int mvmt = c.MVMT;
  if(hasEffect(c, "Slowdown")) mvmt -= 1; 
  return mvmt;
}
private int calculateRange(Card c)
{
  int rng = c.RNG;
  for(Card d: playField)
  {
    if(d.name.equals("Mandaran") && max(abs(c.x - d.x), abs(c.y - d.y)) <= 1 && c.category.contains(3) && d.player == c.player) 
    {
      if(!c.name.equals("Ultrabright"))
        rng += 1;
    }
    if(d.name.equals("Ridge Rhea") && c != d && !c.name.equals("Ultrabright") && d.player == c.player && d.x == c.x) rng += 2;
  }
  if(hasEffect(c, "NVW")) rng++;
  return rng;
}
private boolean availibleMove(int cardX, int cardY, int moveType, int distance)
{
  boolean availible = true;
  for(Card c: playField)
  {
    if(moveType == 0)   
      if(c.x == cardX && c.y == cardY - distance || cardY <= distance)
        availible = false;
    if(moveType == 1)
      if(c.x == cardX && c.y == cardY + distance || cardY + distance > 6)
        availible = false;
    if(moveType == 2)
      if(c.x == cardX - distance && c.y == cardY || cardX <= distance)
        availible = false;
    if(moveType == 3)
      if(c.x == cardX + distance && c.y == cardY || cardX + distance > 5)
        availible = false;
  }
  return availible;
}
private boolean outOfField(int cardX, int cardY, int attackType)
{
  boolean outOfField; if(attackType == 0) outOfField = cardY <= 0; else if(attackType == 1) outOfField = cardY > 6; else if(attackType == 2) outOfField = cardX > 5; else outOfField = cardX <= 0; // If out of bounds. Sometimes it will be attacking the player.
  return outOfField;
}

private boolean availibleAttack(int cardX, int cardY, int attackType) // Calculates if the for loop neccesary for figuring out what to attack will quit or not.
{
  boolean availible = true; // Availible doesn't mean that you can attack that spot, it just means that it won't quit.
  if(outOfField(cardX, cardY, attackType)) // If the current cardX and cardY are out of the playfield, automatically quit
    availible = false;
  
  for(Card c: playField) // Checks cards in the way
    if(c.x == cardX && c.y == cardY) // if there is a card in the way, and you do NOT have a card which can bypass this, and this card is not your own card, you cannot attack over it, therefore the loop MUST quit.
      if((!playField.get(playFieldSelected).name.equals("Matthew") && !playField.get(playFieldSelected).name.equals("Ultrabright") && !playField.get(playFieldSelected).name.equals("UNNAMED2") && c.player != playerTurn))
        availible = false;
  return availible;
}
private boolean canAttack(int cardX, int cardY, int attackType) // Calculates whether or not there is a non-invincible card at position cardX and cardY, or if the player is being attacked.
{
  boolean canAttack = false;
  if(outOfField(cardX, cardY, attackType)) // Attacking player under specific conditions
    if(((playerTurn == 1 && attackType == 0) || (playerTurn == 2 && attackType == 1)) && playField.get(playFieldSelected).turnPlacedOn != p[playerTurn].turn) canAttack = true;
 //<>// //<>//
  for(Card c: playField) // Checks cards in the way
    if(c.x == cardX && c.y == cardY)
      if(c.player != playerTurn && !hasEffect(c, "Invincible"))
          canAttack = true; // Basically finds closest card that isnt yours. 
  return canAttack;
}
private boolean canSpecial(Card c) // Calculates whether or not the currently selected card can attack Card c, which is passed as a parameter.
{
  int sideTarget;
  if(playField.get(playFieldSelected).name.equals("Hubert") || playField.get(playFieldSelected).name.equals("Neil")) sideTarget = playField.get(playFieldSelected).player; else sideTarget = playField.get(playFieldSelected).player % 2 + 1;
  boolean condition = true;
  if(playField.get(playFieldSelected).name.equals("Hubert")) condition = !c.NBTTags.contains("Unhealable");
  if(playField.get(playFieldSelected).name.equals("Ethan") || playField.get(playFieldSelected).name.equals("UNNAMED")) condition = c.cost < 5;
  if(c.player == sideTarget && !hasEffect(c, "NoEffect") && condition) return true; else return false;
}
