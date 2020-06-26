require_relative 'piece'
require_relative 'tile'

class Pawn < Piece
  attr_accessor :symbol, :rank, :file, :color, :en_passant
  def initialize(color, rank, file)
    super(color, rank, file)
    color == "white" ? @symbol = '♙' : @symbol = '♟︎'
    @en_passant = false
  end
  
  def valid_move(new_rank, new_file, grid)
    return true if @en_passant
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    return false if grid[new_rank][new_file].color == color 
    
    rank_dist = (new_rank - rank).abs
    obstructed = pawn_obstruction(new_rank, new_file, grid)
    color == "white" ? start_rank = 1 : start_rank = 6
    color == "white" ? moves_forward = new_rank > rank : moves_forward = new_rank < rank

    if moves_forward
      return true if capture_diag(color, grid, new_rank, new_file)
      if start_rank && !obstructed
        return false if rank_dist == 2 && grid[new_rank][new_file].class != Tile
        (rank_dist <= 2 || rank_dist <= 1) && new_file == file ? true : false
      elsif !obstructed
        rank_dist <= 1 && new_file == file ? true : false
      else
        return false
      end
    else
      return false 
    end
  end

  def capture_diag(color, grid, new_rank, new_file)
    return false if file == 0 && new_file == 7 || file == 7 && new_file == 0
    color == "white" ? diag = new_rank == rank + 1 : diag = new_rank == rank - 1
    if diag
      if new_file == file + 1 || new_file == file - 1
        grid[new_rank][new_file].class != Tile ? true : false
      end
    else
      return false
    end
  end

  def pawn_obstruction(new_rank, new_file, grid)  
    i = 1
    rank < new_rank ? next_rank = rank + i : next_rank = rank - i 
    while i <= (new_rank - rank).abs 
      grid[next_rank][file].class != Tile ? true : false 
      i += 1
    end
    return false
  end

end