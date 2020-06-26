require_relative 'piece'
require_relative 'tile'

class Bishop < Piece
  attr_accessor :symbol
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♗' : @symbol = '♝'
  end 
  
  def valid_move(new_rank, new_file, grid)
    return super
    if !bishop_obstruction(new_rank, new_file, grid)
      (new_file - file).abs == (new_rank - rank).abs ? true : false
    else
      return false 
    end 
  end

  def bishop_obstruction(new_rank, new_file, grid)
    i = 1
    dir_x, dir_y = new_file > file ? 1 : -1, new_rank > rank ? 1 : -1
    while i < (new_rank - rank).abs 
      if !grid[rank + (i * dir_y)][file + (i * dir_x)].class != Tile
        return true 
      end
      i += 1
    end
  end

end