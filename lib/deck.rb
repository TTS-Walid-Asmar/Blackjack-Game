require_relative 'card'
class Deck
  attr_reader :suits, :numbers, :faces
  def initialize(suits, numbers, faces)
    @suits = %w[Diamonds Hearts Clubs Spades]
    @numbers = %w[2 3 4 5 6 7 8 9 10]
    @faces = %w[Jack Queen King]
  end
  def build
      deck = []
      @suits.each do |suit|
        @numbers.each do |number|
          card = Card.new(number.to_s, suit.to_s, number.to_i)
          deck << card
        end
        @faces.each do |face|
          card = Card.new(face.to_s, suit.to_s, 10)
          deck << card
        end
        ace = Card.new('Ace', suit.to_s, 11)
        deck << ace
      end
    return deck
  end
end
