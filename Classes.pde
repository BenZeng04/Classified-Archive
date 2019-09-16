class Card
{
  PImage icon; // Currently WIP As of 2019-09-07
  ArrayList<String> NBTTags = new ArrayList<String>(); // Currently WIP As of 2019-09-07
  // Card Stats
  int cost = -1;
  int HP = -1;
  int ATK = -1;
  int MVMT = -1;
  int RNG = -1;
  //
  int turnPlacedOn = -1;
  ArrayList<Effect> effects = new ArrayList<Effect>(); // Status Effects
  ArrayList<Integer> category = new ArrayList<Integer>(); // 0: 8G, 1: 8H, 2: Elite
  String name = ""; 
  String displayName = "";
  int x = 0, y = 0; // Position relative to playfield.
  int displayX = 0, displayY = 0;
  int attackCount = 0; // Amount of times a card can attack this turn. (Usually 1)
  boolean canMove = false; // If the card has already moved, it cannot move any more.
  boolean canSpecial = false; // Special Attacks.
  //
  
  int player = -1; // Which side is the card on?
  String ability = ""; // Ability Description 
  boolean isSpell = false; // Is the card a spell?
  String spellTarget;
  public Card copy() // Deep Copy
  {
    Card c = new Card();
    c.cost = cost;
    c.HP = HP;
    c.ATK = ATK;
    c.MVMT = MVMT;
    c.RNG = RNG;
    c.turnPlacedOn = turnPlacedOn;
    c.effects = new ArrayList<Effect>();
    for(Effect e: effects)
    {
      Effect f = new Effect();
      f.duration = e.duration;
      f.name = e.name;
      c.effects.add(f);
    }
    c.category = new ArrayList<Integer>();
    for(int i: category) c.category.add(i);
    c.NBTTags = new ArrayList<String>();
    for(String s: NBTTags) c.NBTTags.add(s);
    c.name = name;
    c.displayName = displayName;
    c.x = x;
    c.y = y;
    c.displayX = displayX;
    c.displayY = displayY;
    c.attackCount = attackCount;
    c.canMove = canMove;
    c.canSpecial = canSpecial;
    c.player = player;
    c.ability = ability;
    c.isSpell = isSpell;
    c.summoned = summoned;
    c.spawned = spawned;
    c.spellTarget = spellTarget;
    c.icon = icon;
    c.HPBuff = HPBuff;
    c.ATKBuff = ATKBuff;
    c.condition = condition;
    c.conditionHPBuff = conditionHPBuff;
    c.conditionATKBuff = conditionATKBuff;
    return c;
  }
  boolean spawned = false; // Has the card been spawned out of a special effect or spell? Or has it been manually placed?
  boolean summoned = false; // Has the card been summoned out of a special effect or spell? Or is it actually from your deck?
  
  public void setupNBT() // WIP
  {
    displayName = name;
    if(name.equals("Ethan") || name.equals("Hubert") || name.equals("Ms. Iceberg")) NBTTags.add("SpecialMove");
    if(name.equals("Ben 2.0") || name.equals("Hexagonal")) NBTTags.add("Unhealable");
    if(name.equals("Mr. Pegamah")) NBTTags.add("Unbuffable");
    if(name.equals("Attack Positon") || name.equals("Raw Eggs and Soy Sauce")) NBTTags.add("AttackBoostSpell");
    if(name.equals("Jason C") || name.equals("Esther") || name.equals("Jefferson") || name.equals("Jawnie Dirp")) NBTTags.add("OppTargetedEffect");
    if(name.equals("Mandaran") || name.equals("George") || name.equals("Anthony")) NBTTags.add("YouTargetedEffect");
    if(name.equals("Jonathan") || name.equals("Samuel") || name.equals("Kenneth") || name.equals("Mr. Willikens") || name.equals("Mr. Billikens") || name.equals("A.L.I.C.E.") || name.equals("Yebanow") || name.equals("Jefferson")) 
    {
      NBTTags.add("InstantBuffer");
      switch(name)
      {
        case "Jonathan":
          ATKBuff = 1;
          condition = 4;
          conditionHPBuff = 1;
          conditionATKBuff = 2;
          break;
        case "Samuel":
          ATKBuff = 1;
          condition = 2;
          conditionHPBuff = 0;
          conditionATKBuff = 2;
          break;
        case "Kenneth":
          ATKBuff = 2;
          condition = 2;
          conditionHPBuff = 2;
          conditionATKBuff = 2;
          break;
        case "Mr. Willikens":
          condition = 6;
          conditionHPBuff = 3;
          break;
        case "Mr. Billikens":
          condition = 6;
          conditionATKBuff = 3;
          break;
        case "A.L.I.C.E.":
          ATKBuff = 3;
          HPBuff = 3;
          condition = 5;
          conditionHPBuff = 6;
          conditionATKBuff = 6;
          break;
        case "Yebanow":
          condition = 3;
          conditionHPBuff = 1;
          conditionATKBuff = 1;
          break;
        case "Jefferson":
          condition = 2;
          conditionATKBuff = 1;
          break;
      }
    }
  }
  
  // Special NBT Stuff
  int HPBuff = 0, conditionHPBuff = 0;
  int ATKBuff = 0, conditionATKBuff = 0;
  int condition = 0;
  
  public void onRoundStart(int player)
  {
    if(name.equals("Mr. Homas")) 
      ATK += 3;
    if(name.equals("Mr. Websterien"))
    {
      ATK += 2;
      HP += 2;
    }
    if(NBTTags.contains("SpecialMove")) // Some cards have a special 4th option besides Attacking, Moving, Discarding. 
      canSpecial = true;
    if(name.equals("Bonnie")) // Can attack twice each turn.
      attackCount = 2;
    if(name.equals("Ben")) // Deals direct damage to enemy player.
      p[player % 2 + 1].HP -= 2;
    if(name.equals("King Henry") && mode == 0) // Draws an extra card.
      drawCard(player);
    if(name.equals("Ultrabright")) // Heals you, ticks them.
    {
      p[player % 2 + 1].HP--;
      p[player].HP++;
    }
    if(name.equals("A.L.I.C.E.")) // Buffing
    {
      for(Card d: playField)
      {
        if(!hasEffect(d, "NoEffect") && d.player == player)
        {
          d.ATK+=1;
          heal(d, 1);
        }
      }
    }
  }
}

class Effect
{
  int duration; // Rounds it lasts for. Negative numbers: Forever
  String name;
  int givenBy;
}
class Player 
{
  ArrayList<Card> hand = new ArrayList<Card>(); 
  ArrayList<Card> deck = new ArrayList<Card>();
  ArrayList<Card> graveyard = new ArrayList<Card>(); // Unused
  int turn;
  int HP;
  int cash = 0;
  boolean canAttack; // Players can attack too! Not just cards!
}
class Move
{
  // General
  int type;
  // Attacking
  int targeter;
  // Targeted Effects and also Attacking
  int targeted;
  // Placing Cards and Spells
  Card cardPlaced;
  boolean cardSpawned;
  int player;
  int x, y;
  boolean nonTargeted;
  String name;
  // Moving
  boolean sideMove;
  int distance;
}
class Animation
{
  int type;
  int x;
  int y;
  String name = "";
}
class moveAnimation extends Animation
{
  int originalPos;
  int index;
  int distance;
  boolean toSide;
}
