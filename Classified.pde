import java.util.*; 
//<>//
/*
Lead Developer: Ben Zeng (yeahbennou#5727)
Started On: 2019-06-28
Current Date: 2019-09-10
*/

Card [] collection = new Card [101]; // All cards and spells in the game.
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

  // Moving
  int distMove;
  int indexMove;
  int moveType;
  
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
  for(int i = 0; i < collection.length; i++)
  {
    collection[i] = new Card();
  }
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
  // 
  
  // Setting Stats of Cards!
  collection[0].name = "Simon"; collection[0].ATK = 5; collection[0].HP = 8; collection[0].MVMT = 4; collection[0].RNG = 2; collection[0].cost = 2; collection[0].ability = "Special: Can attack and move in the same turn."; collection[0].category.addAll(Arrays.asList(0, 2));
  collection[1].name = "Kenneth"; collection[1].ATK = 7; collection[1].HP = 9; collection[1].MVMT = 2; collection[1].RNG = 2; collection[1].cost = 4; collection[1].ability = "Upon place: All cards gain +2 attack. While alive: Newly placed cards gain +2 attack. In addition to gaining attack, 'Elite' Cards also gain +2 HP."; collection[1].category.addAll(Arrays.asList(0, 2));
  collection[2].name = "Jonathan"; collection[2].ATK = 7; collection[2].HP = 8; collection[2].MVMT = 3; collection[2].RNG = 2; collection[2].cost = 2; collection[2].ability = "Upon place: All cards gain +1 attack. 'Non-Elite' cards gain +2 attack and +1 HP."; collection[2].category.addAll(Arrays.asList(0, 4));
  collection[3].name = "Uzziah"; collection[3].ATK = 6; collection[3].HP = 8; collection[3].MVMT = 4; collection[3].RNG = 2; collection[3].cost = 1; collection[3].ability = "When attacked: Return card to hand with +2 attack and +2 HP, if not killed."; collection[3].category.addAll(Arrays.asList(0, 4));
  collection[4].name = "Joseph"; collection[4].ATK = 11; collection[4].HP = 4; collection[4].MVMT = 2; collection[4].RNG = 3; collection[4].cost = 2; collection[4].ability = "Passive: This card gets destroyed after 3 turns. Special: If 'Annika' is on your playfield, this card has triple the attack to cards."; collection[4].category.addAll(Arrays.asList(0, 2));
  collection[5].name = "Jason C"; collection[5].ATK = 8; collection[5].HP = 13; collection[5].MVMT = 3; collection[5].RNG = 3; collection[5].cost = 5; collection[5].ability = "Target Enemy Card: Card loses -8 attack and -1 movement."; collection[5].category.addAll(Arrays.asList(0, 2));
  collection[6].name = "Kevin"; collection[6].ATK = 5; collection[6].HP = 4; collection[6].MVMT = 3; collection[6].RNG = 3; collection[6].cost = 2; collection[6].ability = "When attacked: This card gains +2 attack. When destroyed: Ressurect this card with 1 HP and +5 attack."; collection[6].category.addAll(Arrays.asList(0, 2));
  collection[7].name = "Samuel"; collection[7].ATK = 7; collection[7].HP = 11; collection[7].MVMT = 2; collection[7].RNG = 3; collection[7].cost = 3; collection[7].ability = "Upon place: All cards gain +1 attack. While alive: Newly placed cards gain +1 attack. This buff is doubled for 'Elite' Cards."; collection[7].category.addAll(Arrays.asList(0, 2));
  collection[8].name = "Yousif"; collection[8].ATK = 11; collection[8].HP = 15; collection[8].MVMT = 3; collection[8].RNG = 3; collection[8].cost = 4; collection[8].ability = "Upon destroying card: Send a random card from opponent's hand, back to their deck."; collection[8].category.addAll(Arrays.asList(0, 2));
  collection[9].name = "Mark"; collection[9].ATK = 11; collection[9].HP = 9; collection[9].MVMT = 2; collection[9].RNG = 2; collection[9].cost = 7; collection[9].ability = "Upon place: draw 2 cards. Upon destroying card: draw a card."; collection[9].category.addAll(Arrays.asList(1, 4));
  collection[10].name = "Chad"; collection[10].ATK = 7; collection[10].HP = 12; collection[10].MVMT = 3; collection[10].RNG = 3; collection[10].cost = 3; collection[10].ability = "When attacked: This card gains +3 ATK"; collection[10].category.addAll(Arrays.asList(1, 4));
  collection[11].name = "Tony"; collection[11].ATK = 18; collection[11].HP = 5; collection[11].MVMT = 3; collection[11].RNG = 3; collection[11].cost = 3; collection[11].ability = "Passive: This card gets destroyed after 3 turns."; collection[11].category.addAll(Arrays.asList(1, 4));
  collection[12].name = "Bonnie"; collection[12].ATK = 2; collection[12].HP = 13; collection[12].MVMT = 2; collection[12].RNG = 2; collection[12].cost = 4; collection[12].ability = "Special: This card takes 0 damage from cards over 8 HP. This card can attack twice in a turn."; collection[12].category.addAll(Arrays.asList(1, 4));
  collection[13].name = "Angela"; collection[13].ATK = 7; collection[13].HP = 10; collection[13].MVMT = 3; collection[13].RNG = 2; collection[13].cost = 6; collection[13].ability = "Special: This card, as well as the 8 cards surrounding it, take 3 less damage from all attacks."; collection[13].category.addAll(Arrays.asList(1, 4));
  collection[14].name = "Jason P"; collection[14].ATK = 4; collection[14].HP = 5; collection[14].MVMT = 3; collection[14].RNG = 3; collection[14].cost = 2; collection[14].ability = "Upon place: Push all your opponent’s cards as far back as they can go. These cards now have -2 MVMT for 1 turn."; collection[14].category.addAll(Arrays.asList(0, 2));
  collection[15].name = "Kabilan"; collection[15].ATK = 7; collection[15].HP = 10; collection[15].MVMT = 3; collection[15].RNG = 3; collection[15].cost = 2; collection[15].ability = "Upon attacking: This card's range increases by 1."; collection[15].category.addAll(Arrays.asList(1, 4));
  collection[16].name = "Hubert"; collection[16].ATK = 7; collection[16].HP = 18; collection[16].MVMT = 3; collection[16].RNG = 2; collection[16].cost = 6; collection[16].ability = "Special: Can increase a card's HP by 4, per turn."; collection[16].category.addAll(Arrays.asList(0, 2));
  collection[17].name = "Esther"; collection[17].ATK = 9; collection[17].HP = 6; collection[17].MVMT = 3; collection[17].RNG = 3; collection[17].cost = 3; collection[17].ability = "Upon place: Return one of your opponent's cards on the field to your opponent’s hand."; collection[17].category.addAll(Arrays.asList(0, 4));
  collection[18].name = "Jennifer"; collection[18].ATK = 7; collection[18].HP = 6; collection[18].MVMT = 3; collection[18].RNG = 3; collection[18].cost = 1; collection[18].ability = "Upon attacking: This card gains +2 attack."; collection[18].category.addAll(Arrays.asList(0, 4));
  collection[19].name = "Sharnujan"; collection[19].ATK = 3; collection[19].HP = 16; collection[19].MVMT = 2; collection[19].RNG = 1; collection[19].cost = 4; collection[19].ability = "Upon place: If there is another card that costs more than 4 dollars on the field, increase range by +4."; collection[19].category.addAll(Arrays.asList(1, 4));
  collection[20].name = "Richard"; collection[20].ATK = 3; collection[20].HP = 25; collection[20].MVMT = 2; collection[20].RNG = 1; collection[20].cost = 5; collection[20].ability = "Upon place: Send a random card in the opponent's hand back to their deck."; collection[20].category.addAll(Arrays.asList(1, 4));
  collection[21].name = "Annika"; collection[21].ATK = 4; collection[21].HP = 6; collection[21].MVMT = 2; collection[21].RNG = 3; collection[21].cost = 1; collection[21].ability = "Upon attacking: Card being attacked gets sent back to opponent's hand with base stats."; collection[21].category.addAll(Arrays.asList(1, 4));
  collection[22].name = "Antnohy"; collection[22].ATK = 8; collection[22].HP = 15; collection[22].MVMT = 4; collection[22].RNG = 3; collection[22].cost = 6; collection[22].ability = "Upon attacking: If card being attacked costs more than $4, this does +3 damage. Special: All attacks also splash onto the 8 cards around the card being attacked."; collection[22].category.addAll(Arrays.asList(2));
  collection[23].name = "Vinod"; collection[23].ATK = 4; collection[23].HP = 11; collection[23].MVMT = 3; collection[23].RNG = 3; collection[23].cost = 3; collection[23].ability = "Special: This card takes -8 damage from all sources if there is an 'Class H' card on the field."; collection[23].category.addAll(Arrays.asList(1, 4));
  collection[24].name = "Jefferson"; collection[24].ATK = 7; collection[24].HP = 13; collection[24].MVMT = 3; collection[24].RNG = 2; collection[24].cost = 4; collection[24].ability = "Upon place: Completely remove a card's special ability forever, as well as its ability to be effected. All Elite cards gain +1 attack. Passive: This card cannot be targeted by any effects."; collection[24].category.addAll(Arrays.asList(0, 2));
  collection[25].name = "Ben"; collection[25].ATK = 9; collection[25].HP = 26; collection[25].MVMT = 4; collection[25].RNG = 3; collection[25].cost = 8; collection[25].ability = "While alive: All 'Elite' cards have an additional +3 attack. Special: This card has +1 attack per 'Elite' card on the field. At start of turn: Deal 2 damage to enemy player."; collection[25].category.addAll(Arrays.asList(1, 2));
  collection[26].name = "Snake"; collection[26].ATK = 2; collection[26].HP = 8; collection[26].MVMT = 1; collection[26].RNG = 1; collection[26].cost = 3; collection[26].ability = "Upon place: This card is now your opponent's. Special: Cards less than $4 cannot be placed by the opponent. Passive: This card gets destroyed after 3 turns."; collection[26].category.addAll(Arrays.asList(5));
  collection[27].name = "Ethan"; collection[27].ATK = 8; collection[27].HP = 4; collection[27].MVMT = 2; collection[27].RNG = 2; collection[27].cost = 3; collection[27].ability = "Special: Can destroy both itself and an opponent’s card of under $5 at any time."; collection[27].category.addAll(Arrays.asList(1, 4));
  collection[28].name = "German Machine Guns"; collection[28].cost = 4; collection[28].ability = "Target your card: For this turn it can attack another time."; collection[28].isSpell = true; collection[28].targetsYou = true;
  collection[29].name = "Defense Position"; collection[29].cost = 3; collection[29].ability = "Target your card: It can now resurrect with 1 HP once it dies. This card now takes 3 less damage from all sources."; collection[29].isSpell = true; collection[29].targetsYou = true;
  collection[30].name = "Attack Position"; collection[30].cost = 2; collection[30].ability = "Target your card: This card gains +6 attack, and gains 2 attack every time it is attacked."; collection[30].isSpell = true; collection[30].targetsYou = true;
  collection[31].name = "A.L.I.C.E."; collection[31].ATK = 11; collection[31].HP = 20; collection[31].MVMT = 3; collection[31].RNG = 3; collection[31].cost = 10; collection[31].ability = "Upon place: All other cards gain +3 attack and +3 HP. Prototype cards gain +6 instead of +3. While alive: All cards take 3 less damage. At start of turn: All cards gain +1 attack and +1 HP. Special: This card has x2 attack if 'Moonlight' is on your field."; collection[31].category.addAll(Arrays.asList(5));
  collection[32].name = "Ben 2.0"; collection[32].ATK = 9; collection[32].HP = 22; collection[32].MVMT = 2; collection[32].RNG = 2; collection[32].cost = 9; collection[32].ability = "Special: All attacks to other cards or the player will be dealt to this card instead, doing half the damage. Special: This card’s health and survivability cannot be increased in any way."; collection[32].category.addAll(Arrays.asList(5));
  collection[33].name = "Mandaran"; collection[33].ATK = 6; collection[33].HP = 9; collection[33].MVMT = 2; collection[33].RNG = 3; collection[33].cost = 4; collection[33].ability = "Target your card: This card cannot be attacked for 1 round."; collection[33].category.addAll(Arrays.asList(0, 4));
  collection[34].name = "George"; collection[34].ATK = 7; collection[34].HP = 10; collection[34].MVMT = 2; collection[34].RNG = 2; collection[34].cost = 2; collection[34].ability = "Target your card: Card gains +4 HP and +3 ATK."; collection[34].category.addAll(Arrays.asList(0, 4));
  collection[35].name = "Lina"; collection[35].ATK = 9; collection[35].HP = 9; collection[35].MVMT = 2; collection[35].RNG = 3; collection[35].cost = 2; collection[35].ability = "At start of turn: Gain +1 HP if this card has not been attacked yet."; collection[35].category.addAll(Arrays.asList(1, 4));
  collection[36].name = "Lucy"; collection[36].ATK = 3; collection[36].HP = 13; collection[36].MVMT = 2; collection[36].RNG = 3; collection[36].cost = 3; collection[36].ability = "When any of your opponent's cards attack, this card gains +1 attack."; collection[36].category.addAll(Arrays.asList(1, 4));
  collection[37].name = "Andrew"; collection[37].ATK = 6; collection[37].HP = 4; collection[37].MVMT = 4; collection[37].RNG = 3; collection[37].cost = 1; collection[37].ability = "This card does +3 damage when attacking a Elite card, and +5 damage when attacking the Player."; collection[37].category.addAll(Arrays.asList(1, 4));
  collection[38].name = "Steven"; collection[38].ATK = 8; collection[38].HP = 13; collection[38].MVMT = 3; collection[38].RNG = 3; collection[38].cost = 3; collection[38].ability = "This card takes 1 less damage from all sources."; collection[38].category.addAll(Arrays.asList(1, 4));
  collection[39].name = "Neil"; collection[39].ATK = 7; collection[39].HP = 12; collection[39].MVMT = 2; collection[39].RNG = 3; collection[39].cost = 3; collection[39].ability = "All Class G attacks only do 2 damage to this card."; collection[39].category.addAll(Arrays.asList(1, 4));
  collection[40].name = "Rita"; collection[40].ATK = 4; collection[40].HP = 12; collection[40].MVMT = 3; collection[40].RNG = 1; collection[40].cost = 3; collection[40].ability = "All your opponent’s cards do 1 less damage while this card is alive."; collection[40].category.addAll(Arrays.asList(1, 4));
  collection[41].name = "Matthew"; collection[41].ATK = 6; collection[41].HP = 10; collection[41].MVMT = 3; collection[41].RNG = 3; collection[41].cost = 3; collection[41].ability = "This card can attack over other cards."; collection[41].category.addAll(Arrays.asList(1, 4));
  collection[42].name = "Selina"; collection[42].ATK = 7; collection[42].HP = 4; collection[42].MVMT = 2; collection[42].RNG = 2; collection[42].cost = 1; collection[42].ability = "This card cannot be damaged by cards that cost $2 or less."; collection[42].category.addAll(Arrays.asList(1, 4));
  collection[43].name = "Yucen"; collection[43].ATK = 1; collection[43].HP = 5; collection[43].MVMT = 1; collection[43].RNG = 1; collection[43].cost = 2; collection[43].ability = "At the start of every turn, you gain $2 extra if the card is alive."; collection[43].category.addAll(Arrays.asList(1, 4));
  collection[44].name = "Anny"; collection[44].ATK = 8; collection[44].HP = 7; collection[44].MVMT = 3; collection[44].RNG = 4; collection[44].cost = 4; collection[44].ability = "This card has double damage for the first 3 turns."; collection[44].category.addAll(Arrays.asList(1, 4));
  collection[45].name = "Vithiya"; collection[45].ATK = 4; collection[45].HP = 4; collection[45].MVMT = 1; collection[45].RNG = 3; collection[45].cost = 2; collection[45].ability = "When this card attacks, draw a card."; collection[45].category.addAll(Arrays.asList(0, 4));
  collection[46].name = "Odelia"; collection[46].ATK = 9; collection[46].HP = 12; collection[46].MVMT = 3; collection[46].RNG = 3; collection[46].cost = 4; collection[46].ability = "Cards this card damages does 4 less damage, and cannot move next turn."; collection[46].category.addAll(Arrays.asList(0, 4));
  collection[47].name = "Anthony"; collection[47].ATK = 14; collection[47].HP = 17; collection[47].MVMT = 3; collection[47].RNG = 3; collection[47].cost = 7; collection[47].ability = "When this card is summoned, heal any card by 8 HP, boost it’s attack by 6 ATK, and movement by 1."; collection[47].category.addAll(Arrays.asList(0, 2));
  collection[48].name = "Ultrabright"; collection[48].ATK = 8; collection[48].HP = 18; collection[48].MVMT = 3; collection[48].RNG = 4; collection[48].cost = 8; collection[48].ability = "This card can attack over other cards. For every turn this card is alive, deal 1 damage to the opponent and heal 1 damage for your own player. You cannot buff the range of this card."; collection[48].category.addAll(Arrays.asList(5));
  collection[49].name = "Moonlight"; collection[49].ATK = 5; collection[49].HP = 12; collection[49].MVMT = 2; collection[49].RNG = 3; collection[49].cost = 6; collection[49].ability = "Heal player by 6 HP when placed. When this unit attacks, heal itself and player by half of the damage dealt."; collection[49].category.addAll(Arrays.asList(5));
  collection[50].name = "Florence"; collection[50].ATK = 2; collection[50].HP = 7; collection[50].MVMT = 4; collection[50].RNG = 4; collection[50].cost = 1; collection[50].ability = "Change all Class H attacks to this card to do 3 damage."; collection[50].category.addAll(Arrays.asList(0, 4));
  collection[51].name = "Megan"; collection[51].ATK = 8; collection[51].HP = 0; collection[51].MVMT = 2; collection[51].RNG = 3; collection[51].cost = 2; collection[51].ability = "This card’s HP when summoned is the HP of your player divided by 2 (rounded up)."; collection[51].category.addAll(Arrays.asList(0, 4));
  
  // Expansion Pack 1: Spells + "Traveller" Cards
  
  collection[52].name = "Fireball"; collection[52].cost = 4; collection[52].ability = "Target one of your opponent's cards: Deal 12 damage."; collection[52].isSpell = true;
  collection[53].name = "Mini Gulag"; collection[53].cost = 5; collection[53].ability = "Target an opponent's card and all 8 cards around it: These cards now have -4 Attack and -4 HP."; collection[53].isSpell = true;
  collection[54].name = "Holy Hand Grenade"; collection[54].cost = 5; collection[54].ability = "Target an opponent's card: Deal 9 damage to that card and 6 damage to the 8 tiles around it."; collection[54].isSpell = true;
  collection[55].name = "Stall"; collection[55].cost = 2; collection[55].ability = "Target an opponent's card: This card cannot move next turn. Draw a card."; collection[55].isSpell = true;
  collection[56].name = "Expectations Ever Increasing"; collection[56].cost = 3; collection[56].ability = "All your cards in hand are now $1 more expensive, but gain 4 ATK and 4 HP."; collection[56].isSpell = true;
  collection[57].name = "Propaganda Machine"; collection[57].cost = 2; collection[57].ability = "Draw a random card from collection that is $3 - $5. This card is now $1 cheaper."; collection[57].isSpell = true;
  collection[58].name = "King Henry"; collection[58].ATK = 19; collection[58].HP = 15; collection[58].MVMT = 3; collection[58].RNG = 2; collection[58].cost = 8; collection[58].ability = "While this card is alive, starting on the next turn, all your cards will have double damage for 1 turn. Draw an extra card every round."; collection[58].category.addAll(Arrays.asList(3));
  collection[59].name = "J.Flipped"; collection[59].ATK = 8; collection[59].HP = 12; collection[59].MVMT = 4; collection[59].RNG = 4; collection[59].cost = 6; collection[59].ability = "Cards this card attacks cannot attack for a turn."; collection[59].category.addAll(Arrays.asList(3));
  collection[60].name = "Hexagonal"; collection[60].ATK = 9; collection[60].HP = 12; collection[60].MVMT = 3; collection[60].RNG = 3; collection[60].cost = 8; collection[60].ability = "When any of your cards get attacked, attack the attacker using this card and take 2 damage. When this card dies, deal 4 damage to all of your opponent’s cards. This card's HP or survivability cannot be increased in any way."; collection[60].category.addAll(Arrays.asList(3));
  collection[61].name = "Physouie"; collection[61].ATK = 11; collection[61].HP = 6; collection[61].MVMT = 2; collection[61].RNG = 1; collection[61].cost = 9; collection[61].ability = "Destroy this card after 3 rounds. When this card dies, summon 3 Elite cards from collection and put them in your hand. These cards now have +2 HP and +2 ATK and are $2 cheaper."; collection[61].category.addAll(Arrays.asList(3));
  collection[62].name = "GeeTraveller"; collection[62].ATK = 12; collection[62].HP = 9; collection[62].MVMT = 2; collection[62].RNG = 3; collection[62].cost = 6; collection[62].ability = "This card deals damage to all cards in the lane that it is attacking."; collection[62].category.addAll(Arrays.asList(3));
  collection[63].name = "Ridge Rhea"; collection[63].ATK = 1; collection[63].HP = 27; collection[63].MVMT = 1; collection[63].RNG = 1; collection[63].cost = 8; collection[63].ability = "Cards in the same lane as this card have 2 extra range. Movement cannot be increased."; collection[63].category.addAll(Arrays.asList(3));
  collection[64].name = "Jawnie Dirp"; collection[64].ATK = 11; collection[64].HP = 11; collection[64].MVMT = 5; collection[64].RNG = 2; collection[64].cost = 5; collection[64].ability = "Target an opponent’s card: Reduce it’s damage and health by 8."; collection[64].category.addAll(Arrays.asList(3));
  collection[65].name = "Yebanow"; collection[65].ATK = 18; collection[65].HP = 11; collection[65].MVMT = 3; collection[65].RNG = 3; collection[65].cost = 7; collection[65].ability = "All Traveller cards gain 1 HP and 1 ATK upon placing down. Upon placing, spawn a random $1 card on all tiles horizontally or vertically adjacent to this one."; collection[65].category.addAll(Arrays.asList(3));
  collection[66].name = "Zoo Wee Mama!"; collection[66].cost = 2; collection[66].ability = "Target one of your opponent's cards: Deal 8 damage."; collection[66].isSpell = true;
  collection[67].name = "Miss Me"; collection[67].cost = 3; collection[67].ability = "Target one of your cards: This card is untargetable by attacks for this turn."; collection[67].isSpell = true; collection[67].targetsYou = true;
  collection[68].name = "Dragon Wings"; collection[68].cost = 4; collection[68].ability = "Target one of your cards: This card gains 2 MVMT and 1 RNG."; collection[68].isSpell = true; collection[68].targetsYou = true;
  collection[69].name = "Mr. Sketch"; collection[69].cost = 3; collection[69].ability = "Target one of your cards: This card gains 5 ATK and 8 HP."; collection[69].isSpell = true; collection[69].targetsYou = true;
  collection[70].name = "T-Pose"; collection[70].cost = 6; collection[70].ability = "Target one of your cards: For each card your opponent has on the field, buff your card by 1 ATK and 1 HP, and lower that card's ATK and HP by 1."; collection[70].isSpell = true; collection[70].targetsYou = true;
  collection[71].name = "Terminator"; collection[71].cost = 3; collection[71].ability = "Deal 6 damage to all cards including your own."; collection[71].isSpell = true;
  
  // Expansion Pack 2: Novelty Cards
  
  collection[72].name = "Mr. Willikens"; collection[72].ATK = 0; collection[72].HP = 14; collection[72].MVMT = 3; collection[72].RNG = 4; collection[72].cost = 4; collection[72].ability = "This card's attack is equal to the number of novelty cards on the field when placed. Upon placing this card, boost all novelty cards' HP by 3."; collection[72].category.addAll(Arrays.asList(6));
  collection[73].name = "Mr. Billikens"; collection[73].ATK = 14; collection[73].HP = 0; collection[73].MVMT = 4; collection[73].RNG = 3; collection[73].cost = 4; collection[73].ability = "This card's health is equal to the number of novelty cards on the field when placed. Upon placing this card, boost all novelty cards' ATK by 3."; collection[73].category.addAll(Arrays.asList(6));
  collection[74].name = "Mr. Utnapis"; collection[74].ATK = 7; collection[74].HP = 7; collection[74].MVMT = 4; collection[74].RNG = 3; collection[74].cost = 2; collection[74].ability = "This card gains 2 ATK and 2 HP every time it attacks."; collection[74].category.addAll(Arrays.asList(6));
  collection[75].name = "Mr. Facto"; collection[75].ATK = 6; collection[75].HP = 7; collection[75].MVMT = 5; collection[75].RNG = 2; collection[75].cost = 4; collection[75].ability = "When this card is placed, summon a random Novelty card from deck. This card is now $3 cheaper."; collection[75].category.addAll(Arrays.asList(6));
  collection[76].name = "Mr. Ustenglibo"; collection[76].ATK = 24; collection[76].HP = 12; collection[76].MVMT = 2; collection[76].RNG = 2; collection[76].cost = 7; collection[76].ability = "This card cannot be effected. When card dies, all novelty cards on field cannot be targeted by attacks for 1 turn."; collection[76].category.addAll(Arrays.asList(6));
  collection[77].name = "Mr. Onosukoo"; collection[77].ATK = 18; collection[77].HP = 4; collection[77].MVMT = 1; collection[77].RNG = 5; collection[77].cost = 5; collection[77].ability = "Destroy this card next turn."; collection[77].category.addAll(Arrays.asList(6));
  collection[78].name = "Mr. Homas"; collection[78].ATK = 0; collection[78].HP = 13; collection[78].MVMT = 1; collection[78].RNG = 3; collection[78].cost = 3; collection[78].ability = "Every turn, this card gains 3 ATK."; collection[78].category.addAll(Arrays.asList(6));
  collection[79].name = "Mr. Bing"; collection[79].ATK = 9; collection[79].HP = 12; collection[79].MVMT = 4; collection[79].RNG = 2; collection[79].cost = 4; collection[79].ability = "This card gains +2 attack and +2 HP whenever you place a card."; collection[79].category.addAll(Arrays.asList(6));
  collection[80].name = "Ms. Fillip"; collection[80].ATK = 4; collection[80].HP = 14; collection[80].MVMT = 3; collection[80].RNG = 1; collection[80].cost = 6; collection[80].ability = "When any of your novelty cards attacks a card, this card will do an extra attack to that card. When this card attacks a card, deal 1 damage to enemy player."; collection[80].category.addAll(Arrays.asList(6));
  collection[81].name = "Mr. Valentino"; collection[81].ATK = 16; collection[81].HP = 16; collection[81].MVMT = 2; collection[81].RNG = 4; collection[81].cost = 10; collection[81].ability = "Upon place: All novelty cards get to do an extra attack this turn. While this card is alive, whenever any other of your novelty cards attacks, both this card, and the card attacking, gain +1 HP."; collection[81].category.addAll(Arrays.asList(6));
  collection[82].name = "Mr. Stirrychigg"; collection[82].ATK = 9; collection[82].HP = 8; collection[82].MVMT = 3; collection[82].RNG = 3; collection[82].cost = 4; collection[82].ability = "When placed, summon a ‘Mr. Utnapis’ in front of this card."; collection[82].category.addAll(Arrays.asList(6));
  collection[83].name = "Hit It Boys!"; collection[83].cost = 2; collection[83].ability = "Target one of your cards: For 3 turns, it can move sideways."; collection[83].isSpell = true; collection[83].targetsYou = true;
  collection[84].name = "Mr. Filascario"; collection[84].ATK = 18; collection[84].HP = 45; collection[84].MVMT = 2; collection[84].RNG = 2; collection[84].cost = 11; collection[84].ability = "Special: All future cards placed by the opponent will have -4 HP and -4 ATK, while this card is alive. Whenever you draw a card, deal 3 damage to your opponent."; collection[84].category.addAll(Arrays.asList(6));
  collection[85].name = "Crystal Clear"; collection[85].ATK = 5; collection[85].HP = 18; collection[85].MVMT = 4; collection[85].RNG = 2; collection[85].cost = 6; collection[85].ability = "This card gains 8 attack every time it gets attacked."; collection[85].category.addAll(Arrays.asList(5));
  collection[86].name = "Ms. Aftner"; collection[86].ATK = 6; collection[86].HP = 8; collection[86].MVMT = 2; collection[86].RNG = 4; collection[86].cost = 3; collection[86].ability = "Knockback 2: When this card attacks an opponents' card, send it back a maximum of 2 tiles, if possible. That card cannot move for 1 turn."; collection[86].category.addAll(Arrays.asList(6));
  collection[87].name = "Ms. Iceberg"; collection[87].ATK = 10; collection[87].HP = 14; collection[87].MVMT = 2; collection[87].RNG = 2; collection[87].cost = 5; collection[87].ability = "Special: Each turn, you can do a special attack that does 4 damage to any of your opponents' cards."; collection[87].category.addAll(Arrays.asList(6));
  collection[88].name = "Raw Eggs and Soy Sauce"; collection[88].cost = 1; collection[88].ability = "Target one of your cards: It gains 4 attack, but now takes 3 extra damage from all attacks."; collection[88].isSpell = true; collection[88].targetsYou = true;
  collection[89].name = "Sebastian’s Tea"; collection[89].cost = 4; collection[89].ability = "Target one of your opponents' cards: Each turn, this card loses 5 HP and 5 ATK."; collection[89].isSpell = true; 
  collection[90].name = "Elite's Calling"; collection[90].cost = 13; collection[90].ability = "When Used: Summon 'Ben', 'Hubert', aswell as 3 random $4 or less Elite cards on the start row."; collection[90].isSpell = true; 
  collection[91].name = "Awakening"; collection[91].cost = 3; collection[91].ability = "All your Elite cards gain +2 HP and +3 ATK."; collection[91].isSpell = true; 
  collection[92].name = "The Duality of an Illiken"; collection[92].cost = 7; collection[92].ability = "Summon Mr. Willikens and Mr. Billikens in random lanes, who cannot be attacked this turn."; collection[92].isSpell = true; 
  collection[93].name = "Novelty Wings"; collection[93].cost = 1; collection[93].ability = "Increase a card's range by 1 for 1 turn, and 2 turns if the card is a novelty card."; collection[93].isSpell = true; collection[93].targetsYou = true;
  collection[94].name = "Mr. Websterien"; collection[94].ATK = 7; collection[94].HP = 7; collection[94].MVMT = 5; collection[94].RNG = 4; collection[94].cost = 4; collection[94].ability = "Each Turn: This card gains 2 HP and 2 ATK. Upon death: Draw a Mr. Pengamah with +1 Range."; collection[94].category.addAll(Arrays.asList(6));
  collection[95].name = "Mr. Pegamah"; collection[95].ATK = 4; collection[95].HP = 3; collection[95].MVMT = 2; collection[95].RNG = 4; collection[95].cost = 1; collection[95].ability = "This card can attack the player first turn. This card does twice the damage towards the player. This card's attack cannot be modified."; collection[95].category.addAll(Arrays.asList(6));
  collection[96].name = "Mr. Tornado"; collection[96].cost = 2; collection[96].ability = "Send an opponent's card back to their hand."; collection[96].isSpell = true;
  collection[97].name = "Ms. Nicke"; collection[97].ATK = 2; collection[97].HP = 4; collection[97].MVMT = 2; collection[97].RNG = 2; collection[97].cost = 0; collection[97].ability = "If 'Esther' is on your field, this card does +12 damage to Elite cards and +7 damage to all other cards."; collection[97].category.addAll(Arrays.asList(6));
  collection[98].name = "Ilem"; collection[98].ATK = 9; collection[98].HP = 9; collection[98].MVMT = 4; collection[98].RNG = 3; collection[98].cost = 9; collection[98].ability = "When this card is attacked, deal 3 damage to all of your opponents’ cards. When this card dies: It gets to resurrect one time. When resurrecting, change this card’s ATK and HP to 20, and boost all Elite cards’ attack by 2."; collection[98].category.addAll(Arrays.asList(2));
  collection[99].name = "Windmill"; collection[99].cost = 4; collection[99].ability = "Double one of your cards' HP (Can only increase by 18 MAX), and increase its movement by 1."; collection[99].isSpell = true; collection[99].targetsYou = true;
  collection[100].name = "Mr. Farewell"; collection[100].ATK = 2; collection[100].HP = 12; collection[100].MVMT = 3; collection[100].RNG = 1; collection[100].cost = 6; collection[100].ability = "Summon a random $2 or less card in a random lane, whenever you manually place a card. Destroy this card after 3 turns."; collection[100].category.addAll(Arrays.asList(6));
  sortCollection();
  for(Card c: collection) c.setupNBT(); // Setting up NBT Values.
  
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
    offlineDecks[0] [i] = collection [decode[i]];
    offlineDecks[1] [i] = collection [decode2[i]];
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
    if(c.name == "Money Farm" && !hasEffect(c, "Nullify") && c.player == opp)
          p[opp].cash += 1;
    if(c.name == "Yucen" && !hasEffect(c, "Nullify") && c.player == opp) p[opp].cash+=2;
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
      if(c.name == "Money Farm")
      {
        hasFarm = true;
      }
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
      
      if(!hasEffect(c, "Nullify")) // Assuming they aren't nullified
      {
        if(hasEffect(c, "HealDisable")) // "Lina"'s Effect, which increases 1 HP per turn while the card has not been attacked yet
          c.HP++;
        if(hasEffect(c, "Tea")) // Spell Effect
        {
          c.HP -= 5;
          c.ATK -= 5;
        }
        // Stat Buffs
        if(c.name == "Mr. Homas") 
          c.ATK += 3;
        if(c.name == "Mr. Websterien")
        {
          c.ATK += 2;
          c.HP += 2;
        }
        if(c.NBTTags.contains("SpecialMove")) // Some cards have a special 4th option besides Attacking, Moving, Discarding. 
          c.canSpecial = true;
        if(c.name == "Bonnie") // Can attack twice each turn.
          c.attackCount = 2;
        if(c.name == "Ben") // Deals direct damage to enemy player.
          p[opp % 2 + 1].HP -= 2;
        if(c.name == "King Henry" && mode == 0) // Draws an extra card.
          drawCard(opp);
        if(c.name == "Ultrabright") // Heals you, ticks them.
        {
          p[opp % 2 + 1].HP--;
          p[opp].HP++;
        }
        if(c.name == "A.L.I.C.E.") // Buffing
        {
          for(Card d: playField)
          {
            if(!hasEffect(d, "NoEffect") && d.player == c.player)
            {
              d.ATK+=1;
              if(!d.NBTTags.contains("Unhealable"))
                d.HP+=1;
            }
          }
        }
      }
      // Discarding Cards, Removing Effects
      ArrayList <Effect> tempRemove = new ArrayList <Effect>();
      boolean finishedDiscarding = false;
      for(Effect e: c.effects)
      {
        
        e.duration--;
        if(e.duration == 0)
        {
          tempRemove.add(e); // Normal Removal of Cards
          if(e.name == "Alive") // Discarded Cards
            finishedDiscarding = true;
        }
      }
      if(finishedDiscarding)
      {
        c.HP = -Integer.MAX_VALUE; // Makes sure they are dead
        c.effects.clear(); // Removes any effects that allow them to resurrect
        startAnimation(8, c.x, c.y);
      }
      if(tempRemove.size() > 0)
      {
        for(Effect e : tempRemove)
          c.effects.remove(e); // BOOOM DEAD EFFECT
      }
    }
  }
  for(Card c: playField)
  {
    if(c.name == "King Henry" && !hasEffect(c, "Nullify") && c.player == opp) // Double attack this turn
    {
      for(Card d: playField)
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
    if(e.name == name)
      return true;
  }
  return false;
}

public int searchCard(String name)
{
  int i = 0;
  for(Card c: collection)
  {
    if(c.name == name)
    {
      return i;
    }
    i++;
  }
  return -1;
}

public void copyPlayfield(ArrayList <Card> stuff, String copyTo) // Deep Copying the playfield. 
{
  // stuff refers to the playfield that will be duplicated. copyTo is the name of the playfield that will recieve the duplicate.
  if(copyTo == "playField")
      playField = new ArrayList<Card>();
  if(copyTo == "oldPlayField")
    oldPlayField = new ArrayList<Card>();
  if(copyTo == "currentPlayField")
    currentPlayField = new ArrayList<Card>();
  for(Card c: stuff)
  {
    Card card = c.copy();
    if(copyTo == "playField")
      playField.add(card);
    if(copyTo == "oldPlayField")
      oldPlayField.add(card);
    if(copyTo == "currentPlayField")
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
          if(m.name == "Antnohy" && !hasEffect(playField.get(playFieldSelected), "Nullify") && !hasEffect(playField.get(m.targeted), "Invincible"))
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
          if(m.name == "GeeTraveller" && !hasEffect(playField.get(playFieldSelected), "Nullify") && !hasEffect(playField.get(m.targeted), "Invincible"))
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
      if(c.name == "Mr. Filascario" && !hasEffect(c, "Nullify") && c.player == playerTurn) p[playerTurn % 2 + 1].HP -= 3;
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
      if(c.name == "Mr. Filascario" && !hasEffect(c, "Nullify") && c.player == opp) p[opp % 2 + 1].HP -= 3;
    }
    p[opp].hand.add(p[opp].deck.get(0).copy());
    p[opp].deck.remove(0);
  }
}
public void drawCard(String mode)
{
  
  if(p[playerTurn].deck.size() > 0)
  {
    if(mode != "Cycle")
    {
      for(Card c: playField)
      {
        if(c.name == "Mr. Filascario" && !hasEffect(c, "Nullify") && c.player == playerTurn) p[playerTurn % 2 + 1].HP -= 3;
      }
    }
    p[playerTurn].hand.add(p[playerTurn].deck.get(0).copy());
    p[playerTurn].deck.remove(0);
  }
}
public Card resetCard(Card c)
{
  for(Card d: collection)
  {
    if(c.name == d.name) return d; 
  }
  if(c.name == "Money Farm") return moneyFarm;
  return c;
}

public int indexOfCard(Card c)
{
  for(int i = 0; i<collection.length; i++)
  {
    if(c.name == collection[i].name) return i;
  }
  return -1;
}

public void addEffect(int duration, int index, String name) // Adding effect to card using index
{
  if(hasEffect(playField.get(index), "NoEffect")) return;
  Effect e = new Effect();
  e.duration = duration;
  if(playField.get(index).player != playerTurn && mode == 0 && duration >= 0) e.duration++;
  e.name = name;
  boolean continues = false;
  for(Effect ef: playField.get(index).effects)
  {
    if(ef.name == name) 
    {
      if(ef.duration >= 0 && ef.duration < duration)
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
  if(c.player != playerTurn && mode == 0 && duration >= 0) e.duration++;
  e.name = name; 
  boolean continues = false;
  for(Effect ef: c.effects)
  {
    if(ef.name == name) 
    {
      if(ef.duration >= 0 && ef.duration < duration)
      ef.duration = duration;
      continues = true;
    }
  }
  if(!continues) c.effects.add(e);
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
