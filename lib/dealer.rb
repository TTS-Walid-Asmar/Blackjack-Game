require_relative 'player'
require_relative 'deck'
class Dealer
  attr_accessor :name, :upcards, :holecard, :hand_value, :deck
  def initialize(name, upcards, holecard, hand_value, deck)
    @name = name
    @upcards = upcards
    @holecard = holecard
    @hand_value = hand_value
    @deck = deck
  end
  def get_deck
    deck = Deck.new([], [], [])
    deck = deck.build
    @deck = deck.shuffle
  end
  def show_dealer_cards
    puts " #{name}----------"
    @upcards.each do |card|
      card.show_card
    end
  end

  def take_bet_from(player)
      puts "     #{player.name}, place your bet"
      amount = gets.chomp.to_i
    if amount < 1
      puts "     Table minimum is $1"
      puts "      Try again"
      self.take_bet_from(player)
    elsif amount > player.cash
      puts "     You don't have that kind of dough"
      puts "     Try again"
      self.take_bet_from(player)
    elsif amount == player.cash
      puts "      You're all in! "
      player.place_bet(amount)
    elsif amount < player.cash
      puts "       Thank you "
      player.place_bet(amount)
    end
  end
  def deal_to(player)
    card = @deck.shift
    player.take(card)
    player.check_for_aces
  end
  def deal_upcard
    card = @deck.shift
    @upcards << card
    @hand_value += card.value
  end
  def deal_holecard
    card = @deck.shift
    @holecard = card
    @hand_value += card.value
    blank_card = Card.new('*', '*', 0)
    @upcards << blank_card
  end
  def show_hole_card
    @holecard.show_card
  end
  def offer_card_to(player)
    ans = ''
    while ans != 'N'
      if player.card_value_sum >= 21
        break
      end
      puts "    #{player.name}  Hit?  [Y/N]"
      ans = gets.chomp.upcase
      if ans == 'Y'
        self.deal_to(player)
        player.show_player_cards
      elsif ans == 'N'
        puts "    #{player.name} stands"
        puts " "
      end
    end
   player.check_cards
  end
  def offer_one_card_to(player)
    puts "Here comes you're one and only hit card....."
    gets.chomp
    self.deal_to(player)
    player.show_player_cards
    player.check_cards
  end
  def dealer_turn
    @upcards.pop
    @upcards << @holecard
    self.show_dealer_cards
    until @hand_value >= 17
      self.deal_upcard
      puts "   The Dealer draws........"
      self.show_dealer_cards
    end
    if @hand_value < 21
      puts "       The Dealer Stands  "
    end
    if @hand_value == 21
      puts "       ======= 21 ======="
    end
    if @hand_value > 21
      puts "      The Dealer BUSTS! "
      @hand_value = 1
      @upcards = []
    end
  end

  def check_results(player)
    if player.check_for_blackjack == true
       player.payout('blackjack')
    end
    if player.card_value_sum > @hand_value
       player.payout('win')
    end
    if player.card_value_sum == @hand_value
         player.payout('tie')
    end
    if player.card_value_sum < @hand_value
       player.payout('loss')
    end
  end
  def get_new_deck
    deck_new = Deck.new([], [], [])
    deck = deck_new.build
    @deck = deck.shuffle
  end
def reset_dealer
  @upcards = []
  @holcard = nil
  @hand_value = 0
  @deck = []
end

end
