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
    return false if (new_rank - rank).abs > 2 || (new_file - file).abs > 1
    return false if file == 0 && new_file == 7 || file == 7 && new_file == 0
    return false if (new_rank < 0 || new_rank > 7) || (new_file < 0 || new_file > 7)
    rank_dist = (new_rank - rank).abs
    obstructed = pawn_obstruction(new_rank, new_file, grid)
    if color == "black" && new_rank < rank
      return true if capture_diag("black", grid, new_rank, new_file)
      if rank == 6 && !obstructed
        return false if new_rank == 4 && !grid[new_rank][new_file].color.nil?
        (rank_dist <= 2 || rank_dist <= 1) && new_file == file ? true : false
      elsif !obstructed
        rank_dist <= 1 && new_file == file ? true : false
      else
        return false
      end
    elsif color == "white" && new_rank > rank
      return false if (new_rank - rank).abs > 2 || (new_file - file).abs > 1
      return true if capture_diag("white", grid, new_rank, new_file)
      if rank == 1 && !obstructed 
        return false if new_rank == 3 && !grid[new_rank][new_file].color.nil?
        if (rank_dist <= 2 || rank_dist <= 1) && new_file == file
          return true
        else
          return false
        end 
      elsif !obstructed
        if rank_dist <= 1 && new_file == file 
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false 
    end
  end

  def capture_diag(color, grid, new_rank, new_file)
    if color == "white" && new_rank == rank + 1
      if new_file == file + 1 || new_file == file - 1
        return true if grid[new_rank][new_file].class != Tile && !grid[new_rank][new_file].nil?
      else
        return false
      end
    elsif color == "black" && new_rank == rank - 1
      if new_file == file + 1 || new_file == file - 1
        return true if grid[new_rank][new_file].class != Tile && !grid[new_rank][new_file].nil?
      else
        return false
      end
    else
      return false
    end
  end

  def pawn_obstruction(new_rank, new_file, grid)  
    i = 1
    next_rank = rank + i
  
    while i <= (new_rank - rank).abs 
      if rank < new_rank
        return true if grid[next_rank][file].color != nil 
      else
        return true if grid[rank - i][file].color != nil 
      end
      i += 1
    end
    return false
  end

end