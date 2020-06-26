class Piece
  attr_accessor :color, :rank, :file
  def initialize(color, rank, file)
    @color = color
    @rank = rank
    @file = file
  end

  def valid_move(new_rank, new_file, grid)
    return false if grid[new_rank][new_file].color == color
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
  end

end