module Rules
  def in_check(color, board)
    if board.find_attacker(color) != false
      return true
    else
      return false
    end
  end

  def capture_check_piece(color, board)
    attacker = board.find_attacker(color)
    return true if !attacker 
    board.grid.each do |row|
      row.each do |tile|
        if tile.class == Tile 
          next
        elsif tile.valid_move(attacker.rank, attacker.file, board.grid) 
          return true if pseudo_move_legal(color, tile, attacker, board)
        end
      end
    end
    return false
  end

  def pseudo_move_legal(color, tile,  new_tile, board)
    tile_rank, tile_file = tile.rank, tile.file
    new_tile_rank, new_tile_file = new_tile.rank, new_tile.file
    board.move(tile.rank, tile.file, new_tile.rank, new_tile.file)
    if in_check(color, board)  
      if tile.class != Pawn
        board.move(new_tile.rank, new_tile.file, tile_rank, tile_file)
        board.grid[new_tile_rank][new_tile_file] = new_tile
        return false
      else
        board.grid[tile_rank][tile_file] = tile
        board.grid[new_tile_rank][new_tile_file] = new_tile
        return false
      end
    else
      if tile.class != Pawn
        board.move(new_tile.rank, new_tile.file, tile_rank, tile_file)
        board.grid[new_tile_rank][new_tile_file] = new_tile
        return true
      else
        board.grid[tile_rank][tile_file] = tile
        board.grid[new_tile_rank][new_tile_file] = new_tile
        return true
      end
    end
  end

  def move_out_of_check(color, board)
    moves = [[1, 0], [-1, 0], [0, 1], [0, -1], 
    [1, -1], [1, 1], [-1, -1], [-1, 1]]
    7.times do |i|
      if king_move_legal(color, moves[i][0], moves[i][1], board)
        return true
      end
    end
    return false
  end

  def king_move_legal(color, new_rank_dist, new_file_dist, board)
    king = board.find_king(color)
    king_rank, king_file = king.rank, king.file
    new_rank, new_file = king.rank + new_rank_dist, king.file + new_file_dist
    return false if !king.valid_move(new_rank, new_file, board.grid)
    if !board.grid[new_rank][new_file].color.nil?
      return false if !pseudo_move_legal(color, king, board.grid[new_rank][new_file], board)
    else
      board.move(king.rank, king.file, new_rank, new_file)
      if in_check(color, board)
        board.move(new_rank, new_file, king_rank, king_file)
        return false
      else
        board.move(new_rank, new_file, king_rank, king_file)
        return true
      end
    end
  end

  def block_check(color, board)
    king = board.find_king(color)
    attacker = board.find_attacker(color)
    return true if !attacker
    return false if attacker.class != Queen && attacker.class != Bishop && attacker.class != Rook
    rank_difference, file_difference = (king.rank - attacker.rank).abs, (king.file - attacker.file).abs
    i = 1
    j = 1
    if king.rank == attacker.rank && file_difference >= 1
      king.file > attacker.file ? i = 1 : i = -1
      until king.file - i == attacker.file
        board.grid.each do |row|
          row.each do |tile|
            return true if tile.color == color && tile.class != King && tile.valid_move(king.rank, king.file - i, board.grid)
          end
        end
        i < 0 ? i -= 1 : i += 1
      end                  
    elsif king.file == attacker.file && rank_difference >= 1
      king.rank > attacker.rank ? i = 1 : i = -1
      until king.rank - i == attacker.rank
        board.grid.each do |row|
          row.each do |tile|
            return true if tile.color == color && tile.class != King && tile.valid_move(king.rank - i, king.file, board.grid)
          end
        end
        i < 0 ? i -= 1 : i += 1
      end    
    elsif rank_difference >= 1
      king.rank > attacker.rank ? i = 1 : i = -1
      king.file > attacker.file ? j = 1 : j = -1
      until king.rank - i == attacker.rank && king.file - j == attacker.file
        board.grid.each do |row|
          row.each do |tile|
            return true if tile.color == color && tile.class != King && tile.valid_move(king.rank - i, king.file - j, board.grid)
          end
        end
        i < 0 ? i -= 1 : i += 1
        j < 0 ? j -= 1 : j += 1
      end
    end
    return false
  end

  def checkmate(color, board)
    if in_check(color, board)
      if !block_check(color, board) && !move_out_of_check(color, board) && !capture_check_piece(color, board)
        puts "checkmate"
        board.display
        return true
      end
    elsif !block_check(color, board) && !move_out_of_check(color, board) && !capture_check_piece(color, board)
      puts "stalemate"
      board.display
      return true
    else 
      return false
    end
  end
end

