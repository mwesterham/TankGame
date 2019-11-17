import java.util.LinkedList;
class TankController
{
  private LinkedList<EnemyTank> enemies = new LinkedList<EnemyTank>();
  EnemyTank TempEnemyTank;
  EnemyAI AI;
  private int num_of_standard_enemies;
  private int num_of_slow_strong_enemies;
  
  public TankController(int num_of_standard_enemies, int num_of_slow_strong_enemies)
  {
    Random rand = new Random();
    this.num_of_standard_enemies = num_of_standard_enemies;
    for(int i = 0; i < this.num_of_standard_enemies; i++)
    {
      addStandardEnemy(rand.nextInt(1900), rand.nextInt(900));
    }
    
    this.num_of_slow_strong_enemies = num_of_slow_strong_enemies;
    for(int i = 0; i < this.num_of_slow_strong_enemies; i++)
    {
      addSlowStrongEnemy(rand.nextInt(1900), rand.nextInt(900));
    }
  }
  
  public void update()
  {
    for(int i = 0; i < enemies.size(); i++)
    {
      TempEnemyTank = enemies.get(i);
      AI = new EnemyAI(TempEnemyTank); //applies AI to the tank in the enemies list
      AI.shootCheck(); //checks if should shoot
      TempEnemyTank.update();
      if(AI.canShoot() && tickCount % TempEnemyTank.getBulletFrequency() == 0)
        TempEnemyTank.shoot();
      if(TempEnemyTank.tank_health <= 0)
        removeEnemy(TempEnemyTank);
    }
    
    for(int i = 0; i < enemies.size(); i++)
    {
      TempEnemyTank = enemies.get(i);
      TempEnemyTank.renderTank();
    }
  }
  
  public void addStandardEnemy(float spawnX, float spawnY)
  {
    TempEnemyTank = new EnemyTank(
    /*tank_width*/75, 
    /*tank_height*/75, 
    /*tank_speed*/1, 
    /*tank_health*/3,
    /*bullet_size*/20, 
    /*bullet_speed*/4, 
    /*bullet_health/pentration/damage*/.8,
    /*bullet frequency measured in ticks per shot*/ 64,
    /*number of times bullets bounce*/1,
    /*spawn_x*/spawnX, 
    /*spawn_y*/spawnY, 
    /*target_location_x*/myTank.getPosition().x, 
    /*target_location_y*/myTank.getPosition().y,
    /*Tank Color         r/g/b*/0, 255, 123,
    /*Turret Color       r/g/b*/0, 0, 0,
    /*Tank Outline Color r/g/b*/0, 255, 123);
    
    enemies.add(TempEnemyTank);
  }
  
  public void addSlowStrongEnemy(float spawnX, float spawnY)
  {
    TempEnemyTank = new EnemyTank(
    /*tank_width*/100, 
    /*tank_height*/100, 
    /*tank_speed*/.5, 
    /*tank_health*/5,
    /*bullet_size*/40, 
    /*bullet_speed*/2, 
    /*bullet_health/pentration/damage*/3,
    /*bullet frequency measured in ticks per shot*/ 100,
    /*number of times bullets bounce*/1,
    /*spawn_x*/spawnX, 
    /*spawn_y*/spawnY, 
    /*target_location_x*/myTank.getPosition().x, 
    /*target_location_y*/myTank.getPosition().y,
    /*Tank Color         r/g/b*/255, 255, 255,
    /*Turret Color       r/g/b*/240, 90, 0,
    /*Tank Outline Color r/g/b*/255, 255, 255);
    
    enemies.add(TempEnemyTank);
  }
  
  public void addEnemy(EnemyTank enemyTank)
  {
    enemies.add(enemyTank);
  }
  
  public void removeEnemy(EnemyTank enemyTank)
  {
    enemies.remove(enemyTank);
  }
  
  public LinkedList<EnemyTank> getEList()
  {
    return enemies;
  }
  
  public void resetEnemies()
  {
    enemies = new LinkedList<EnemyTank>();
  }
}
