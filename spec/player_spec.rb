require 'player'
RSpec.describe Player do
  let (:player1){Player.new(name: "One", bet: 0, hand: [], cash: 100, card_values: [])}
  it '.new create a new player' do
    expect(player1).to be_an_instance_of Player
  end
end
