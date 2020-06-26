require_relative "tile"

def rook_obstruction(new_rank, new_file, grid)
  i = 1
  dir_x, dir_y = new_file > file ? 1 : -1, new_rank > rank ? 1 : -1
  if file == new_file
    while i < (new_rank - rank).abs
      if !grid[rank + (i * dir_y)][file].nil?
        return true if grid[rank + (i * dir_y)][file].color != nil
      end
      i += 1
    end
    return false
  else
    while i < (new_file - file).abs
      if !grid[rank][file + (i * dir_x)].nil?
        return true if grid[rank][file + (i * dir_x)].color != nil
      end
      i += 1
    end
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







