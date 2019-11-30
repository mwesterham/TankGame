  /*Sound Stuff
  import processing.sound.*; //install the sound library from processing
  private String path;
  SoundFile background_music;
  SoundFile shot_sound;
  //*/
  
  private UI myUI;
  private boolean runGame = false;
  private boolean displayGameOver = false;
  private boolean displayUpgrades = false;
  private boolean displayYouWon = false;
  private boolean displayHome = true;
  private boolean displayLevelSelect = false;
  private boolean displayAbout = false;
  private boolean displayControls = false;
  
  private PlayerTank myTank;
  private boolean move_left = false;
  private boolean move_right = false;
  private boolean move_up = false;
  private boolean move_down = false;
  private boolean shoot_input = false;

  private World myWorld = new World(); //just declares the world name, nothing else
  private BulletController bulletController = new BulletController();
  private TankController enemyController = new TankController(); //set how many enemies spawn, they are randomly placed (standardEnemy, strongSlowEnemy) PS this is only used to instantiate
  
  private int[] background_color = {50, 50, 50};
  private boolean upgrades_on;
  private boolean keep_upgrades;
  public int tickCount = 0;
  private int framerate;
  private int FRAMERATE;
  
void setup() 
{
  /*Sound Stuff

  //Sound setup
  path = sketchPath("Audio Files/TankGameBoringMusic_Trebel.mp3"); 
  background_music = new SoundFile(this, path);
  background_music.amp(.2);
  
  path = sketchPath("Audio Files/Shot_Sound.mp3"); 
  shot_sound = new SoundFile(this, path); //in playertank and enemy tank shoot() methods, be sure to comment out if you do not have the library installed
  shot_sound.amp(1);
  
  background_music.loop();
  //*/

  //GAME SETUP
  //size(1900, 900); //for testing game breaking stuff
  fullScreen();
  framerate = 25; // how many frames the game thinks the game is running at, cannot go below 3 since (int)(80 / framerate) = 0)
  FRAMERATE = 30; //actual framerate of the game, base frame rate is 80 fps hence why everything is like 80 / framerate instead of  FRAMERATE / framerate
  frameRate(FRAMERATE); 
  //speed of the game is dependent on ratio between the two framerates: FRAMERATE / framerate = game speed
  //but make sure your FRAMERATE is within your cpu's capabilities (ie. do not run at FRAMERATE = 100)
 
  myUI = new UI(0); //instantiate it here so it can inherit the width and height
  
  myTank  = new PlayerTank(
  /*tank_width*/75, //typically 75
  /*tank_height*/68, 
  /*tank_health*/3 * (1 + .2 * (0)), //typically 3
  /*tank_speed*/2 * (1 + .1 * (0)), //typically 2
  /*bullet_size*/20 * (1 + .2 * (0)), //typically 20
  /*bullet_speed*/4 * (1 + .2 * (0)), //typically 4
  /*bullet_health/pentration/damage*/1 * (1 + .2 * (0)),//typically 1
  /*bullet_frequency*/40 - 2 * (0), //typically 40, cannot go below 3 since (int)(80 / framerate) = 0
  /*number of times bullets bounce*/1,
  /*spawn_x*/600, 
  /*spawn_y*/500,
  /*Tank Color           r/g/b*/8, 247, 254,
  /*Tank Outline Color   r/g/b*/0, 0, 0,
  /*Tank Stroke Weight*/5,
  /*Turret Color         r/g/b*/0, 0, 0,
  /*Turret Outline Color r/g/b*/0, 0, 0,
  /*Turret Stroke Weight*/3);
  
  myTank.updateCollisionPermissions(
  /*player_shot_collision_with_body allowed*/ false, 
  /*enemy_shot_collision_with_body allowed*/ true, 
  /*player_bullet_collide allowed*/ false, 
  /*enemy_bullet_collide allowed*/ true,
  /*collision_bullet_with_wall_allowed*/ true,
  /*collision_body_with_wall_allowed*/ true);
  
  //Only turn on if self-damage is on: //myTank.setBulletSpawnFromLength(14);//add or subtract extra distance from turret length
}  
  
void draw() 
{
  tickCount++;
  background(background_color[0], background_color[1], background_color[2]);
  if(!runGame)
  {
    //if(start_home_music)
    //  background_music.loop();
    //start_home_music = false;
    //System.out.println(myUI.trigger_text); //for testing the UI
    if(displayHome)//displays the screen indicated
      myUI.displayHome();
    if(displayAbout)
      myUI.displayAbout();
    if(displayControls)
      myUI.displayControls();
    if(displayLevelSelect)
      myUI.displayLevelSelect();
    if(displayGameOver)
      myUI.displayGameOver();
    if(displayUpgrades)
      myUI.displayUpgrades();
    if(displayYouWon)
      myUI.displayYouWon();

  }

  if(runGame)
  {  

    //if(!(myUI.trigger_int == -1) && !(myUI.trigger_int == 0)) //discludes random world and test grounds
    //  background_music.stop();
    
    upgrades_on = true;
    keep_upgrades = false;
    myUI.runGame();
    myUI.endGameCheck();//if player health reaches zero or num of enemies reach zero, resets the game
  }
}

void keyReleased()
{
  if(key == 'a' || key == 'A' || keyCode == LEFT)
    move_left = false;
  if (key == 'd' || key == 'D' || keyCode == RIGHT)
    move_right = false;
  if(key == 'w' || key == 'W' || keyCode == UP)
    move_up = false;
  if (key == 's' || key == 'S' || keyCode == DOWN)
    move_down = false;
}

void keyPressed()
{
  if(key == 'a' || key == 'A' || keyCode == LEFT)
    move_left = true;
  if (key == 'd' || key == 'D' || keyCode == RIGHT)
    move_right = true;
  if(key == 'w' || key == 'W' || keyCode == UP)
    move_up = true;
  if (key == 's' || key == 'S' || keyCode == DOWN)
    move_down = true;
  if (key == 'p' || key == 'P' && runGame)
    myTank.setTankHealthZero();
}


void mousePressed() 
{
  if(runGame)
    shoot_input = true;
  if(!runGame)
  {
    if(upgrades_on)
    {
      switch (myUI.upgrade_text)
      {
        case "Return to Home Page":
          if (upgrades_on && !keep_upgrades) 
          {
            myTank  = new PlayerTank(
            /*tank_width*/75, //typically 75
            /*tank_height*/68, 
            /*tank_health*/3, //typically 3
            /*tank_speed*/2, //typically 2
            /*bullet_size*/20, //typically 20
            /*bullet_speed*/4, //typically 4
            /*bullet_health/pentration/damage*/1,//typically 1
            /*bullet_frequency*/40, //typically 40, cannot go below 3 since (int)(80 / framerate) = 0
            /*number of times bullets bounce*/1,
            /*spawn_x*/600, 
            /*spawn_y*/500,
            /*Tank Color           r/g/b*/8, 247, 254,
            /*Tank Outline Color   r/g/b*/0, 0, 0,
            /*Tank Stroke Weight*/5,
            /*Turret Color         r/g/b*/0, 0, 0,
            /*Turret Outline Color r/g/b*/0, 0, 0,
            /*Turret Stroke Weight*/3);
            
            myTank.updateCollisionPermissions(
            /*player_shot_collision_with_body allowed*/ false, 
            /*enemy_shot_collision_with_body allowed*/ true, 
            /*player_bullet_collide allowed*/ false, 
            /*enemy_bullet_collide allowed*/ true,
            /*collision_bullet_with_wall_allowed*/ true,
            /*collision_body_with_wall_allowed*/ true);
            
            //Only turn on if self-damage is on: //myTank.setBulletSpawnFromLength(14);//add or subtract extra distance from turret length
          }
          break;
        case "No Upgrade":
          break;
        case "TankSpeed +10%":
          myTank.addTankSpeed(10); //increase 20 percent of original
          break;
        case "TankHealth +10%":
          myTank.addTankHealth(10); //increase 20 percent of original
          break;
        case "BulletSpeed +10%":
          myTank.addBulletSpeed(10); //increases 20 percent of original
          break;
        case "BulletDamage +10%":
          myTank.addBulletPenetration(10); //increases 20 percent of original
          break;
        case "BulletSize +10%":
          myTank.addBulletSize(10); //increases 10 percent of original
          break;
        case "BulletSize -10%":
          myTank.addBulletSize(-10); //decreases 10 percent of original
          break;
        case "BulletFrequency -2 tick/shot":
          myTank.increaseBulletFrequency(-2); //reduce by 2 tick, original 36, cannot go below 3
          break;
        case "BulletBounce +1 (-20% everything else)":
          myTank.addBulletBounce(1);
          myTank.addTankSpeed(-20); //decreases 40 percent of original
          myTank.addTankHealth(-20); //decreases 40 percent of original
          myTank.addBulletSpeed(-20); //decreases 40 percent of original
          myTank.addBulletPenetration(-20); //decreases 40 percent of original
          myTank.addBulletSize(-10); //decreases by 10 percent
          myTank.increaseBulletFrequency(4); //increases by 8 ticks per shot
          break;
      }
      if(myTank.bullet_frequency < 3) //minimum is 1
        myTank.bullet_frequency = 3;
    }
    
    
    //on click: sets everything to not displaying
    displayHome = false;
    displayAbout = false;
    displayControls = false;
    displayLevelSelect = false;
    displayGameOver = false;
    displayUpgrades = false;
    displayYouWon = false;
    runGame = false;
    
    switch (myUI.trigger_text)//navigates to a new screen using the click placement
    {
      case "Home Page":
        displayHome = true;
        break;
      case "Level Select":
        displayLevelSelect = true;
        break;
      case "About":
        displayAbout = true;
        break;
      case "Controls":
        displayControls = true;
        break;
      case "Game Over":
        displayGameOver = true;
        break;
      case "Upgrades":
        displayUpgrades = true;
        break;
      case "You Won":
        displayYouWon = true;
        break;
    }
    
    switch (myUI.trigger_int)//navigates to a new game using the click placement and int associated with it
    {
      case -2:
        myWorld.generateTestGrounds();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case -1:
        myWorld.generateRandomWorld(20, 0, 3, 2, 0, 0); //(num_of_walls, standstill, regular enemies, slowstrong, boss1, boss2)
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      //case 0:
        //myUI.setTriggerText("Home Page");
        //break;
      case 1:
        myWorld.generateLevel1();
        myUI = new UI(myUI.trigger_int + 1);//makes it so that the next button references the level ahead of it
        runGame = true;
        break;
      case 2:
        myWorld.generateLevel2();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 3:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 4:
        myWorld.generateLevel4();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 5:
        myWorld.generateLevel5();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 6:
        myWorld.generateLevel6();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 7:
        myWorld.generateLevel7();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 8:
        myWorld.generateLevel8();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 9:
        myWorld.generateLevel9();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 10:
        myWorld.generateLevel10();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 11:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 12:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 13:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 14:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 15:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 16:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 17:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 18:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 19:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 20:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 21:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 22:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 23:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 24:
        myWorld.generateLevel3();
        myUI = new UI(myUI.trigger_int + 1);
        runGame = true;
        break;
      case 25: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 26: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 27: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 28: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 29: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 30: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 31: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 32: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 33: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 34: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 35: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 36: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 37: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 38: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 39: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 40: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 41: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 42: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 43: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 44: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 45: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 46: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 47: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 48: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 49: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 50: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 51: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 52: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 53: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 54: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 55: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 56: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 57: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 58: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 59: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 60: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 61: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 62: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 63: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 64: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 65: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 66: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 67: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 68: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 69: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 70: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 71: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 72: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 73: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 74: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 75: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 76: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 77: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 78: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 79: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
      case 80: 
        myWorld.generateLevel3(); 
        myUI = new UI(myUI.trigger_int + 1); 
        runGame = true; 
        break; 
    }
  }
}

void mouseReleased() 
{
  shoot_input = false;
}

/*
mouseX
mouseY
pmouseX
pmouseY
mousePressed
mousePressed()
mouseReleased()
mouseMoved()
mouseDragged()
mouseButton
mouseWheel()
*/
