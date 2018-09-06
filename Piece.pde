public class Piece
{
  int x;
  int y;
  int team;
  boolean king;
  boolean lifted;
  Piece( int xCord, int yCord, int whichTeam, boolean k )
  {
    king = k;
    //king = true;
    lifted = false;
    team = whichTeam;
    x = xCord;
    y = yCord;
  }
  public void showPiece()
  {
    fill(team%2 * 255);
    if ( lifted )
    {
      ellipse( mouseX, mouseY, 50, 50);
      if ( king ) 
      {
          textSize(25);
          fill( (team + 1)%2 * 255);
          text( "K", mouseX - 5, mouseY + 10 );
      }
    }
    else 
    {
      ellipse( x * 50 + 225, y * 50 + 225, 50, 50);
      if ( king ) 
      {
          textSize(25);
          fill( (team + 1)%2 * 255);
          text( "K", x * 50 + 220, y * 50 + 235);
      }
    }
  }
  public boolean inBounds( int mX, int mY )
  {
    return mX > x * 50 + 200 && mX < x * 50 + 250 && mY > y * 50 + 200 && mY < y * 50 + 250;
  }
  public Piece clone()
  {
    return new Piece( x, y, team, king );
  }
}
