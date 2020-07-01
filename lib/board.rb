require_relative 'pieces/pieces.rb'
require_relative 'rules.rb'

include Rules
class Board
  attr_accessor :grid, :white_turn, :white_king_rook_move, :black_king_rook_move, 
  :white_pawn_move_two, :black_pawn_move_two, :killed
  def initialize
    @grid = Array.new(8) {Array.new(8, Tile.new)}
    add_default(6, 7, "black")
    add_default(1, 0, "white")
    @killed = []
    @white_king_rook_move = false
    @black_king_rook_move = false
    @white_pawn_move_two = nil
    @black_pawn_move_two = nil
    @white_turn = true
  end


  def add_default(pawn_row, piece_row, color)
    8.times { |file| grid[pawn_row][file] = Pawn.new(color, pawn_row, file) }
    
    grid[piece_row][0..4] = [Rook.new(color, piece_row, 0), Knight.new(color, piece_row, 1), Bishop.new(color, piece_row, 2), 
    Queen.new(color, piece_row, 3), King.new(color, piece_row, 4)]
    grid[piece_row][5..7] = [Rook.new(color, piece_row, 7), Knight.new(color, piece_row, 6), Bishop.new(color, piece_row, 5)].reverse
  end

  def pawn_promotion?(piece, new_rank, new_file)
    return true if piece.class == Pawn && (piece.rank == 7 || piece.rank == 0) 
  end

  def get_pawn_promotion(piece, new_rank, new_file)
    puts "choose promotion: rook, bishop, queen, knight"
    choice = gets.chomp.downcase
    if choice == "rook"
      grid[new_rank][new_file] = Rook.new(piece.color, new_rank, new_file)
    elsif choice == "bishop"
      grid[new_rank][new_file] = Bishop.new(piece.color, new_rank, new_file)
    elsif choice == "queen"
      grid[new_rank][new_file] = Queen.new(piece.color, new_rank, new_file)
    elsif choice == "knight"
      grid[new_rank][new_file] = Knight.new(piece.color, new_rank, new_file)
    else
      puts "invalid promotion, try again"
      get_pawn_promotion(piece, new_rank, new_file)
    end
  end


  def king_rook_move?(piece)
    return true if (piece.class == King || piece.class == Rook) 
  end 

  def pawn_move_two?(piece, new_rank)
    return true if piece.class == Pawn && (new_rank - piece.rank).abs == 2
  end


  def move(rank, file, new_rank, new_file)
    piece = grid[rank][file]
    if !piece.nil? && piece.valid_move(new_rank, new_file, grid)
      if king_rook_move?(piece) 
        piece.color == "white" ? @white_king_rook_move = true : @black_king_rook_move = true
      elsif pawn_move_two?(piece, new_rank)
        piece.color == "white" ? @white_pawn_move_two = piece : @black_pawn_move_two = piece
      end
      new_tile = grid[new_rank][new_file]
      @killed << new_tile.symbol if new_tile.class != Tile
      piece.rank, piece.file = new_rank, new_file
      grid[new_rank][new_file] = grid[rank][file]
      if pawn_promotion?(piece, new_rank, new_file)
        get_pawn_promotion(piece, new_rank, new_file)
        grid[rank][file] = Tile.new
      else
        grid[rank][file] = Tile.new
      end  
    else
      puts "not a valid move"
      return false
    end
  end

  def find_king(color)
    grid.each do |row|
      row.each do |tile|
        if tile.class == Tile 
          next
        elsif tile.class == King && tile.color == color
          return tile
        end
      end
    end
  end

  def find_attacker(color)
    king = find_king(color)
    grid.each do |row|
      row.each do |tile|
        if tile.class == Tile || tile.color == color
          next
        elsif tile.valid_move(king.rank, king.file, grid)
          return tile
        else
          next
        end
      end
    end
    return false
  end
  
  def display
    puts "  a b c d e f g h       #{@killed.join}"
    grid.reverse.each_with_index do |row, index|
      puts (8 - index).to_s + " #{row.map { |tile| tile.symbol}.join(' ')} " + (8 - index).to_s
    end
    puts "  a b c d e f g h"
  end

end


