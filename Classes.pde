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
  int x = 0, y = 0; // Position relative to playfield.
  int attackCount = 0; // Amount of times a card can attack this turn. (Usually 1)
  boolean canMove = false; // If the card has already moved, it cannot move any more.
  boolean canSpecial = false; // Special Attacks.
  //
  
  int player = -1; // Which side is the card on?
  String ability = ""; // Ability Description 
  boolean isSpell = false; // Is the card a spell?
  boolean targetsYou = false; // Does this spell target your own cards? Or the opponents' cards?

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
    c.x = x;
    c.y = y;
    c.attackCount = attackCount;
    c.canMove = canMove;
    c.canSpecial = canSpecial;
    c.player = player;
    c.ability = ability;
    c.isSpell = isSpell;
    c.summoned = summoned;
    c.spawned = spawned;
    c.targetsYou = targetsYou;
    c.icon = icon;
    return c;
  }
  
  boolean spawned = false; // Has the card been spawned out of a special effect or spell? Or has it been manually placed?
  boolean summoned = false; // Has the card been summoned out of a special effect or spell? Or is it actually from your deck?
  
  public void setupNBT() // WIP
  {
    if(name == "Ethan" || name == "Hubert" || name == "Ms. Iceberg") NBTTags.add("SpecialMove");
    if(name == "Ben 2.0" || name == "Hexagonal") NBTTags.add("Unhealable");
    if(name == "Mr. Pegamah") NBTTags.add("Unbuffable");
    if(name == "Attack Positon" || name == "Raw Eggs and Soy Sauce") NBTTags.add("AttackBoostSpell");
  }
}
class Effect
{
  int duration; // Rounds it lasts for. Negative numbers: Forever
  String name;
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
  int player;
  int x, y;
  boolean nonTargeted;
  String name;
  // Moving
  boolean sideMove;
  int distance;
}
