void actionAnimate()
{
  int transparency = 255 - 7 * aniTimer;
  if(transparency <= -70 || !animationOn())
  {
    inAnimation = false;
    targets.clear();
  }
  for(Animation a: targets)
  {
    if(a.type == 1)
    {
      noStroke();
      fill(0xffD60606, transparency - 110);
      rect(width / 2, height / 2, width, height);
      strokeWeight(15);
      if(a.x == -1 && a.y == -1) // Player
      {   
        fill(0xffD60606, transparency);
        stroke(0xffF24747, transparency);
        if(mode == 0)
          ellipse(350, 50, 180, 180);
        else
          ellipse(350, 750, 180, 180);
      }
      else 
      {
        int yF = a.y * 100 + 50; if(playerTurn == 2) yF = a.y * -100 + 750;
        fill(0xffD60606, transparency);
        stroke(0xffF24747, transparency);
        rect(a.x * 100 + 50, yF, 130, 130);
        noStroke();
      }
    }
    else if(a.type == 8)
    {
      strokeWeight(15);
      int yF = a.y * 100 + 50; if(playerTurn == 2) yF = a.y * -100 + 750;
      fill(50, transparency);
      stroke(0, transparency);
      ellipse(a.x * 100 + 50, yF, 220, 220);
    
      textSize(60);
      
      fill(170, transparency - 40);
      text("GONE", a.x * 100 + 50 + 3, yF + 3);
      
      fill(0, transparency);
      text("GONE", a.x * 100 + 50, yF);
    }
    else
    {
      int sw = 15; if(a.type == 5) sw = 140;
      int offset = 0; if(a.type == 7) offset = 70;
      int lighter = 0, darker = 0;
      String textDisplay = "";
      strokeWeight(sw);
      int yF = a.y * 100 + 50; if(playerTurn == 2) yF = a.y * -100 + 750;
      
      switch(a.type) 
      {
        case 2:
          lighter = 0xff1D87CB; darker = 0xff74C8FF; textDisplay = "HEAL"; break;
        case 3:
          lighter = 0xff5DF247; darker = 0xff86FF74; textDisplay = "EFFECTED"; break;  
        case 4:
          lighter = 0xffA21DCB; darker = 0xffB91AEA; break;  
        case 5:
          lighter = 255; darker = 190; break;  
        case 6:
          lighter = 50; darker = 0; textDisplay = "DISCARD"; break;  
        case 7:
          lighter = 0xff5DF247; darker = 0xff86FF74; textDisplay = a.name.toUpperCase(); break;  
        case 10:
          lighter = 0xffFF0A85; darker = 0xff810945; textDisplay = "SPECIAL"; break;  
        case 11:
          lighter = #E3CA67; darker = #6C590D; textDisplay = "BUFF"; break;  
        case 12:
          lighter = #762BFA; darker = #3B1383; textDisplay = "DESTROY"; break;  
      }
      fill(lighter, transparency);
      stroke(darker, transparency);
      ellipse(a.x * 100 + 50, yF, 220, 220);
      
      textSize(60);
      fill(170, transparency + offset - 40);
      text(textDisplay, a.x * 100 + 50 + 3, yF + 3);
      
      fill(darker, transparency + offset);
      text(textDisplay, a.x * 100 + 50, yF);
      
      if(a.type == 4)
      {
        yF = selfY * 100 + 50; if(playerTurn == 2) yF = selfY * -100 + 750;
        ellipse(selfX * 100 + 50, yF, 220, 220);
      }
    }
  }
}
