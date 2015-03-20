#Tic Tac Toe OO Game

class Board
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  attr_accessor :data

  def initialize
    @data = {}
    (1..9).each{|position| @data[position] = Square.new(' ')}
  end

  def draw
    system 'clear'
    puts " #{@data[1].value} | #{@data[2].value} | #{@data[3].value} "
    puts "-----------"
    puts " #{@data[4].value} | #{@data[5].value} | #{@data[6].value} "
    puts "-----------"
    puts " #{@data[7].value} | #{@data[8].value} | #{@data[9].value} "
  end

  def mark_square(position,marker)
    @data[position].mark(marker)
  end

  def empty_positions
    @data.select {|_, square| square.empty?}.keys
  end

  def winning_condition?(marker)
    WINNING_LINES.each do |line| 
      return true if @data[line[0]].value == marker && @data[line[1]].value == marker && @data[line[2]].value == marker
    end
    false
  end

  def all_squares_marked?
    empty_squares.size == 0
  end

  def empty_squares
    @data.select {|_, square| square.value == ' '}.values
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def occupied?
    @value != ' '
  end

  def empty?
    @value == ' ' 
  end

  def mark(marker)
    @value = marker
  end

end

class Player
  attr_reader :marker, :name

  def initialize(name,marker)
    @name = name
    @marker = marker
  end
end

class Game

  def initialize
    @board = Board.new
    
  end

  def set_players(name)
    @human = Player.new(name, "x")
    @computer = Player.new("D2D3", "o")
    @current_player = @human
  end

  def current_player_win?
    @board.winning_condition?(@current_player.marker)  
  end

  def reset
    @board = Board.new
    @current_player = @human
  end

  def play_again?     
    puts "(P)lay or Press any key to play again. "          
    gets.chomp.upcase == "P" ? true : false 
  end

  def play
    @board.draw
    loop do
      current_player_marks_square
      @board.draw
      if current_player_win?
        puts "The winner is #{@current_player.name}!"
        break
      elsif @board.all_squares_marked?
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
  end

  def current_player_marks_square
    if @current_player == @human
       begin
        puts "Choose a position (1-9): "
        position = gets.chomp.to_i
        end until @board.empty_positions.include?(position)
     else
       #position = @board.empty_positions.sample
       position = computer_pick_square(@board.data)
    end
    @board.mark_square(position, @current_player.marker)
  end
  
  def computer_pick_square(board)    
    position = nil
    Board::WINNING_LINES.each do |line|
      current_grid_status = {line[0] => board[line[0]].value, line[1] => board[line[1]].value, line[2] => board[line[2]].value}
      found_two_in_a_row = two_in_a_row(current_grid_status, 'x')
      
      if found_two_in_a_row
        position = found_two_in_a_row
      end
    end
      
    if !position
        position = @board.empty_positions.sample
    end
    #board[position] = 'o'
    position 
  end

  # checks to see if two in a row
def two_in_a_row(current_grid_status, mrkr)
  if current_grid_status.values.count(mrkr) == 2
    current_grid_status.select{|k,v| v == ' '}.keys.first
  else
    false
  end
end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end
end

response = ' '
system "clear"
puts "------------Welcome to Tic Tac Toe ------------------"

while true
      puts "Please tell me what's your name ? "
      name = gets.chomp       
      if !name.empty?    
        break
      end
end

loop do
  new_game = Game.new
  new_game.set_players(name)
  new_game.play
  if new_game.play_again?
     new_game.reset
     else
      break
  end  
end 