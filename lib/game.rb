require_relative 'board.rb'
require_relative 'rules.rb'
require 'yaml'

include Rules
def start
  print "enter 'load' to load game, otherwise enter 'y' to start: "
  if gets.chomp.downcase == 'load'
    board = load
  else
    board = Board.new
  end
  turn(board)
end

def convert(pos, new_pos)
  pair = []
  file, rank = pos.split(//)[0].ord - 97, pos.split(//)[1].to_i - 1
  new_file, new_rank = new_pos.split(//)[0].ord - 97, new_pos.split(//)[1].to_i - 1
  pair.push(rank, file, new_rank, new_file) 
  return pair
end

def get_move(color, board)
  puts "#{color}, what is your move?"
  pair = gets.chomp.split
  save(board) if pair.join == "save"
  if pair[0].class != String || pair[0].length != 2
    puts "not valid input"
    get_move(color)
  end
  pair = convert(pair[0], pair[1])
  if board.grid[pair[0]][pair[1]].color != color
    puts "It's #{color}'s turn!"
    get_move(color)
  else
    return pair
  end
end

def castle_attempt(color, piece, new_file, board)
  color == "white" ? king_rook_move = board.white_king_rook_move : king_rook_move = board.black_king_rook_move
  color == "white" ? rank = 0 : rank = 7
  if !king_rook_move && !in_check(color, board)
    if new_file == 2 && board.grid[rank][1].class == Tile && board.grid[rank][2].class == Tile && board.grid[rank][3].class == Tile
     king_move_legal(color, 0, -1, board) ? board.move(rank, 4, rank, 3) : (return false)
      if king_move_legal(color, 0, -1, board) 
        board.move(rank, 3, rank, 4)
        return true
      else
        board.move(rank, 3, rank, 4)
        return false
      end
    elsif new_file == 6 && board.grid[rank][5].class == Tile && board.grid[rank][6].class == Tile 
      king_move_legal(color, 0, 1, board) ? board.move(rank, 4, rank, 5) : (return false)
      if king_move_legal(color, 0, 1, board) 
        board.move(rank, 5, rank, 4)
        return true
      else
        board.move(rank, 5, rank, 4)
        return false
      end
    end
  else
    return false
  end
end

def castle(color, pair, board)
  i = 1
  color == "white" ? rank = 0 : rank = 7
  pair[3] > pair[1] ? i = 1 : i = -1
  board.move(pair[0], pair[1], pair[2], pair[3] - i)
  board.move(pair[0], pair[3] - i, pair[2], pair[3])
  if pair[3] > pair[1]
    board.grid[0][7], board.grid[0][5] = Tile.new, Rook.new(color, rank, 5)  
  else
    board.grid[0][0], board.grid[0][3] = Tile.new, Rook.new(color, rank, 3)
  end
end

def en_passant_attempt(piece, new_rank, new_file, board)
  piece.color == "black" ? pawn_move_two = board.white_pawn_move_two : pawn_move_two = board.black_pawn_move_two
  piece.color == "black" ? i = 1: i = -1
  return false if pawn_move_two.nil? 
    if pawn_move_two.rank == piece.rank && pawn_move_two.file == piece.file + 1 || pawn_move_two.rank == piece.rank && pawn_move_two.file == piece.file - 1
      return true if new_rank == piece.rank - i && new_file == pawn_move_two.file 
    end
  return false
end

def en_passant(piece, board)
  piece.en_passant = true
  i = 1
  piece.color == "white" ? pawn_move_two = board.black_pawn_move_two : pawn_move_two = board.white_pawn_move_two
  piece.color == "white" ? i = 1 : i = -1
  board.move(piece.rank, piece.file, pawn_move_two.rank + i, pawn_move_two.file)
  board.killed << board.grid[pawn_move_two.rank][pawn_move_two.file].symbol
  board.grid[pawn_move_two.rank][pawn_move_two.file] = Tile.new
end
    
def turn(board) 
  until checkmate("white", board) || checkmate("black", board)
    board.display
    board.white_turn == true ? color = "white" : color = "black"
    pair = get_move(color, board)
    piece = board.grid[pair[0]][pair[1]]
    if piece.class == Pawn && en_passant_attempt(piece, pair[2], pair[3], board)
      en_passant(piece, board)
      piece.en_passant = false
    elsif piece.class == King && castle_attempt(color, piece, pair[3], board)
      castle(color, pair, board)
    elsif !piece.valid_move(pair[2], pair[3], board.grid)
      puts "not a valid move"
      next
    else
      board.move(pair[0], pair[1], pair[2], pair[3])
      if in_check(color, board)
        board.grid[pair[0]][pair[1]] = board.grid[pair[2]][pair[3]]
        board.grid[pair[2]][pair[3]] = Tile.new
        puts "not a valid move, in check"
        next
      end
    end   
    board.white_turn == true ? board.white_turn = false : board.white_turn = true
  end 
end

def save(board)
  print "What is your file name?: "
  file_name = gets.chomp
  File.open("../save/#{file_name}.yml", "w") {|f| f.write(board.to_yaml)}
  puts "Your game has been saved!"
  exit
end

def load
  board = begin
  files = Dir.entries("/Users/school/the_odin_project/chess/save").select {|f| !File.directory? f}
  puts "Saved Files: "
  files.each {|file| puts file.delete_suffix('.yml')}
  print "Enter the name of your saved file: "
  file_name = gets.chomp
    YAML.load(File.open("../save/#{file_name}.yml"))
  rescue ArgumentError => e
    puts "Could not parse YAML: #{e.message}"
  end
  board
end

start