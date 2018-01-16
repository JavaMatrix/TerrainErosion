/*
 * Terrain Erosion - Nathanael Page
 * Created sometime in 2015, last updated 01/16/18.
 * Simulates a sort of "terrain" generated by random or perlin noise, 
 * then allows "water" particles to flow on and affect the direction
 * and magnitude of force produced by the "terrain".
 *
 * Originally based on "Coding Challenge #24: Perlin Noise Flow Field" (The Coding Train, https://www.youtube.com/watch?v=BjoM9oKOAKY),
 * however, the current code deviates pretty far from that example.
 *
 * Look for the "[v]" marking for variables and code that you can change for different visual results.
 * Look for the "[q]" marking for variables that you can change to affect the "quality" of the visual results, but use care as these 
 *  can cause performance issues.
 */

// The terrain is modeled as a 2D vector field of fixed size.
PVector field[][];

// Particles are kept in a single list in order to easily operate on them all simultaneously.
ArrayList<Particle> particles = new ArrayList<Particle>();
// Dead particles sit in this list between being declared dead (usually by themselves) and being removed
// from 'particles'. This is done to avoid concurrent modification.
ArrayList<Particle> dead = new ArrayList<Particle>();

// [q] Terrain is arranged in a "grid" made of square "cells". This variable decides the size of those "cells".
// Both width and height should be a multiple of this value, or things might get wacky.
final int CELL_SIZE = 10;
// These variables store the number of "cells" in the grid.
int COLS;
int ROWS;

// [v] The maximum possible magnitude of the terrain vectors.
float MAX_FIELD_MAG = 5;

// [v] The scale of the perlin noise. Higher number create more, smaller "hills".
float SPACE_SPEED = .07;

// [v] Noise mode determines what kind of terrain will be generated. 
// Noise Mode 0: PRNG (very random) terrain.
// Noise Mode 1: Perlin (somewhat smooth) terrain.
int NOISE_MODE = 0;

/**
 * The setup method sets up the variables and terrain for the simulation.
 */
void setup()
{
  // [q] Set the size of the window. Make sure that both width and height are multiples of CELL_SIZE,
  // or things may get strange.
  size(1920, 1080);
  
  // Calculate the number of columns and rows and create an empty vector field.
  COLS = width / CELL_SIZE;
  ROWS = height / CELL_SIZE;
  field = new PVector[COLS][ROWS];
  
  // Fill in the terrain vector field with randomized vectors.
  for (int i = 0; i < COLS; i++)
  {
     for (int j = 0; j < ROWS; j++)
     {
       float vx, vy;
       if (NOISE_MODE == 0)
       {
         vx = random(-0.5, 0.5);
         vy = random(-0.5, 0.5);
       vx = noise(i * SPACE_SPEED, j * SPACE_SPEED) - 0.5;
       vy = noise((COLS + i) * SPACE_SPEED, (COLS + j) * SPACE_SPEED) - 0.5;
       field[i][j] = new PVector(vx, vy);
       field[i][j].setMag(MAX_FIELD_MAG * (float) random(1.0f));
     }
  }
  
  //for (int i = 0; i < 1000; i++)
  //{
  //  particles.add(new Particle(new PVector((float) random(1.0f) * width, (float) random(1.0f) * height)));
  //}
  
  background(0);
}

void draw()
{
  
  //background(0);
  //for (int i = 0; i < COLS; i++)
  //{
  // for (int j = 0; j < ROWS; j++)
  // {
  //   PVector vector = field[i][j];
  //   float linew = (CELL_SIZE / 2) * cos(vector.heading()) * (vector.mag() / MAX_FIELD_MAG);
  //   float lineh = (CELL_SIZE / 2) * sin(vector.heading()) * (vector.mag() / MAX_FIELD_MAG);
  //   float startX = (i - 1/2) * CELL_SIZE;
  //   float startY = (j - 1/2) * CELL_SIZE;
     
  //   strokeWeight(CELL_SIZE / 4);
  //   stroke(255);
  //   line (startX, startY, startX + linew, startY + lineh);
  //   stroke(255, 0, 0);
  //   point(startX + linew, startY + lineh);
  // }
  //}
  
  for (Particle x : dead)
  {
    particles.remove(x); 
  }
  dead.clear();
  
  for (Particle x : particles)
  {
     x.show();
     x.update();
  }
  
  if (mousePressed)
  {
    for (int i = 0; i < 1; i++) {
      PVector offsetVector = PVector.fromAngle(random(2 * PI));
      offsetVector.setMag(random(50));
      particles.add(new Particle(new PVector(mouseX + offsetVector.x, mouseY + offsetVector.y)));
      if (particles.size() > 1000)
        particles.remove(0);
    }
  }
  
  fill(255,255,255, 1);
  noStroke();
  //rect(0, 0, width, height);
  
  //if (particles.size() < 900)
  //{
  //  particles.clear();
  //   for (int x = 0; x < width; x += width / 32)
  //   {
  //     for (int y = 0; y < height; y += height / 32)
  //     {
  //       particles.add(new Particle(new PVector(x + random(width/32.), y + random(height/32.))));
  //     }
  //   }
  //}
  
  surface.setTitle("Particles: " + particles.size() + "      FPS: " + frameRate);
}

void keyPressed() {
  if (key == 'q')
  {
    for (int i = 0; i < 10; i++)
    {
      if (particles.size() > 0)
        particles.remove(0);
    }
  }
  else if (key == 'w')
  {
   particles.clear();
   background(0);
  }
  else if (key == 'f')
  {
     particles.clear();
     for (int x = 0; x < width; x += width / 32)
     {
       for (int y = 0; y < height; y += height / 32)
       {
         particles.add(new Particle(new PVector(x + random(width/32.), y + random(height/32.))));
       }
     }
  }
}