##OO Blackjack game

class Card
  attr_accessor :face_value, :suit
  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def display_cards
    "The #{face_value} of #{find_suit}"    
  end

  def to_s
    display_cards
  end

  def find_suit
    return_value = case suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Club'              
    end
    return_value
  end
end

class Deck
  CARDS = [2,3,4,5,6,7,8,9,10,'J','Q','K','A']
  CARD_TYPE = ['S','C','H','D']

  attr_accessor :cards

  def initialize
    @cards = []
    CARD_TYPE.each do |suit|
      CARDS.each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    deck.size
  end

end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=>#{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map { |card| card.face_value }

    total = 0
    face_values.each do |val|
      if val == 'A'
        total += 11
       else
       total += (val.to_i == 0? 10 : val.to_i) 
      end
    end

    face_values.select{|val| val == "A"}.count.times do
      break if total <= 21
      total += 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end
end

class Player
  attr_accessor :name, :cards
  include Hand

  def initialize(n)
    @name = n
    @cards = []
  end

end

class Dealer
  attr_accessor :name, :cards
  include Hand

  def initialize()
    @name = "Dealer"
    @cards = []
  end
end

class Game
  def initialize
    
  end

  def get_hit_or_stay
    puts "\nDo you want to hit or stay?"
    hit_or_stay = gets.chomp.downcase
    while !["hit", "stay"].include?(hit_or_stay)
      puts "Please enter hit or stay"
      hit_or_stay = gets.chomp.downcase
    end
    hit_or_stay
end

def game_over(player_total,dealer_total)
  if dealer_total == player_total
    puts "It's a tie"    
  elsif player_total > 21 
    puts "You've busted. Sorry, the dealer wins this game"
  elsif dealer_total > 21
    puts "Dealer busted. You won the game"
  elsif dealer_total > player_total 
    puts "Sorry, the dealer wins this time"
  elsif player_total > dealer_total
    puts "Congratulations ...you won"
  end   
end

def play(player,dealer)
  
  is_game_over = false
  show_dealer_hand = true

  while is_game_over == false
    deck = Deck.new
    player_total = 0
    dealer_total = 0
    player_cards = []
    dealer_cards = []

    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.show_hand

    if !player.is_busted?
      hit_or_stay = get_hit_or_stay
      while hit_or_stay == 'hit' do
        player.add_card(deck.deal_one)
        player.show_hand
        if player.is_busted?
          is_game_over = true
          show_dealer_hand = true
          break
        else
          hit_or_stay = get_hit_or_stay
        end
      end
    end
    if player.is_busted?
      is_game_over = true
      show_dealer_hand = true
      break
    end
    if hit_or_stay == "stay"
      if dealer.is_busted?
        is_game_over = true
        show_dealer_hand = true
        break
      end
      while dealer.total < 17
        dealer.add_card(deck.deal_one)
        if dealer.total >= 21
          show_dealer_hand = false
          is_game_over = true
          break
        end
      end
    end
    if dealer.total >= 17 && dealer.total < 21 && hit_or_stay == 'stay'
        is_game_over = true
        show_dealer_hand = true
        break        
      end
  end
  if show_dealer_hand
    dealer.show_hand
  end
  game_over(player.total,dealer.total)
end
end


system "clear"
puts "Welcome to Blackjack game. May I have your name please?"
player_name = gets.chomp

another_round = "yes"
  
while another_round == "yes"
  player = Player.new(player_name)
  dealer = Dealer.new
  Game.new.play(player,dealer)
  puts "Do you want to play another round?"
  another_round = gets.chomp.downcase
  while !['yes','no'].include?(another_round)
    puts "Do you want to play another round?"
    another_round = gets.chomp.downcase
  end
  system "clear"
end