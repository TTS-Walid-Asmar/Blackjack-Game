require_relative 'dealer'
# require_relative 'card'
# require_relative 'player'
# require_relative 'deck'
class Game
  attr_accessor :table, :dealer
  def initialize(table, dealer)
    @table = table
    @dealer = dealer
  end
  def create_table
    puts " "
    puts "     How many players? (1-4)"
    puts " "
    number_of_players = gets.chomp.to_i
    @table =[]
    counter = 1
    number_of_players.times do
      puts " "
      puts "     Player#{counter}: Name?"
      puts " "
      name = gets.chomp
      player = Player.new(name, 0, [], 100, [0])
      @table << player
      puts " "
      puts "     Welcome to the table, #{player.name}."
      puts "     You'll begin with $#{player.cash}."
      puts " "
      counter = counter + 1
    end
  end
  def show_table_bets
    puts " "
    puts ".................[TABLE]................... "
    @table.each do |player|
      player.show_player_bet
    end
    puts ".................[TABLE]...................."
    puts " "
  end
  def show_table_cards
    puts " "
    puts ".................[TABLE]................... "
    @table.each do |player|
      player.show_player_cards
    end
    dealer.show_dealer_cards
    puts ".................[TABLE]...................."
    puts " "
  end
  def show_table_cash
    puts " "
    puts ".................[TABLE]................... "
    @table.each do |player|
      player.show_player_cash
    end
    puts ".................[TABLE]...................."
    puts " "
  end

  def betting_round
    @table.each do |player|
      dealer.take_bet_from(player)
    end
    @table.each do |player|
      player.show_player_cash
    end
  end
  def first_deal
      @table.each do |player|
        puts "          Dealing 1st card to #{player.name}............."
        gets.chomp
        dealer.deal_to(player)
        player.show_player_cards
        gets.chomp
      end
      puts "  Dealer draws upcard  "
      gets.chomp
      dealer.deal_upcard
      dealer.show_dealer_cards
      gets.chomp
      @table.each do |player|
        puts "   Dealing 2nd card to #{player.name}.............."
        gets.chomp
        dealer.deal_to(player)
        player.show_player_cards
        if player.check_for_21 == true
          puts "BLACKJACK!!"
        end
        gets.chomp
      end
      puts "   Dealer draws hole card "
      dealer.deal_holecard
      dealer.show_dealer_cards
      self.show_table_cards
      puts " "
# +++========TEST========
      @table.each do |player|
        puts "#{player.pairs}"
      end
      # ++++++++++++++++++++++
  end
  def player_turns
    @table.each do |player|
      unless player.check_for_21 == true
        player.show_player_cards
        if player.check_cash == true
          if player.pairs == true
            puts "Would you like to split the pair?   [Y/N]"
            ans = gets.chomp.upcase
            if ans == 'Y'
              split_player = player.split
              p split_player
              p player
              @table << split_player
              dealer.offer_card_to(player)
              dealer.offer_card_to(split_player)
            end
          else puts "#{player.name}, would you like to double down? [Y/N]"
               ans = gets.chomp.upcase
               if ans == 'Y'
                 player.double_down
                 player.show_player_cash
                 dealer.offer_one_card_to(player)
                 gets.chomp
                end
          end
         else dealer.offer_card_to(player)
         end
      end
      puts "  "
    end
  end

  def score_and_payout
    @table.each do |player|
      dealer.check_results(player)
    end
    @table.each_with_index do |player, i|
      if @table[i].name == "#{player.name}-split"
         @table[i].merge_with(player)
         @table.delete(@table[i])
       end
    end
  end

  def end_game


     puts " "
     puts "               Show Results               "
     gets.chomp
     self.show_table_cash
     puts "               Game Over                   "
     puts " "
  end
  def play_game
    replay_ans = ' '
    until replay_ans == 'N'
      self.betting_round
      gets.chomp
      self.first_deal
      gets.chomp
      self.player_turns
      gets.chomp
      dealer.dealer_turn
      gets.chomp
      self.show_table_cards
      self.score_and_payout
      gets.chomp
      self.end_game
      puts "     Play again?   [Y/N]"
      replay_ans = gets.chomp.upcase
      if replay_ans == 'Y'
        dealer.reset_dealer
        dealer.get_new_deck
        @table.each do |player|
          player.bet = 0
          player.hand = []
          player.card_values = []
          if player.cash == 0
            player.cash_infusion(20)
            puts "Here's $20 to get you back in the game."
            player.show_player_cash
          end
        end
       end
     end

  end
end

puts " "
puts " "
puts "   Blackjack................ish    "
dealer = Dealer.new('Dealer', [], nil, 0, [])
dealer.get_deck
game = Game.new([], dealer)
game.create_table
gets.chomp
game.show_table_cash
game.play_game
