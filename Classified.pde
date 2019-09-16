import java.util.*; 
//<>//
/*
Lead Developer: Ben Zeng (yeahbennou#5727)
Started On: 2019-06-28
Current Date: 2019-09-10
*/

boolean testMode = true;

Card [] collection; // All cards and spells in the game.
int [] categTot = new int [7]; // Total amount of cards per category. This is used for sorting purposes/design!

// Fonts
PFont font1 = new PFont();

// Deck Saving

String p1Deck = "";
String p2Deck = "";

// Gameplay
Card [] [] offlineDecks = new Card [2] [8];
ArrayList<Card> playField = new ArrayList<Card>();
Player [] p = new Player [3]; // p[1]: Player1, p[2]: Player 2.
Card moneyFarm = new Card();

// Animate Opponents' Moves
ArrayList<Move> moves = new ArrayList<Move>(); // Showing moves done. Last number = move type. 1: Place Card. 2: Place Spell. 3: Use ability (AbilitySelected). 4: Attack. 5: Move. 6. Discard. 7. Attack Player 11: Heal. 12: Suicide Bomb.
ArrayList<Card> specialMoves = new ArrayList<Card>(); // This is useless. Actually does nothing

int oldHP1 = 30, oldHP2 = 30; // Old HP of both players at the start of a turn.
int newHP1, newHP2; // New HP of the players.
ArrayList<Card> oldPlayField = new ArrayList<Card>(); // Old Playfield (Cards) at the start of a turn.
ArrayList<Card> currentPlayField = new ArrayList<Card>(); // Current Playfield, to override old playfield once the "animations" are over.
boolean needToFinishAnimate = false; // Finishing the animations, bringing you back to normal gameplay.
///

// Transitions Between Screens
int transitionTime = 0; // The time since the start of a new transition. This will dictate the transparency of the black screen used to manage transitions.
boolean inTransition = false;
int transitionToMode; // A variable used for the transitions. It allows for the mode to change after the transition is over, rather than before the transition starts.

// Discarding cards in hand.
boolean discarding = false;
int discardsUsed = 0; 
//

// Rulesets and Menus
int ruleset = 0;
int mode = 3;
/*
Modes:
0: Gameplay
1: Switching Turns
2: Animating Opponents' Moves
3: Main Menu
4: Selecting Player 1's Deck
5: Selecting Player 2's Deck
7: Settings (WIP)
8: How to Play
9: Credits
10: Win Screen (P1)
11: Win Screen (P2)
*/
int specialRemove = -1; // Special cases where cards can get removed directly upon attacking (Like Uzziah)
int clickDelay = 0;
int playerTurn; // Player Turn
int cardSelected = -1; // Selected Card (Hand)
int playFieldSelected = -1; // Selected Card (Playfield)

// Effects that require actions after selection.
String effectType = ""; // Unused as of 2019-09-07

int choice = -1; // Card actions for the currently selected card on the playfield. -1: Main Menu, 0: Special Moves, etc...
int abilitySelected = -1; // Spawn Abilities which require targeting your/your opponents' cards.
int ogx = 0, ogy = 0; // Original position of cards that are being selected in your hand.
int timer = 0; // Timer (Generic)
boolean playerSelected = false; // Is the player (Not a card!) attacking?

// ALL ANIMATION STUFF
boolean inAnimation = false;
boolean moveAnimation = false;
int aniTimer; // Set to 0 once beginning animation
int moveAniTimer; // Set to 0 once beginning animation

  // Moving
  ArrayList <moveAnimation> moveTargets = new ArrayList<moveAnimation>();// Moving
  
  // Ability / Attack
  ArrayList <Animation> targets = new ArrayList<Animation>();// General
  int selfX, selfY; // Ethan's suicide bomb

// Images
PImage menuBG;
PImage icon, qMark, credit;
PImage health, attack, movement, range;
PImage playFieldIcon;
/*
To-Do
*/
public void setup()
{
  // Basic Setup of variables 
  size(1200, 800);
  font1 = loadFont("SegoeUI-Bold-48.vlw");
  textFont(font1);
  String [] temp = loadStrings("Deck1.txt");
  p1Deck = temp [0];
  temp = loadStrings("Deck2.txt");
  p2Deck = temp [0];
  needToFinishAnimate = false;
  frameRate(60);
  menuBG = loadImage("MainMenuBG.png");
  icon = loadImage("settings.png");
  qMark = loadImage("ques.png");
  credit = loadImage("info.png"); 
  health = loadImage("HP.png");
  attack = loadImage("ATK.png");
  movement = loadImage("MVMT.png");
  range = loadImage("RNG.png");
  menuBG.resize(width, height);
  p[1] = new Player();
  p[2] = new Player();
  moneyFarm.name = "Money Farm"; moneyFarm.ATK = 0; moneyFarm.HP = 1; moneyFarm.MVMT = 1; moneyFarm.RNG = 0; moneyFarm.cost = 5; moneyFarm.ability = "This card will generate $1 extra in cash each turn. This card can be attacked over.";
  // Setting Stats of Cards!
  String [] cards = loadStrings("Collection.txt");
  collection = new Card [cards.length];
  for(int i = 0; i < collection.length; i++)
    collection[i] = new Card();
  for(String s: cards)
  {
    String [] decode = s.split("/");
    if(decode[1].equals("card"))
    {
      String [] stats = decode[3].split(" ");
      String [] categories = decode[5].split(" ");
      Card setCard = new Card();
      setCard.name = decode[2];
      setCard.ATK = Integer.parseInt(stats[0]);
      setCard.HP = Integer.parseInt(stats[1]);
      setCard.MVMT = Integer.parseInt(stats[2]);
      setCard.RNG = Integer.parseInt(stats[3]);
      setCard.cost = Integer.parseInt(stats[4]);
      setCard.ability = decode[4];
      for(String category: categories)
        setCard.category.add(Integer.parseInt(category));
      collection[Integer.parseInt(decode[0])] = setCard;
    }
    else
    {
      Card setCard = new Card();
      setCard.name = decode[2];
      setCard.cost = Integer.parseInt(decode[3]);
      setCard.ability = decode[4];
      setCard.isSpell = true;
      if(decode[5].equals("targetsYou")) setCard.spellTarget = "You";
      if(decode[5].equals("targetsOpp")) setCard.spellTarget = "Opp";
      if(decode[5].equals("targetsAll")) setCard.spellTarget = "All";
      collection[Integer.parseInt(decode[0])] = setCard;
    }
  }
  sortCollection();
  for(Card c: collection) c.setupNBT(); // Setting up NBT Values.
  moneyFarm.setupNBT();
  
  // Setting up the deck selection
  for(int i = 0; i < 2; i++)
  {
    for(int j = 0; j < offlineDecks[0].length; j++)
      offlineDecks[i] [j] = new Card();
  }
  
  // Saved Decks Decoding
  String [] decoding, decoding2;
  
  decoding = p1Deck.split(" ");
  decoding2 = p2Deck.split(" ");
  
  int [] decode = new int [decoding.length]; // Decoding the stuff in the arraylist.
  for(int i = 0; i< decode.length; i++)
  {
    decode[i] = Integer.parseInt(decoding[i]);
  }
  int [] decode2 = new int [decoding2.length]; // Decoding the stuff in the arraylist.
  for(int i = 0; i< decode.length; i++)
  {
    decode2[i] = Integer.parseInt(decoding2[i]);
  }
  
  for(int i = 0; i<offlineDecks[0].length; i++)
  {
    int correctIndex = min(i, collection.length - 1);
    offlineDecks[0] [i] = collection [decode[correctIndex]];
    offlineDecks[1] [i] = collection [decode2[correctIndex]];
  }

  // Setting up total number of cards in each category
  for(Card c: collection)
  {
    for(int i: c.category)
    {
      categTot[i]++;
    }
  }
}

public void sortCollection() // Sorts collection by category.
{
  ArrayList <Card> temporary = new ArrayList <Card> ();
  for(int i = 2; i < categTot.length; i++)
  {
    for(Card c: collection)
    {
      if(c.category.contains(i)) temporary.add(c);
    }
  }
  for(Card c: collection)
  {
    if(c.isSpell) temporary.add(c);
  }
  int counter = 0;
  for(Card c: temporary)
  {
    collection[counter] = c;
    counter++;
  }
}

public void draw() // Modes
{
  // For different resolutions. WIP
  
  cursorX = round((mouseX * 800.0 / height));
  cursorY = round((mouseY * 800.0 / height));
  pushMatrix();
  scale(height / 800.0, height / 800.0);
  
  //
  
  // Modes
  if(mode == 0)
  {
    timer++;
    play();
  }
  if(mode == 1)
    transition();
  if(mode == 2)
  {
    oppMoves();
    play();
  }
  if(mode == 3)
    mainMenu();
  if(mode == 4)
    chooseDeck(0);
  if(mode == 5)
    chooseDeck(1);
  if(mode == 7) options("S  E  T  T  I  N  G  S  !");
  if(mode == 8) options("H O W  T O  P L A Y !");
  if(mode == 9) options("C  R  E  D  I  T  S  !");
  if(mode == 10) victory();
  if(clickDelay > 0)
    clickDelay --;
  if(inTransition) 
  {
    transitionTime++; // Transition Variable increases
    
    if(transitionTime == 25) // Halfway mark. This is when the black screen starts fading out instead of fading in and revealing the screen
    {
      mode = transitionToMode; // Switches the mode once the screen is totally black, so that the switch isn't visible.
      if(transitionToMode == 6) // Game will setup mid-transition if the transition is to the play screen
        setupGame();
    }
      
    if(transitionTime > 50) // This is when the transition is completely over
    {
        inTransition = false;
        transitionTime = 0; // Resetting time
    }
    
    float transparency = (-1 * abs(transitionTime - 25) + 25) * 10; // Function that will increase the transparency, then decrease it. This allows for the black screen to fade in and out.
    
    fill(0, transparency);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, 1200, 800);
  }
  popMatrix();
}

public void transition() // Other Player's Turn
{
  background(0);
  fill(255);
  textSize(60);
  text("It is now Player "+playerTurn+"'s turn.", 600, 400);
  textSize(30);
  text("Click anywhere to continue.", 600, 450);
}

public void setupGame() // Starting Game
{
  targets.clear();
  playFieldIcon = loadImage("playField1.png"); // Icon for playfield/arena (Will add more in the future!)
  // Resetting Variables
  discardsUsed = 0;
  timer = 0;
  playerTurn = 1;
  for(int i = 1; i <= 2; i++)
  {
    p[i].deck.clear();
    p[i].hand.clear();
    p[i].graveyard.clear();
    p[i].HP = 30;
  }
  p[1].turn = 1;
  p[2].turn = 0;
  p[1].canAttack = true;
  p[1].cash = 3;
  p[2].cash = 0;
  oldHP1 = 30;
  oldHP2 = 30;
  moves.clear();
  specialMoves.clear();
  playField.clear();
  oldPlayField.clear();
  currentPlayField.clear();
  
  ArrayList <Card> temp1 = new ArrayList <Card> (), temp2 = new ArrayList <Card> ();
  for(int i = 0; i < offlineDecks[0].length; i++) // Temporary Duplicate Decks
  {
    temp1.add(offlineDecks[0][i]);
    temp2.add(offlineDecks[1][i]);
  }
  
  for(int i = 0; i < offlineDecks[0].length; i++) // Inserting the temporary decks to the actual decks at random positions
  {
    int tempValue = PApplet.parseInt(random(temp1.size()));
    p[1].deck.add(temp1.get(tempValue));
    temp1.remove(tempValue);
    tempValue = PApplet.parseInt(random(temp2.size()));
    p[2].deck.add(temp2.get(tempValue));
    temp2.remove(tempValue);
  }
  
  if(ruleset == 1) // WIP ruleset, has twice the card size but only a limited amount
  {
    for(int i = 0; i < offlineDecks[0].length; i++)
    {
      p[1].deck.add(p[1].deck.get(i));
      p[2].deck.add(p[2].deck.get(i));
    }
  }
  // Each player starts with 3 cards. Player 1 starts with 3, Player 2 starts with 2 but will get the 3rd once Player 1 hands over their turn.
  drawCard(1);
  for(int i = 0; i < 2; i++)
  {
    drawCard(1);
    drawCard(2);
  }
  if(ruleset == 1)
  {
    p[1].hand.add(moneyFarm);
    p[2].hand.add(moneyFarm);
  }
}

public void handOverTurn() // Logic for handing over turns (Game-wise)
{
  discardsUsed = 0;
  clickDelay = 10;
  mode = 1;
  int opp = playerTurn % 2 + 1;
  p[opp].turn++;
  if(ruleset == 0) // Default Money Generation
    p[opp].cash = p[opp].turn + 2;
  else
    p[opp].cash += 3;
  for(Card c : playField) // Money Generation (Cards)
  {
    if(c.name.equals("Money Farm") && c.player == opp)
          p[opp].cash += 1;
    if(c.name.equals("Yucen") && c.player == opp) p[opp].cash+=2;
  }
  p[opp].canAttack = true; // Sets the player to be able to attack again
  if(ruleset == 0)
  {
    if(p[opp].deck.size() > 0) // Draws a card each turn
      drawCard(opp);
  }
  if(ruleset == 1)
  {
    if(p[opp].deck.size() > 0)
    {
      p[opp].hand.add(p[opp].deck.get(0));
      p[opp].deck.remove(0);
    }
    boolean hasFarm = false;
    for(Card c: p[opp].hand)
    {
      if(c.name.equals("Money Farm"))
        hasFarm = true;
    }
    if(!hasFarm) p[opp].hand.add(moneyFarm);
  }
  
  // Deselecting all cards
  playFieldSelected = -1;
  cardSelected = -1;
  playerTurn = playerTurn % 2 + 1; // Switches 1 to 2, 2 to 1
}

public void handOverEffects(int opp) // Actual card effects when handing over turn
{
  for(Card c: playField)
  {
    if(c.player == opp)
    {
      // All cards can move and attack once a turn
      c.canMove = true;
      c.attackCount = 1;
      
      if(hasEffect(c, "HealDisable")) // "Lina"'s Effect, which increases 1 HP per turn while the card has not been attacked yet
        c.HP++;
      if(hasEffect(c, "Tea")) // Spell Effect
      {
        c.HP -= 5;
        c.ATK -= 5;
      }
      // Stat Buffs
      c.onRoundStart(opp);
    }
    // Discarding Cards, Removing Effects
    ArrayList <Effect> tempRemove = new ArrayList <Effect>();
    boolean finishedDiscarding = false;
    for(Effect e: c.effects)
    {
      if(e.givenBy == opp) // If the effect was GIVEN BY the opponent. Effects you give yourself go away on your turn, effects the opponent gives you go away on their turn.
      {
        e.duration--;
        if(e.duration == 0)
        {
          tempRemove.add(e); // Normal Removal of Cards
          if(e.name.equals("Alive")) // Discarded Cards
            finishedDiscarding = true;
        }
      }
    }
    if(finishedDiscarding)
    {
      c.HP = -Integer.MAX_VALUE; // Makes sure they are dead
      c.effects.clear(); // Removes any effects that allow them to resurrect
      startAnimation(8, c.x, c.y);
    }
    if(tempRemove.size() > 0)
      for(Effect e : tempRemove)
        c.effects.remove(e); // BOOOM DEAD EFFECT
  }
  for(Card c: playField)
  {
    if(c.name.equals("King Henry") && c.player == opp) // Double attack this turn
    {
      for(Card d: playField)
        if(c.player == opp)
          addEffect(1, d, "2X ATK");
    }
  }
}

public int findCard(int x, int y, int player)
{
  // Finds card at specified location.
  for(Card c: playField)
  {
    if(c.x == x && c.y == y && c.player == player)
    {
      return playField.indexOf(c);
    }
  }
  return -1;
}

public int findCard(int x, int y)
{
  // Finds card at specified location.
  for(Card c: playField)
  {
    if(c.x == x && c.y == y)
    {
      return playField.indexOf(c);
    }
  }
  return -1;
}

public boolean hasEffect(Card c, String name)
{
  for(Effect e: c.effects)
  {
    if(e.name.equals(name))
      return true;
  }
  return false;
}

public int searchCard(String name)
{
  int i = 0;
  for(Card c: collection)
  {
    if(c.name.equals(name))
      return i;
    i++;
  }
  return -1;
}

public void copyPlayfield(ArrayList <Card> stuff, String copyTo) // Deep Copying the playfield. 
{
  // stuff refers to the playfield that will be duplicated. copyTo is the name of the playfield that will recieve the duplicate.
  if(copyTo.equals("playField"))
      playField = new ArrayList<Card>();
  if(copyTo.equals("oldPlayField"))
    oldPlayField = new ArrayList<Card>();
  if(copyTo.equals("currentPlayField"))
    currentPlayField = new ArrayList<Card>();
  for(Card c: stuff)
  {
    Card card = c.copy();
    if(copyTo.equals("playField"))
      playField.add(card);
    if(copyTo.equals("oldPlayField"))
      oldPlayField.add(card);
    if(copyTo.equals("currentPlayField"))
      currentPlayField.add(card);
  }
}

// Special Animations (Replay)
boolean animationToggle = true;
int animateTimer;

public void oppMoves() // Animating Opponents' Moves
{
  animateTimer++;
  if(animateTimer == 15 && animationToggle)
  {
    handOverEffects(playerTurn % 2 + 1);
  }
  else if(animateTimer % 60 == 15 && animationToggle) // Every Second
  {
    if(moves.size() > 0) // Looks through the moves arraylist, checks if there are any moves that need to be displayed.
    {
      playerSelected = false;
      Move m = moves.get(0);
      moves.remove(m);

      if(m.type == 1) // Placing Cards
      {
        Card c = m.cardPlaced.copy();
        placeCard(m.player, c, m.x, m.y, false);
        if(moves.size() > 0)
        {
          Move newM = moves.get(0);
          while(newM.type == 1 && moves.size() > 0) // Checks first if the next card is of type 1 (Placing)
          {
            newM = moves.get(0);
            if(newM.cardSpawned) // If cards are being spawned out of another card, spawn them instantly instead of replaying multiple times
            {
              m = moves.get(0); 
              moves.remove(m);
              c = m.cardPlaced.copy();
              placeCard(m.player, c, m.x, m.y, true);
            } 
            else break;
          }
        }
      }
      if(m.type == 2) // Using Spells
      {
        if(!m.nonTargeted)
          useSpell(m.name, m.targeted);
        else 
        {
          useSpell(m.player, m.name); 
          if(moves.size() > 0)
          {
            Move newM = moves.get(0);
            while(newM.type == 1 && moves.size() > 0) // Checks first if the next card is of type 1 (Placing)
            {
              newM = moves.get(0);
              if(newM.cardSpawned) // If cards are being spawned out of another card, spawn them instantly instead of replaying multiple times
              {
                m = moves.get(0); 
                moves.remove(m);
                placeCard(m.player, m.cardPlaced.copy(), m.x, m.y, true);
              } 
              else break;
            }
          }
        }
      }
      if(m.type == 3) // Spawn Effects
        spawnEffects(m.name, m.targeter, m.targeted);
      if(m.type == 4) // Attacking
      {
        playFieldSelected = m.targeter;
        attackCard(m.targeter, m.targeted, true);
        if(m.targeter != -1)
        {
          if(m.name.equals("Antnohy") && !hasEffect(playField.get(m.targeted), "Invincible"))
          {
            int x = m.x, y = m.y;
            for(int l = 0; l < 9; l++)
            {
              if(l != 4)
              {  
                int tx = x + l % 3 - 1;
                int ty = y + l / 3 - 1;
       
                if(findCard(tx, ty, m.player % 2 + 1) != -1)
                  attackCard(playFieldSelected, findCard(tx, ty, m.player % 2 + 1), true);
              }
            }
          }
          if(m.name.equals("GeeTraveller") && !hasEffect(playField.get(m.targeted), "Invincible"))
          {
            int x = m.x;
            for(int l = 1; l <= 6; l++)
            {
              if(l != m.y) 
              {
                if(findCard(x, l, m.player) != -1)
                  attackCard(playFieldSelected, findCard(x, l, m.player % 2 + 1), true);
              }
            }
          }
        }
      }
      if(m.type == 5) // Moving
        if(!m.sideMove)
          moveCard(m.targeter, m.distance);
        else
          moveCardSide(m.targeter, m.distance);
      if(m.type == 6) // Discarding
        discard(m.targeter); 
      if(m.type == 7) // Attacking the Player
        attackPlayer(m.targeter);
      if(m.type == 11) // Special
        specialAbility(m.targeter, m.targeted, m.name);
    }
    else
    {
      mode = 0;
      playerSelected = false;
      playFieldSelected = -1;
      needToFinishAnimate = true; // Finished.
    }
  }
}

public void finishAnimate() // What happens after the animation above is done.
{
  specialMoves.clear();
  moves.clear(); // Gets rid of all moves
  copyPlayfield(currentPlayField, "playField"); // Brings playfield back to normal, from animation state.
  copyPlayfield(currentPlayField, "oldPlayField"); // Replaces the "old playfield" with current playfield. This will become "old" again once the player has done moves.
  p[1].HP = newHP1;
  p[2].HP = newHP2;
  oldHP1 = p[1].HP;
  oldHP2 = p[2].HP;
  
  needToFinishAnimate = false;
  
  handOverEffects(playerTurn);
  playFieldSelected = -1;

}
public void drawCard()
{
  if(p[playerTurn].deck.size() > 0)
  {
    for(Card c: playField)
    {
      if(c.name.equals("Mr. Filascario") && c.player == playerTurn) p[playerTurn % 2 + 1].HP -= 3;
    }
    p[playerTurn].hand.add(p[playerTurn].deck.get(0).copy());
    p[playerTurn].deck.remove(0);
  }
}
public void drawCard(int opp)
{
  if(p[opp].deck.size() > 0)
  {
    for(Card c: playField)
    {
      if(c.name.equals("Mr. Filascario") && c.player == opp) p[opp % 2 + 1].HP -= 3;
    }
    p[opp].hand.add(p[opp].deck.get(0).copy());
    p[opp].deck.remove(0);
  }
}
public void drawCard(String mode)
{
  
  if(p[playerTurn].deck.size() > 0)
  {
    if(!mode.equals("Cycle"))
    {
      for(Card c: playField)
      {
        if(c.name.equals("Mr. Filascario") && c.player == playerTurn) p[playerTurn % 2 + 1].HP -= 3;
      }
    }
    p[playerTurn].hand.add(p[playerTurn].deck.get(0).copy());
    p[playerTurn].deck.remove(0);
  }
}
public Card resetCard(Card c)
{
  for(Card d: collection)
    if(c.displayName.equals(d.name)) return d; 
  if(c.name.equals("Money Farm")) return moneyFarm;
  return c;
}

public int indexOfCard(Card c)
{
  for(int i = 0; i<collection.length; i++)
  {
    if(c.name.equals(collection[i].name)) return i;
  }
  return -1;
}

public void addEffect(int duration, int index, String name) // Adding effect to card using index
{
  if(hasEffect(playField.get(index), "NoEffect")) return;
  Effect e = new Effect();
  e.duration = duration;
  if(mode == 0) e.givenBy = playerTurn; else e.givenBy = playerTurn % 2 + 1;
  e.name = name;
  boolean continues = false;
  for(Effect ef: playField.get(index).effects)
  {
    if(ef.name.equals(name)) 
    {
      if(ef.duration >= 0 && duration >= 0)
        ef.duration = max(duration, ef.duration);
      if(duration < 0)
        ef.duration = duration;
      continues = true;
    }
  }
  if(!continues) playField.get(index).effects.add(e);
}

public void addEffect(int duration, Card c, String name) // Adding effect to card using card itself
{  
  if(hasEffect(c, "NoEffect")) return;
  Effect e = new Effect();
  e.duration = duration;
  if(mode == 0) e.givenBy = playerTurn; else e.givenBy = playerTurn % 2 + 1;
  e.name = name; 
  boolean continues = false;
  for(Effect ef: c.effects)
  {
    if(ef.name.equals(name)) 
    {
      if(ef.duration >= 0 && ef.duration < duration)
      ef.duration = duration;
      continues = true;
    }
  }
  if(!continues) c.effects.add(e);
}

public void startMoveAnimation(boolean toSide, int index, int distance, int original)
{
  moveAnimation a = new moveAnimation();
  a.toSide = toSide;
  a.index = index;
  a.distance = distance;
  a.originalPos = original;
  moveAnimation = true; 
  moveAniTimer = 0;
  moveTargets.add(a);
}
public void startAnimation(int mode, int x, int y)
{
  Animation a = new Animation();
  a.x = x;
  a.y = y;
  a.type = mode;
  inAnimation = true; 
  aniTimer = 0;
  targets.add(a);
}

public void startAnimation(int mode, int x, int y, String name)
{
  Animation a = new Animation();
  a.x = x;
  a.y = y;
  a.type = mode;
  a.name = name;
  inAnimation = true; 
  aniTimer = 0;
  targets.add(a);
}
