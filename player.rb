require_relative 'deck'
class Player
  attr_accessor :name, :bet, :hand, :cash, :card_values
  def initialize (name, bet, hand, cash, card_values)
    @name = name
    @bet = bet
    @hand = hand
    @cash = cash
    @card_values = card_values
  end
  #=============Display Functions===============
  def show_player_cards
    puts "   #{@name} ------- Bet: [#{@bet}]"
    @hand.each do |card|
      card.show_card
    end
    puts "#{self.card_value_sum}"
  end
  def show_player_bet
    puts "#{@name} --- Bet: [$#{@bet}] --- Cash: [$#{@cash}]"
  end
  def show_player_cash
    puts "  #{@name} ------ Cash: [$#{@cash}] "
  end
  def cash_infusion(dollars)
    @cash = dollars.to_i
  end
  def check_cash
     @cash >= @bet
  end
  def place_bet(amount)
    @bet = amount
    @cash = @cash - @bet
    gets.chomp
  end
  # +++++=================
  def pairs
    @hand.count == 2 &&
    (@hand[1].name == @hand[0].name)
  end
  def split
    @cash -= @bet
    split_player = Player.new("#{@name}-split", @bet, [], 0, [])
     split_card = @hand.pop
     split_player.hand << split_card
     split_card_value = @card_values.pop
    split_player.card_values << split_card_value
  end
  def merge_with(other_player)
      @cash += other_player.cash
  end

  def take(card)
       @hand << card
       @card_values << card.value
  end

  def card_value_sum
  @card_values.reduce(:+)
  end
  def check_cards
    if self.card_value_sum == 21
       puts "    === 21 ==="
       puts " "
     end
    if self.card_value_sum > 21
      puts "     BUST!"
      puts " "
      self.card_values = [0]
    end
  end

  def check_for_21
    self.card_value_sum == 21
  end
  def check_for_blackjack
    self.card_value_sum == 21 && @hand.count == 2
  end
  def check_for_aces
    if @card_values.include?(11) && self.card_value_sum > 21
       @card_values.delete(11)
       @card_values << 1
      end
  end


  def double_down
    @cash = @cash - @bet
    @bet = 2 * @bet
  end


  def payout(result)
    if result == 'blackjack'
      @cash = @cash + (3 * @bet)
      puts "     #{self.name}, your Blackjack wins [$#{2 * @bet}]"
      @bet = 0
    end
    if result == 'win'
      @cash = @cash + (2 * @bet)
      puts "         #{self.name} wins [$#{@bet}]"
      @bet = 0
    end
    if result == 'tie'
      @cash = @cash + @bet
      puts "          #{self.name} breaks even  "
      @bet = 0

    end
    if result == 'loss'
      puts "           #{self.name} loses [$#{@bet}]  "
      @bet = 0
    end
  end
end
