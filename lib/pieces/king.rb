require_relative 'queen'
require_relative 'obstruction.rb'

class King < Queen
  attr_accessor :symbol
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♔' 	: @symbol = '♚'
  end  

  def valid_move(new_rank, new_file, grid)
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    return false if grid[new_rank][new_file].color == color 
    if (new_file == file || new_rank == rank) && !rook_obstruction(new_rank, new_file, grid)
      (new_file - file).abs <= 1 && (new_rank - rank).abs <= 1 ? true : false
    elsif (new_file - file).abs == (new_rank - rank).abs && !bishop_obstruction(new_rank, new_file, grid)
      (new_file - file).abs <= 1 && (new_rank - rank).abs <= 1 ? true : false
    else
      return false
    end
  end 
   
end