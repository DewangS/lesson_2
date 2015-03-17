#paper scissors Rock OO game

class Hand
  include Comparable
  attr_reader :value

  def initialize(v)
    @value = v
  end

  def <=>(another_hand)
    if @value == another_hand.value
      0
    elsif (@value == 'p' && another_hand.value == 'r') || (@value == 'r' && another_hand.value == 's') || 
      (@value == 's' && another_hand.value == 'p')
      1
    else
      -1
    end
  end

  def display_winning_message
    if @value == 'p'
      puts "Paper wraps Rock."
    elsif @value == 'r'
      puts "Rock smashes Scissors"
    else
      puts "Scissors cuts Paper"
  end  
  end

end


class Player

  attr_accessor :hand
  attr_reader :name

  def initialize(n)
    @name = n
  end

  def to_s
    "#{name} currently has a choice of #{self.hand.value}"
  end

end

class Human < Player

  def pick_hand
    begin
      puts "Choose one (p/r/s)"
      player_choice = gets.chomp.downcase
      if Game::CHOICES.keys.include?(player_choice) == false
          puts "*** Invalid choice... Please enter p/r/s and try again.. ***"
      end
    end until Game::CHOICES.keys.include?(player_choice)

    self.hand = Hand.new(player_choice)
  end

end

class Computer < Player
  
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end

end

class Game
  CHOICES = {'p' => 'Paper', 's' => 'Scissors', 'r' => 'Rock'}
  attr_reader :player, :computer

 def initialize
   @player = Human.new("Matt")
   @computer = Computer.new("RD3D")
 end

 def play
    player.pick_hand
    computer.pick_hand
    compare_hands
  end

  def compare_hands
    if player.hand == computer.hand 
      puts "It's a tie"
    elsif player.hand > computer.hand 
      player.hand.display_winning_message
      puts "#{player.name} won!"
    else
      computer.hand.display_winning_message
      puts "#{computer.name} won"
    end
  end

end

game = Game.new.play
