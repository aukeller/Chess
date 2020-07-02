require 'rspec'
require_relative '../lib/board.rb'

describe 'Board' do
  let(:board) {Board.new}

  describe 'move' do 
    it 'can move from start' do 
      expect(board.move(0, 1, 2, 2)).to be_truthy
      expect(board.move(1, 1, 3, 1)).to be_truthy
    end
  end

end