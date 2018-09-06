import java.util.*;
public static final int WHITE = 1;
public static final int BLACK = 2;
public static final int EMPTY = 0;

public class Gamestate
{
  Piece [][] board;
  Piece [] black;
  Piece [] white;
  Piece liftedPiece;
  Piece currentJump;
  boolean running;
  boolean liftedExists;
  int currentTurn;
  Gamestate()
  {
    currentTurn = BLACK;
    liftedExists = false;
    running = true;
    board = new Piece[8][8];
    black = new Piece[12];
    white = new Piece[12];
    newBoard();
    
  }
  public void newBoard()
  {
    for ( int row = 0; row < board.length; ++row )
    {
      for ( int col = 0; col < board.length; ++col )
      {
        board[row][col] = new Piece( row, col, EMPTY, false ); 
      }
    }
    for ( int row = 1; row < 4; ++row )       //    for ( int row = 1; row < 4; ++row )
    {
      for ( int col = 0; col < board.length/2; ++ col )  //board.length/2
      {
        board[row%2 + 2 * col ][row-1].team = WHITE;
      }
    }
    for ( int row = 6; row < 9; ++row ) //  for ( int row = 6; row < 9; ++row )
    {
      for ( int col = 0; col < board.length/2; ++ col )
      {
        board[row%2 + 2 * col ][row-1].team = BLACK;
      }
    }

  }
  public void aiTurn()
  {
     board = calculateMoves(WHITE, 8, board, null).parent;
     //delay(500);
     currentTurn = BLACK;
     //printBoard();
  }
  public void printWinner()
  {
    int num = checkWinner();
    if ( num == BLACK )
    {
      fill( 255 );
      text( "BLACK WINS", 350, 650 );
    }
    else if ( num == WHITE )
    {
      fill( 255 );
      text( "WHITE WINS", 350, 650 );
    }
  }
  public void printBoard( Piece[][] thisBoard)
  {
      for ( int row = 0; row < board.length; ++row )
      {
        for( int col = 0; col < board.length; ++col )
        {
          System.out.print(thisBoard[col][row].team );
        }
        System.out.println();
      }
      System.out.println("________");
  }
  public void showBoard()
  {
    for ( int row = 0; row < board.length; ++row )
    {
      for( int col = 0; col < board.length; ++col )
      {
        fill(50);
        rect(col * 50 + 200, row * 50 + 200, 50, 50);
        fill(255);
      }
      fill(255);
      text( row, row * 50 + 210, 185);
      text( row, 165, row * 50 + 240);
    }
    for ( int row = 0; row < board.length; ++row )
    {
      for( int col = 0; col < board.length; ++col )
      {
        if (board[col][row].team != EMPTY )
        {
          board[col][row].showPiece();
        }
      }
    }
  }
  public int checkWinner()
  {
    int blackCount = 0;
    int whiteCount = 0;
    for ( int row = 0; row < board.length; ++row )
    {
      for( int col = 0; col < board.length; ++col )
      {
        if( board[col][row].team == BLACK )
        {
          ++blackCount;
        }
        if ( board[col][row].team == WHITE )
        {
          ++whiteCount;
        }
        if ( blackCount > 0 && whiteCount > 0 )
        {
          return EMPTY;
        }
      }
    }
    return blackCount > whiteCount ? BLACK : WHITE;
  }
  public RankBoard calculateMoves( int futureTurn, int recur, Piece[][] origBoard, Piece aiJump)
  {
    RankBoard biggest = new RankBoard( origBoard, -1000, origBoard );
    if ( recur > 1)
    {
      int yChange = futureTurn == BLACK ? -1 : 1;
      for ( int row = 0; row < origBoard.length; ++row )
      {
        for( int col = 0; col < origBoard.length; ++col )
        {
          if ( origBoard[col][row].team == futureTurn )
          {                  
            Piece [][] newBoard;
            for ( int k = -1; k < 2; ++k )
            {
              Piece currentPiece = aiJump == null ? origBoard[col][row] : aiJump;
              k = k == 0 ? 1 : k;                      //skipping 0
              if ( origBoard[col][row].king )
              {
                newBoard = movePiece( currentPiece.x + k, currentPiece.y - yChange, currentPiece, -yChange, origBoard, true);
                if ( newBoard != null && aiJump == null)
                {
                  RankBoard passBoard = new RankBoard( newBoard, calculateMoves( futureTurn%2 + 1, recur - 1, newBoard, null).value, origBoard );
                  biggest = passBoard.value > biggest.value ? passBoard : biggest;                    
                }
                newBoard = movePiece( currentPiece.x + k*2, currentPiece.y - yChange * 2, currentPiece, - yChange, origBoard, true);
                promotion(currentPiece.x + k*2, currentPiece.y - yChange * 2, futureTurn, newBoard);
                if ( newBoard != null )
                {
                  Piece temp = newBoard[currentPiece.x + k * 2][ currentPiece.y - yChange * 2];
                  if ( checkPossibleSkip( currentPiece.x + k*2, currentPiece.y - yChange * 2, newBoard ) )
                  
                  {
                    newBoard = calculateMoves( futureTurn, recur, newBoard, temp ).myBoard;
                  }
                  RankBoard passBoard = new RankBoard( newBoard, calculateMoves( futureTurn%2 + 1, recur - 1, newBoard, temp).value, origBoard );
                  biggest = passBoard.value > biggest.value ? passBoard : biggest;
                }
              }
              
              newBoard = movePiece( currentPiece.x + k, currentPiece.y + yChange, currentPiece, yChange, origBoard, true);
              if ( newBoard != null && aiJump == null)
              {
                RankBoard passBoard = new RankBoard( newBoard, calculateMoves( futureTurn%2 + 1, recur - 1, newBoard, null).value, origBoard );
                biggest = passBoard.value > biggest.value ? passBoard : biggest;
              }
              newBoard = movePiece( currentPiece.x + k*2, currentPiece.y + yChange * 2, currentPiece, yChange, origBoard, true);
              if ( newBoard != null )
              {
                Piece temp = newBoard[currentPiece.x + k * 2][ currentPiece.y + yChange * 2];
                if ( checkPossibleSkip( currentPiece.x + k*2, currentPiece.y + yChange * 2, newBoard ) )
                {
                  newBoard = calculateMoves( futureTurn, recur, newBoard, temp ).myBoard;
                }
                RankBoard passBoard = new RankBoard( newBoard, calculateMoves( futureTurn%2 + 1, recur - 1, newBoard, temp).value, origBoard );
                biggest = passBoard.value > biggest.value ? passBoard : biggest;
              }
            }
          } 
        }
      }
    }
    return new RankBoard( biggest.myBoard, calculateScore( biggest.myBoard, futureTurn%2 + 1 ), biggest.myBoard);
  }
  
  public int calculateScore( Piece[][] origBoard, int futureTurn )
  {
    int sum = 200;
    for ( int row = 0; row < origBoard.length; ++row )
    {
      for( int col = 0; col < origBoard.length; ++col )
      {
        if ( origBoard[col][row].team == BLACK )
        {
          sum -= calcHelp(origBoard, col, row, BLACK);
        }
        if ( origBoard[col][row].team == WHITE )
        {
          sum += calcHelp(origBoard, col, row, WHITE);
        }
      }
    }
    return futureTurn == BLACK ? -sum : sum;
  }
  public int calcHelp( Piece[][]origBoard, int col, int row, int side )
  {
    int sum = 8;// = side == WHITE ? (int)(row*2) : (int)((7 - row) * 2);    
    if ( origBoard[col][row].king )
    {
      sum += 20;
    }
    if ( row == (side - 1) * 7 )
    {
      sum += 4;
    }
    if ( col < 6 && col >= 2 )
    {
      sum += 1;
    }
    return sum;
  }

  public Piece[][] movePiece( int xCord, int yCord, Piece current, int yChange, Piece [][] origBoard, boolean firstMove)
  {
    Piece[][]retBoard = cloneBoard(origBoard);
    boolean isValid = false;
    boolean checkPossible = allCheckSkip(retBoard, current.team );
    if ( inBounds( xCord, yCord ) && retBoard[xCord][yCord].team == EMPTY )
    {
      if ( !checkPossible && firstMove && yCord == current.y + yChange && (xCord == current.x+1 || xCord == current.x-1 ) ) //empty space move
      {
        isValid = true;
      }
      else if(  yCord == current.y + yChange * 2 && xCord == current.x+2 && retBoard[current.x+1][current.y+yChange].team == current.team%2 + 1 )       //skipping over right
      {
        isValid = true;
        retBoard[current.x+1][current.y+yChange].team = EMPTY;
      }
      else if ( yCord == current.y + yChange * 2 && xCord == current.x-2 && retBoard[current.x-1][current.y+yChange].team == current.team%2 + 1  )     //skipping over left
      {
        isValid = true;
        retBoard[current.x-1][current.y+yChange].team = EMPTY;
      }
      
      if ( isValid )
      {
        retBoard[xCord][yCord].team = current.team;
        retBoard[xCord][yCord].king = current.king;
        promotion(xCord, yCord, current.team, retBoard);
        retBoard[current.x][current.y].team = EMPTY;
        //printBoard(retBoard);
        return retBoard;
      }
    }
    return null;
  }
  
  public boolean allCheckSkip(Piece[][] currentBoard, int whosTurn)
  {
    for ( int row = 0; row < currentBoard.length; ++row )
    {
      for( int col = 0; col < currentBoard.length; ++col )
      {
        if ( currentBoard[col][row].team == whosTurn && checkPossibleSkip( col, row, currentBoard)  )
        {
          return true;
        }
      }
    }
    return false;
  }
  public boolean checkPossibleSkip( int currentX, int currentY, Piece[][] currentBoard )
  {
    Piece current = currentBoard[currentX][currentY];
    int currentTeam = current.team;
    int yChange = currentTeam == BLACK ? -1 : 1;
    for ( int k = -1; k < 2; ++k )
    {
      k = k == 0 ? 1 : k;                      //skipping 0
      //Piece [][] newBoard = movePiece( currentX + k * 2, currentY + yChange * 2, currentBoard[currentX][currentY], yChange, currentBoard, false);
      if ( inBounds( currentX + k * 2, currentY + yChange * 2 ) && currentBoard[currentX + k * 2][currentY + yChange * 2].team == EMPTY 
        && currentBoard[currentX+k][currentY+yChange].team == currentTeam%2 + 1 )
      {
          return true;
      }
      if ( inBounds( currentX + k * 2, currentY - yChange * 2 ) && current.king && 
        currentBoard[currentX + k * 2][currentY - yChange * 2].team == EMPTY && currentBoard[currentX+k][currentY-yChange].team == currentTeam%2 + 1 )
      {
          return true;
      }
    }
    return false;
  }  
  public boolean promotion( int xCord, int yCord, int whosTurn, Piece[][] origBoard )
  {
    if ( yCord == whosTurn%2 * 7)
    {
      origBoard[xCord][yCord].king = true;
      return true;
    }
    return false;
  }
  public boolean checkPickup( int mX, int mY)
  {
    int newX = (mX - 200)/50;
    int newY = (mY - 200)/50;
    if ( inBounds(newX, newY) && board[newX][newY].team == BLACK )
    {
      board[newX][newY].lifted = true;
      liftedPiece = board[newX][newY];
      return true;
    }
    return false;
  }
  public void checkDrop( int mX, int mY, boolean firstRun)
  {
    if ( firstRun )
    {
      currentJump = null;
    }
    int newX = (mX - 200)/50;
    int newY = (mY - 200)/50;
    if ( inBounds( newX, newY ) && ( currentJump == null ) || (currentJump.x == newX && currentJump.y == newY ))
    {
      boolean firstCheck = checkPossibleSkip( liftedPiece.x, liftedPiece.y, board );
      Piece[][] temp;
      temp = movePiece( newX, newY, liftedPiece, -1, board, true );
      board = temp == null ? board : temp;
      if ( liftedPiece.king )    //assuming only black can lift pieces
      {
          temp = movePiece( newX, newY, liftedPiece, 1, board, true );
      }
      if ( temp != null )  
      {
        board = temp;
        if ( !promotion(newX, newY, BLACK, board) && firstCheck && checkPossibleSkip( newX, newY, board )  )
        {
            currentJump = board[newX][newY];
        }
        else
        {
            currentTurn = currentTurn % 2 + 1;
        }
      }
    }
    liftedPiece.lifted = false;
    liftedExists = false;
  }
  public Piece [][] cloneBoard( Piece[][] origBoard )
  {
    Piece[][] newBoard = new Piece[origBoard.length][origBoard.length];
    for ( int i = 0; i < origBoard.length; ++i )
    {
      for ( int j = 0; j < origBoard.length; ++j )
      {
        newBoard[i][j] = origBoard[i][j].clone();
      }
    }
    return newBoard;
  }
  private boolean inBounds(int x, int y)
  {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }
  class RankBoard
  {
    Piece [][] parent;
    Piece [][] myBoard;
    int value;
    RankBoard( Piece[][] inputBoard, int val, Piece[][] parentBoard)
    {
      myBoard = inputBoard;
      value = val;
      parent = parentBoard;
    }
  }
}
