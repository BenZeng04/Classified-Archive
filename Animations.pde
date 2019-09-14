void actionAnimate()
{
  int transparency = 255 - 7 * aniTimer;
  if(animationMode == 1) 
  {
    noStroke();
    fill(0xffD60606, transparency - 50);
    rect(width / 2, height / 2, width, height);
    strokeWeight(15);
    for(int i = 0; i < ATKX.size(); i++)
    {
      if(ATKX.get(i) == -1 && ATKY.get(i) == -1) // Player
      {   
        fill(0xffD60606, transparency);
        stroke(0xffF24747, transparency);
        if(mode == 0)
          ellipse(350, 50, 180, 180);
        else
          ellipse(350, 750, 180, 180);
        if(transparency <= 0)
        {
          inAnimation = false;
          ATKX.clear(); ATKY.clear();
        }
      }
      else 
      {
        int yF = ATKY.get(i) * 100 + 50; if(playerTurn == 2) yF = ATKY.get(i) * -100 + 750;
        fill(0xffD60606, transparency);
        stroke(0xffF24747, transparency);
        
          rect(ATKX.get(i) * 100 + 50, yF, 130, 130);
      
        if(transparency <= 0)
        {
          inAnimation = false;
          ATKX.clear(); ATKY.clear();
        }
      }
    }
  }
  else if(animationMode == 8) // Card destroyed due to end of turn. 
  {
    strokeWeight(15);
    for(int i = 0; i < DiscardX.size(); i++)
    {
      int yF = DiscardY.get(i) * 100 + 50; if(playerTurn == 2) yF = DiscardY.get(i) * -100 + 750;
      fill(50, transparency);
      stroke(0, transparency);
      ellipse(DiscardX.get(i) * 100 + 50, yF, 220, 220);
    
      textSize(60);
      
      fill(170, transparency - 40);
      text("Gone", DiscardX.get(i) * 100 + 50 + 3, yF + 3);
      
      fill(0, transparency);
      text("Gone", DiscardX.get(i) * 100 + 50, yF);
    
      if(transparency <= 0)
      {
        inAnimation = false;
        DiscardX.clear(); DiscardY.clear();
      }
    } 
  }
  else if(animationMode != 0) // Most animations follow a standard pattern
  {
    int sw = 15; if(animationMode == 5) sw = 140;
    int offset = 0; if(animationMode == 7) offset = 70;
    int lighter = 0, darker = 0;
    String textDisplay = "";
    strokeWeight(sw);
    int yF = targetY * 100 + 50; if(playerTurn == 2) yF = targetY * -100 + 750;
    
    switch(animationMode) 
    {
      case 2:
        lighter = 0xff1D87CB; darker = 0xff74C8FF; textDisplay = "Heal"; break;
      case 3:
        lighter = 0xff5DF247; darker = 0xff86FF74; textDisplay = "Effected"; break;  
      case 4:
        lighter = 0xffA21DCB; darker = 0xffB91AEA; break;  
      case 5:
        lighter = 255; darker = 190; break;  
      case 6:
        lighter = 50; darker = 0; textDisplay = "Discard"; break;  
      case 7:
        lighter = 0xff5DF247; darker = 0xff86FF74; textDisplay = targetName; break;  
      case 10:
        lighter = 0xffFF0A85; darker = 0xff810945; textDisplay = "Special"; break;  
    }
    fill(lighter, transparency);
    stroke(darker, transparency);
    ellipse(targetX * 100 + 50, yF, 220, 220);
    
    textSize(60);
    fill(170, transparency + offset - 40);
    text(textDisplay, targetX * 100 + 50 + 3, yF + 3);
    
    fill(darker, transparency + offset);
    text(textDisplay, targetX * 100 + 50, yF);
    
    if(animationMode == 4)
    {
      yF = selfY * 100 + 50; if(playerTurn == 2) yF = selfY * -100 + 750;
      ellipse(selfX * 100 + 50, yF, 220, 220);
    }
    if(transparency <= -offset)
      inAnimation = false;
  }
}
