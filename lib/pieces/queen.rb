require_relative "piece"
require_relative 'obstruction.rb'

class Queen < Piece
  attr_accessor :symbol
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♕' : @symbol = '♛'
  end  

  def valid_move(new_rank, new_file, grid)
    return super
    if (new_file == file || new_rank == rank) && !rook_obstruction(new_rank, new_file, grid) 
      return true
    elsif (new_file - file).abs == (new_rank - rank).abs && !bishop_obstruction(new_rank, new_file, grid)
      return true
    else
      return false
    end
  end

end