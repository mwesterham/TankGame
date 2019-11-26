class EnemyTank
{
  private PVector location;
  boolean orientation_updown = false;
  boolean orientation_leftright = true;
  boolean orientation_upright = false;
  boolean orientation_upleft = false;
  
  private PVector velocity;
  private float tank_speed;
  
  private float original_tank_health;
  private float tank_health;
  private float tank_width;
  private float tank_height;
  private float turret_cir_width;
  private float turret_cir_height;
  private float turret_rec_width;
  private float turret_rec_height;
  private int[] tank_color = {0, 0, 0};
  private int[] tank_outline_color_body = {0, 0, 0};
  private int body_stroke_weight;
  private int[] turret_color = {0, 0, 0};
  private int[] tank_outline_color_turret = {0, 0, 0};
  private int turret_stroke_weight;
  
  private float right_collision_dist;
  private float left_collision_dist;
  private float above_collision_dist;
  private float below_collision_dist;
  
  private float bullet_size;
  private float bullet_speed;
  private float bullet_health;
  private int bullet_frequency;
  private int num_bullet_bounce;
  private float bullet_spawn_from_length = 0;
  private boolean player_shot_collision_with_body_allowed = true; 
  private boolean enemy_shot_collision_with_body_allowed = false; 
  private boolean player_bullet_collide_allowed = true; 
  private boolean enemy_bullet_collide_allowed = false;
  private boolean collision_bullet_with_wall_allowed = true;
  private boolean collision_body_with_wall_allowed = true;
  
  private PVector aimLocation;
  private int AI_version = 1;
  private int local_tick_count = 0;
  
  public EnemyTank(
  float tank_width, 
  float tank_height, 
  float tank_speed, 
  float tank_health,
  float bullet_size, 
  float bullet_speed, 
  float bullet_health, 
  int bullet_frequency, 
  int num_bullet_bounce, 
  float spawnX, float spawnY, 
  float aim_x, float aim_y,
  int tank_color_red, int tank_color_green, int tank_color_blue,
  int body_outline_red, int body_outline_green, int body_outline_blue,
  int body_stroke_weight,
  int turret_color_red, int turret_color_green, int turret_color_blue,
  int turret_outline_red, int turret_outline_green, int turret_outline_blue,
  int turret_stroke_weight)
  {
    location = new PVector(spawnX, spawnY);
    this.tank_width = tank_width;
    this.tank_height = tank_height;
    this.original_tank_health = tank_health;
    this.tank_health = tank_health;
    this.bullet_health = bullet_health;
    this.num_bullet_bounce = num_bullet_bounce;
      Random rand = new Random();
      velocity = new PVector(rand.nextInt(), rand.nextInt());
      velocity.normalize();
    this.tank_speed = tank_speed;
    
    this.turret_cir_width = tank_width * 1/3;
    this.turret_cir_height = tank_height * 1/3;
    this.turret_rec_width = tank_width * 2/5 ;
    this.turret_rec_height = tank_height * 1/3;
    this.right_collision_dist = tank_width * sqrt(2) / 4; //distance from middle of tank to the right 
    this.left_collision_dist = tank_width * sqrt(2) / 4; //distance from middle of tank to the left
    this.above_collision_dist = tank_width * sqrt(2) / 4; //distance from middle of tank to above
    this.below_collision_dist = tank_width * sqrt(2) / 4; //distance from middle of tank to below
    this.bullet_size = bullet_size;
    this.bullet_speed = bullet_speed;
    this.bullet_frequency = bullet_frequency;
    
      aimLocation = new PVector(aim_x, aim_y);
    
    this.tank_color[0] = tank_color_red;
    this.tank_color[1] = tank_color_green;
    this.tank_color[2] = tank_color_blue;
    this.tank_outline_color_body[0] = body_outline_red;
    this.tank_outline_color_body[1] = body_outline_green;
    this.tank_outline_color_body[2] = body_outline_blue;
    this.body_stroke_weight = body_stroke_weight;
    
    this.turret_color[0] = turret_color_red;
    this.turret_color[1] = turret_color_green;
    this.turret_color[2] = turret_color_blue;
    this.tank_outline_color_turret[0] = turret_outline_red;
    this.tank_outline_color_turret[1] = turret_outline_green;
    this.tank_outline_color_turret[2] = turret_outline_blue;
    this.turret_stroke_weight = turret_stroke_weight;
  }
  
  public void update()
  {
    tickCount++;
    updatePosition();
    renderTank();
  }
  
  public void updatePosition()
  {
    location.add(velocity);
  }
  
  public void renderTank()
  {
    stroke(tank_outline_color_body[0], tank_outline_color_body[1], tank_outline_color_body[2]);
    //strokeWeight(5);
    renderBody();
    
    stroke(tank_outline_color_turret[0], tank_outline_color_turret[1], tank_outline_color_turret[2]);
    //strokeWeight(0);
    renderTurret();
    renderHealthBar();
  }
  
  private void renderBody()
  {
    //body rendering
    pushMatrix();
    translate(location.x, location.y);
    /*
    if ((move_up || move_down) && !move_left && !move_right)
    {
      orientation_updown = true;
      orientation_leftright = false;
      orientation_upright = false;
      orientation_upleft = false;
    }
    if ((move_left || move_right) && !move_up && !move_down)
    {
      orientation_updown = false;
      orientation_leftright = true;
      orientation_upright = false;
      orientation_upleft = false;
    }
        if (move_up && move_right || move_down && move_left)
    {
      orientation_updown = false;
      orientation_leftright = false;
      orientation_upright = true;
      orientation_upleft = false;
    }
    if (move_up && move_left || move_down && move_right)
    {
      orientation_updown = false;
      orientation_leftright = false;
      orientation_upright = false;
      orientation_upleft = true;
    }
    
    if(orientation_updown)
      rotate(atan2(1, 0));
    if(orientation_leftright)
      rotate(atan2(0, 1));
    if(orientation_upright)
      rotate(atan2(-1, 1));
    if(orientation_upleft)
      rotate(atan2(1, 1));
    */
    fill(tank_color[0], tank_color[1], tank_color[2]);
    stroke(tank_outline_color_body[0], tank_outline_color_body[1], tank_outline_color_body[2]);
    strokeWeight(body_stroke_weight);
    ellipse(0, 0, tank_width, tank_height);
    popMatrix();
  }
  
  private void renderTurret()
  {
    
    //turret rendering
    pushMatrix();
    translate(location.x, location.y);
    rotate(atan2(aimLocation.y - location.y, aimLocation.x - location.x));
    fill(turret_color[0], turret_color[1], turret_color[2]);
    stroke(tank_outline_color_turret[0], tank_outline_color_turret[1], tank_outline_color_turret[2]);
    strokeWeight(turret_stroke_weight);
    rect(0,0 - (turret_cir_height) * 1/2, turret_rec_width, turret_rec_height);
    ellipse(0, 0, turret_cir_width, turret_cir_height);
    popMatrix();
  }
  
  private void renderHealthBar()
  {
    pushMatrix();
    translate(location.x, location.y);
    stroke(0, 0, 0);
    fill(0, 0, 0);
    strokeWeight(5);
    rect( -(tank_width) * 1/2, -(tank_height) * 2/3, tank_width, 10);//renders the red bar first
    fill(0, 255, 0);
    stroke(0, 0, 0, 0); //4th parameter sets opacity at 0
    rect( -(tank_width) * 1/2, -(tank_height) * 2/3, tank_width * (tank_health / original_tank_health), 10);//renders the green bar and overlaps
    popMatrix();
  }
  
  public void shoot()
  {
    bulletController.addBullet(getBullet());
    //shot_sound.play();
  }
  
  public Bullet getBullet()
  {
    return new Bullet(
    /*Number of collisions*/ 0, 
    bullet_size, 
    bullet_speed, 
    bullet_health,
    /*number of times bullets bounce*/num_bullet_bounce,
    /*spawnpoint x*/ location.x, 
    /*spawnpoint y*/ location.y, 
    /*Direction of Bullet*/ getAimDirection(), 
    /*spawn distance from center of rotation*/ turret_rec_width + bullet_spawn_from_length, 
    /*player_shot_collision_with_body allowed*/ player_shot_collision_with_body_allowed, 
    /*enemy_shot_collision_with_body allowed*/ enemy_shot_collision_with_body_allowed, 
    /*player_bullet_collide allowed*/ player_bullet_collide_allowed, 
    /*enemy_bullet_collide allowed*/ enemy_bullet_collide_allowed, 
    /*collision_bullet_with_wall_allowed*/ collision_bullet_with_wall_allowed,
    /*Bullet color...*/ tank_color[0], tank_color[1], tank_color[2], 
    /*Bullet outline color...*/ tank_outline_color_body[0], tank_outline_color_body[1], tank_outline_color_body[2]);
  }  

  public void setNewVelocityDirection(PVector newVelocityDirection)
  {
    this.velocity.x = newVelocityDirection.x * tank_speed;
    this.velocity.y = newVelocityDirection.y * tank_speed;
  }
  
  public void setAIVersion(int AIVersion)
  {
    AI_version = AIVersion;
  }
  
  public void updateCollisionPermissions(boolean a, boolean b, boolean c, boolean d, boolean e, boolean f)
  {
    player_shot_collision_with_body_allowed = a;
    enemy_shot_collision_with_body_allowed = b;
    player_bullet_collide_allowed = c;
    enemy_bullet_collide_allowed = d;
    collision_bullet_with_wall_allowed = e;
    collision_body_with_wall_allowed = f;
  }
  
  public void setTurretSize(float tank_width, float tank_height)
  {
    this.turret_cir_width = tank_width * 1/3;
    this.turret_cir_height = tank_height * 1/3;
    this.turret_rec_width = tank_width * 2/5 ;
    this.turret_rec_height = tank_height * 1/3;
  }
  
  public void setBulletSpawnFromLength(int extra_distance)
  {
    bullet_spawn_from_length = extra_distance;
  }

  /*
  public void setTankColor(int red, int green, int blue)
  {
    this.tank_color[0] = red;
    this.tank_color[1] = green;
    this.tank_color[2] = blue;
  }
  */
  /*
  public void setTurretColor(int red, int green, int blue)
  {
    this.turret_color[0] = red;
    this.turret_color[1] = green;
    this.turret_color[2] = blue;
  }
  */
  
  public float getTowardMoveDirection()
  {
    return -atan2(myTank.location.x - location.x, myTank.location.y - location.y);
  }
  
  public float getAimDirection()
  {
    return -atan2(aimLocation.x - location.x, aimLocation.y - location.y);
  }
  

}
