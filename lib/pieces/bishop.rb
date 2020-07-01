require_relative 'piece'
require_relative 'obstruction'

class Bishop < Piece
  attr_accessor :symbol
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♗' : @symbol = '♝'
  end 
  
  def valid_move(new_rank, new_file, grid)
    return false if grid[new_rank][new_file].color == color 
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    if !bishop_obstruction(new_rank, new_file, grid)
      (new_file - file).abs == (new_rank - rank).abs ? true : false
    else
      return false  
    end
  end

end