class Bullet
{
  private float bullet_width;
  private float bullet_height;
  private int[] bullet_color = {0, 0, 0};
  private int[] bullet_outline_color = {0, 0, 0};
  
  private PVector location;
  private float turret_length;
  private PVector velocity;
  private float bullet_direction;
  
  private boolean player_collision_allowed;
  private boolean enemy_collision_allowed;
  private boolean player_bullet_collide_allowed;
  private boolean enemy_bullet_collide_allowed;
  
  private boolean right_wall_collision;
  private boolean left_wall_collision;
  private boolean above_wall_collision;
  private boolean below_wall_collision;
  private int number_of_collisions;
  
  public Bullet(int number_of_collisions, float size, float speed, float spawn_x, float spawn_y, float direction, float turret_length, boolean player_collision_allowed, boolean enemy_collision_allowed, boolean player_bullet_collide_allowed, boolean enemy_bullet_collide_allowed, int bullet_color_red, int bullet_color_green, int bullet_color_blue, int outline_color_red, int outline_color_green, int outline_color_blue)
  {
    this.bullet_width = size;
    this.bullet_height = size;
    this.bullet_color[0] = bullet_color_red;
    this.bullet_color[1] = bullet_color_green;
    this.bullet_color[2] = bullet_color_blue;
    this.bullet_outline_color[0] = outline_color_red;
    this.bullet_outline_color[1] = outline_color_green;
    this.bullet_outline_color[2] = outline_color_blue;
    
    velocity = new PVector(speed * sin(-direction), speed * cos(direction));
    location = new PVector(spawn_x, spawn_y);
    this.turret_length = turret_length;
    
    this.bullet_direction = direction;
    
    this.player_collision_allowed = player_collision_allowed;
    this.enemy_collision_allowed = enemy_collision_allowed;
    this.player_bullet_collide_allowed = player_bullet_collide_allowed;
    this.enemy_bullet_collide_allowed = enemy_bullet_collide_allowed;
    
    this.right_wall_collision = false;
    this.left_wall_collision = false;
    this.above_wall_collision = false;
    this.below_wall_collision = false;
    this.number_of_collisions = number_of_collisions;
  }
  
  public void renderBullet()
  {
    //bullet rendering
    fill(bullet_color[0], bullet_color[1], bullet_color[2]);
    stroke(bullet_outline_color[0], bullet_outline_color[1], bullet_outline_color[2]);
    ellipse(location.x + turret_length * sin(-bullet_direction), location.y + turret_length * cos(bullet_direction), bullet_width, bullet_height);
  }
  
  public void updatePosition()
  {
    location.add(velocity);
  }
  
  public void updateBulletDirectionPosition()
  {    
    velocity.sub(velocity); //makes the velocity zero so it can be deleted in the controller class
  }
  
  public void rightWallCollisionTrue()
  {
      right_wall_collision = true;
  }
   
  public boolean rightWallCollision()
  {
    return right_wall_collision;
  }
  
  public void rightWallCollisionFalse()
  {
      right_wall_collision = false;
  }
  
  public void leftWallCollisionTrue()
  {
      left_wall_collision = true;
  }
  
  public void leftWallCollisionFalse()
  {
      left_wall_collision = false;
  }
  
  public void aboveWallCollisionTrue()
  {
      above_wall_collision = true;
  }
  
  public void aboveWallCollisionFalse()
  {
      above_wall_collision = false;
  }
  
  public void belowWallCollisionTrue()
  {
      below_wall_collision = true;
  }
  
  public void belowWallCollisionFalse()
  {
      below_wall_collision = false;
  }
  
  public void addCollisionToCount()
  {
    number_of_collisions += 1;
  }
  
  public int getNumOfCollisions()
  {
    return number_of_collisions;
  }

  public PVector getPosition()
  {
    PVector realLocation = new PVector(location.x + turret_length * sin(-bullet_direction), location.y + turret_length * cos(bullet_direction));
    return realLocation;
  }
  
  public boolean playerCollision()
  {
    return player_collision_allowed;
  }

  public boolean enemyCollision()
  {
    return enemy_collision_allowed;
  }
  
  public boolean playerBulletCollision()
  {
    return player_bullet_collide_allowed;
  }
  
  public boolean enemyBulletCollision()
  {
    return enemy_bullet_collide_allowed;
  }
  
  public float getSize()
  {
    return bullet_width;
  }
  
  public PVector getVelocity()
  {
     return velocity;
  }
}