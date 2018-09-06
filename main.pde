void settings()
{
  size(800,800);
}

Gamestate game;
void setup(){
  frameRate(40);
  background(0, 0, 50 );
  game = new Gamestate();
  
}

void draw()
{
  if ( game.running == true )
  {
    background(0, 0, 50 );
    if ( game.currentTurn == WHITE )
    {
        game.aiTurn();
    }
    fill( 200 );
    textSize(40);
    if ( game.currentTurn == 1 )
    {
        text( "White's turn", 50, 140 );
    }
    else
    {
        text( "Black's turn", 50, 140 );
    }
    game.showBoard();
    game.printWinner();
    //text( mouseX + "\n     " + mouseY, mouseX, mouseY );
  }
}

void mouseClicked()
{
  if ( game.running && !game.liftedExists && game.currentTurn == BLACK)
  {
    if ( game.checkPickup(mouseX, mouseY) )
    {
      game.liftedExists = true;
    }
  }
  else
  {
    game.checkDrop(mouseX, mouseY, true);
  }
}

public void keyPressed()
{  
   switch( keyCode )
   {
      //case 68:    //d
      //   game.runners[1].direction = RIGHT;
      //   break;
      //case 65:    //a
      //   game.runners[1].direction = LEFT;
      //   break;
      //case 83:    //s
      //   game.liftedExtis
         //break;
      //case 87:    //w
      //   game.runners[1].direction = UP;
      //   break;
      //case 38:    //up
      //   frameRate(150);
      //   break;
      //case 40:    //down
      //   frameRate(20);
      //   break;
   }
  
}
