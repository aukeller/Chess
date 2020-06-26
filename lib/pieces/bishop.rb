require_relative 'piece'
require_relative 'tile'
require_relative 'obstruction.rb'

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

end