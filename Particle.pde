float MAX_MAG = 10;

int OLD_WEIGHT = 10;
int DIV_MOD = 1;

float GRAVITY = 0;

class Particle
{
  PVector pos, lastPos, vel;
  float partCol;
  float w;
  float a;

  public Particle(PVector pos)
  {
    this.pos = pos;
    this.lastPos = pos;
    vel = new PVector(0, 0);
    partCol = random(1.0f);
    print(partCol + "\n");
    w = random(10);
    if (random(100) == 34) w += random(15);
    a = 1;//random(10);
  }
  
  public Particle()
  {
    this(new PVector(0, 0));
    randTP();
  }

  void show()
  {
    strokeWeight(w);
    stroke(partCol * 255, 255, (1 - partCol) * 255, a);
    line(lastPos.x, lastPos.y, pos.x, pos.y);
  }

  void update()
  {
    lastPos = new PVector(pos.x, pos.y);
    if (pos.x < 0)           { dead.add(this); }
    else if (pos.x > width)  { dead.add(this); }
    if (pos.y < 0)           { dead.add(this); }
    else if (pos.y > height) { dead.add(this); }
    //if (Math.random() < 0.001) { randTP(); }

    int fx = (int)(pos.x / CELL_SIZE);
    int fy = (int)(pos.y / CELL_SIZE);

    try
    {
      PVector fv = field[fx][fy];
      vel = new PVector(vel.x + fv.x, vel.y + fv.y + GRAVITY);
      vel.setMag(vel.mag());
      if (vel.mag() > MAX_MAG) vel.setMag(MAX_MAG);

      PVector nfv = new PVector(fv.x, fv.y);
      nfv.mult(OLD_WEIGHT);
      nfv.add(vel);
      nfv.div(OLD_WEIGHT + DIV_MOD);
      if (nfv.mag() > MAX_FIELD_MAG) nfv.setMag(MAX_FIELD_MAG);

      field[fx][fy] = nfv;
    }
    catch (Exception e)
    {
    }


    pos.add(vel);
  }
  
  void randTP()
  {
     pos.x = lastPos.x = (float) Math.random() * width;
     pos.y = lastPos.y = (float) Math.random() * height;
     vel.setMag(0);
  }
}