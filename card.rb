class Card
  attr_accessor :name, :suit, :value
  def initialize(name, suit, value)
    @name = name
    @suit = suit
    @value = value
  end
  def show_card
    puts "           [#{@name} of #{@suit}]       "
  end
  def decr_value_by_10
    @value -= 10
  end
end
