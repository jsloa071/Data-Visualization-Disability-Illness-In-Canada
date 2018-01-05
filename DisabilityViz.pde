/*   Module 6.16 : Make your Own Visualization
     Question 1      */

//variable names for font and filename
final String filename = "diagnosisdata.csv";
PFont Georgia; 

//class for illnesses
class Illness
{
  //attributes store the 2016 value for total number of claims by illness
  String name;
  int total;
  //for visualization
  //note: mouseover is determined by unique blue value for each data point's drawing
  float arcStart;
  float arcPercent;
  float arcStop;
  int b; //stores blue value 
  boolean touch; //whether mouseover or not
  boolean omit; //for omitting datapoints that are too small
}
Illness[] illnesses;

void setup()
{
  size(800,800);
  background(190);
  textAlign(CENTER,CENTER);
  Georgia = createFont("Georgia",16);
  textFont(Georgia);
  
  readData();
}

void draw()
{
  textSize(24);
  text("Disability claims by illness (2017)", width/2, 80);
  drawData(illnesses);
  drawLabel(illnesses);
}

void readData()
{
  String[] lines = loadStrings(filename);
  //discard the first 99 lines, as we only want 2016 data
  illnesses = new Illness[lines.length-99];
  //calculate total from last line
  int total = Integer.parseInt(lines[lines.length-1].split(",")[11]);
  int counter = 0;
  for (int i = 99; i<lines.length; i++)
  {
    //for each row, store the name of illness and total claimants
    //also assign a unique b value and calculate arc start and stop values
    String[] splitLine = lines[i].split(",");
    illnesses[counter] = new Illness();
    illnesses[counter].name = splitLine[1];
    illnesses[counter].total = Integer.parseInt(splitLine[11]);
    illnesses[counter].b = 200+counter;
    if (counter==0)
    {
      illnesses[counter].arcStart = radians(0);
    }
    else
    {
      illnesses[counter].arcStart = illnesses[counter-1].arcStop;
    }
    illnesses[counter].arcPercent = (float)illnesses[counter].total / total;
    illnesses[counter].arcStop = (illnesses[counter].arcStart + radians(illnesses[counter].arcPercent*360));
    counter++; 
  }
}

void drawData(Illness[] array)
{
  stroke(255);
  strokeWeight(3);
  //for each data point, draw an arc from the center
  for (int i=0; i<array.length-1; i++)
  {
    //green value change on mouseover
    int green = 216;
    if (blue(get(mouseX,mouseY)) == array[i].b)
    {
      array[i].touch = true;
      green = 1;
    }
    else 
    {
      array[i].touch = false;
      green = 216;
    }
    //draw arc
    fill(35,green,array[i].b);  
    arc(width/2, height/2, 
        width*7/10, height*7/10, 
        array[i].arcStart, array[i].arcStop, PIE);
    }
}

void drawLabel(Illness[] illness)
{  
  //draw white center in circle
  fill(255);
  ellipse(width/2, height/2, width/4, height/4);
  //draw data label (including name and percent)
  textSize(18);
  for (int i=0; i<illness.length; i++)
  {
    //display label if touching the data point's arc by changing text color
    if (illness[i].touch == true)
    {
      fill(1);
    }
    else
    {
      fill(255,0);
    }
    text(illness[i].name+": "+round(illness[i].arcPercent*100)+"%", width/2-width/10, height/2-height/8,width/5,height/4);
  }
}
