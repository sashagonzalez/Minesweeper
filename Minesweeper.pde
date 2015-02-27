
import de.bezier.guido.*;
private int NUM_ROWS = 20; 
private int NUM_COLS = 20;
 int NUM_BOMBS= 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup()
{
  size(400, 440);
  background(0);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );


  buttons=new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      buttons[r][c]=new MSButton(r, c);
    }
  }
  setBombs();
}
public void setBombs()
{
  for (int i=0; i<NUM_BOMBS; i++)
  {
    int x=(int)(Math.random()*20);
    int y=(int)(Math.random()*20);
    if (bombs.contains(buttons[x][y])==false)
    {
      bombs.add(buttons[x][y]);
    } else {
      i--;
    }
  }
}

public void unSetBombs()
{
    for (int r=0; r<NUM_ROWS; r++)
    {
      for (int c=0; c<NUM_COLS; c++)
      {
        if (bombs.contains(buttons[r][c]))
        {
          bombs.remove(buttons[r][c]);
        }
      }
    }
}

public void draw ()
{
 /* if(keyPressed && key=='e')
    {NUM_BOMBS=50;
     setBombs();}
  else if (keyPressed && key=='m')
    {NUM_BOMBS=100;
     setBombs();}
 else if (keyPressed && key=='h')
    {NUM_BOMBS=250;
     setBombs(); } */
  if (isWon())
  {
    displayWinningMessage();
  }
  if (keyPressed && key=='r')
    {
     unSetBombs();
     setBombs();
     for (int r=0; r<NUM_ROWS; r++)
      {  
         for (int c=0; c<NUM_COLS; c++)
         {
           background(0);
           buttons[r][c].clicked=false;
           buttons[r][c].marked=false;
           buttons[r][c].setLabel("");
         }
      }   
    }
}
public boolean isWon()
{
  int bombsMarked=0;
    for (int r=0; r<NUM_ROWS; r++)
    {
      for (int c=0; c<NUM_COLS; c++)
      {
        if (bombs.contains(buttons[r][c]) && buttons[r][c].isMarked()==true)
        {
          bombsMarked++;
        }
      }
    }
    if (bombsMarked==NUM_BOMBS)
    {
      return true;
    }
    return false;
  }
  

public void displayLosingMessage()
{
    fill(255);
    text("you lose, press r to restart", 200, 420);
  for (int r=0; r<NUM_ROWS; r++)
  {
    for (int c=0; c<NUM_COLS; c++)
    {
      if (bombs.contains(buttons[r][c]) && buttons[r][c].clicked==false )
      {
        buttons[r][c].clicked=true;
      }
    }
  }
}
public void displayWinningMessage()
{ fill(255);
  text("great job,you win! Press r to restart",200,420);
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    clicked = true;
    if (keyPressed)
    {
      marked=!marked;
    } else if (bombs.contains(this))
    {
      displayLosingMessage();
    } else if (countBombs(r, c)>0)
    {
      setLabel(""+countBombs(r, c));
    } else if (countBombs(r, c)==0)
    { 
      for (int r1=-1; r1<=1; r1++)
      {
        for (int c1=-1; c1<=1; c1++)
        {
          if (isValid(r+r1, c+c1)&& (buttons[r+r1][c+c1]!=this)&& (buttons[r+r1][c+c1].isClicked()!=true))
          {
            buttons[r+r1][c+c1].mousePressed();
          }
        }
      }
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r3, int c3)
  {
    if ((r3>=0&&r3<20) && (c3>=0&&c3<20))
    {
      return true;
    } else
    {
      return false;
    }
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int r1=-1; r1<=1; r1++)
    {
      for (int c1=-1; c1<=1; c1++)
      {
        if (isValid(row+r1, col+c1)&&bombs.contains(buttons[row+r1][col+c1]))
          numBombs++;
      }
    }

    return numBombs;
  }
}



