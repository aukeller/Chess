require_relative 'piece'
require_relative 'obstruction.rb'

class Rook < Piece
  attr_accessor :symbol
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♖' : @symbol = '♜'
  end
    
  def valid_move(new_rank, new_file, grid)
    return false if grid[new_rank][new_file].color == color 
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    if !rook_obstruction(new_rank, new_file, grid)
      return true if (new_file == file ||  new_rank == rank) 
      return false
    end
    return false
  end
end