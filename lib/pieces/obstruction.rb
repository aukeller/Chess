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



