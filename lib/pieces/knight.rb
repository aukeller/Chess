require_relative "piece"

class Knight < Piece
  attr_accessor :symbol, :move_set
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♘' : @symbol = '♞'
  end

  def valid_move(new_rank, new_file, grid)
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    return false if grid[new_rank][new_file].color == color
    delta1, delta2   = (new_file - file).abs, (new_rank - rank).abs
    (delta1 == 1 && delta2 == 2) || (delta1 == 2 && delta2 == 1) ? true : false
  end
end