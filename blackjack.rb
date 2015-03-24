# deal two cards to the player (shown) 
# deal two cards to the dealer (one shown, one hidden)
# 
# ** player's turn **
# ask the player if they wish to "hit" or "stay"
# if "hit"
#   deal the player another card ("hit them")
#   if the total value is exactly 21
#     player wins, game ends
#   elsif the total value > 21
#     player busts, game ends
#   else
#     turn goes to dealer
# elsif "stay"
#   player total value stays the same, turn goes to dealer. 
# 
# ** dealer's turn **
# if dealer's total value is < 17
#   deal the dealer another card ("hit them")
#   turn goes to the player
# elsif the total value is exactly 21
#   dealer wins
# else (if the total value is >= 17) the dealer must stay
#   compare the sums between the player and the dealer - the higher value wins. 
# 
# if winner
#   announce winner 
# elsif loser
#   announce loser
# else tie
#   announce tie

def say(str)
  puts "=> #{str} "
end

def deal_cards(deck, receiving_hand, num_of_cards=1)
  num_of_cards.times do
    # give a card to the player
    card = deck.to_a.sample
    card_type = card[1].sample
    card_suit = card[0]
    receiving_hand << [card_type, card_suit]
    # take a card from the deck
    deck[card_suit].delete(card_type)
  end
end

def total_value_of_cards(hand)
  card_value_legend = {"Ace"=>1, "Two"=>2, "Three"=>3, "Four"=>4, "Five"=>5, "Six"=>6, "Seven"=>7, "Eight"=>8, "Nine"=>9, "Ten"=>10, "Jack"=>10, "Queen"=>10, "King"=>10}
  total_value = [0,0]
  hand.each do |card| # A sample hand looks like [["Ace", "Hearts"],["Seven", "Clubs"]]. A sample card looks like ["Ace", "Hearts"]
    if card[0] == "Ace" # Ace-specific details
      total_value[0] += 1
      total_value[1] += 11
    else
      total_value[0] += card_value_legend[card[0]]
      total_value[1] += card_value_legend[card[0]]
    end
  end
  total_value
end

def announce_value(hand)
  if total_value_of_cards(hand)[0] != total_value_of_cards(hand)[1]
    say "The total value of your cards is #{total_value_of_cards(hand)[0]} or #{total_value_of_cards(hand)[1]}."
  else
    say "The total value of your cards is #{total_value_of_cards(hand)[0]}."
  end
end

def display_cards(players_hand, dealers_hand, full_reveal="no")
  system "clear"
  puts "     \n     "
  puts "     Your Cards"
  players_hand.each { |card| puts "#{card[0]} of #{card[1]}" }
  puts "     \n     "
  puts "     Dealer's Cards"
  if full_reveal == "no"
    @dealers_showing_card = dealers_hand.sample if @dealers_showing_card == nil 
    puts "#{@dealers_showing_card[0]} of #{@dealers_showing_card[1]}"
    if (dealers_hand.length - 1) > 1
      puts "..And #{dealers_hand.length - 1} hidden cards."
    elsif (dealers_hand.length - 1) == 1
      puts "..And 1 hidden card."
    end
  elsif full_reveal == "yes"
    dealers_hand.each { |card| puts "#{card[0]} of #{card[1]}" }
  end
  puts "     \n     "
end

def game_over(winner_name, players_hand, dealers_hand)
  @winner = winner_name
  if winner_name == "You"
    say "Yay!! You won!"
    if total_value_of_cards(players_hand)[0] == total_value_of_cards(players_hand)[1]
      say "You had a total hand value of #{total_value_of_cards(players_hand)[0]}."
    else
      say "You had a total hand value of #{total_value_of_cards(players_hand)[0]} or #{total_value_of_cards(players_hand)[1]}."
    end
    if total_value_of_cards(dealers_hand)[0] == total_value_of_cards(dealers_hand)[1]
      say "The dealer had a total hand value of #{total_value_of_cards(dealers_hand)[0]}."
    else
      say "The dealer had a total hand value of #{total_value_of_cards(dealers_hand)[0]} or #{total_value_of_cards(dealers_hand)[1]}."
    end
  else
    say "Aww, looks like the dealer won!!"
    if total_value_of_cards(players_hand)[0] == total_value_of_cards(players_hand)[1]
      say "You had a total hand value of #{total_value_of_cards(players_hand)[0]}."
    else
      say "You had a total hand value of #{total_value_of_cards(players_hand)[0]} or #{total_value_of_cards(players_hand)[1]}."
    end
    if total_value_of_cards(dealers_hand)[0] == total_value_of_cards(dealers_hand)[1]
      say "The dealer had a total hand value of #{total_value_of_cards(dealers_hand)[0]}."
    else
      say "The dealer had a total hand value of #{total_value_of_cards(dealers_hand)[0]} or #{total_value_of_cards(dealers_hand)[1]}."
    end
    # say "The dealer beat you with a total hand value of #{total_value_of_cards(dealers_hand)[0]} or #{total_value_of_cards(dealers_hand)[1]}."
    # say "You had a total hand value of #{total_value_of_cards(players_hand)[0]} or #{total_value_of_cards(players_hand)[1]}."
  end
  sleep(1)
  # Reveal dealer's cards now
  say "Want to play again? (Type 'Y' or 'N')"
  play_again_decision = gets.chomp.downcase
  if play_again_decision == 'y'
    say "Okay! I'll deal again."
    sleep(1)
    play_game
  else
    say "Bye! Nice playing with you!"
  end
end

def dealers_turn(deck, players_hand, dealers_hand)
  say "It's the dealer's turn."
  sleep(1)
  if ((total_value_of_cards(dealers_hand)[0] != total_value_of_cards(dealers_hand)[1]) && (total_value_of_cards(dealers_hand)[0] < 17)) || ((total_value_of_cards(dealers_hand)[0] == total_value_of_cards(dealers_hand)[1]) && (total_value_of_cards(dealers_hand)[0] < 17))
    say "Dealer draws a card.."
    sleep(2)
    deal_cards(deck, dealers_hand)
    display_cards(players_hand, dealers_hand)
    announce_value(players_hand)
  elsif (total_value_of_cards(dealers_hand)[0] == 21) || (total_value_of_cards(dealers_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    game_over("Dealer", players_hand, dealers_hand)
  elsif (total_value_of_cards(dealers_hand)[0] > 21)
    display_cards(players_hand, dealers_hand, "yes")
    game_over("You", players_hand, dealers_hand)
  else
    say "Dealer stays."
    sleep(1)
  end
end

def play_game
  the_deck = { "Spades"=>["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"], 
         "Hearts"=>["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"], 
         "Clubs"=>["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"], 
         "Diamonds"=>["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"] }
  players_hand = []
  dealers_hand = []
  @winner = nil

  deal_cards(the_deck, players_hand, 2) # deal two cards to the player
  deal_cards(the_deck, dealers_hand, 2)# deal two cards to the dealer

  display_cards(players_hand, dealers_hand)
  announce_value(players_hand)

  if (total_value_of_cards(dealers_hand)[0] == 21) || (total_value_of_cards(dealers_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    game_over("Dealer", players_hand, dealers_hand)
  elsif (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    game_over("You", players_hand, dealers_hand)
  end

  while !@winner
    say "Would you like to hit or stay? (Type 'H' or 'S')"

    player_choice = ""
    loop do
      player_choice = gets.chomp.downcase
      break if (player_choice == 'h') || (player_choice == 's')
      say "Oops.. That's not an option. Type 'H' and hit enter if you wish to receive a card."
      say "Type 'S' and hit enter if you're satisfied with your hand and wish to stay."
    end

    if player_choice == 'h'
      deal_cards(the_deck, players_hand)
      display_cards(players_hand, dealers_hand)
      announce_value(players_hand)
      if (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
        display_cards(players_hand, dealers_hand, "yes")
        game_over("You", players_hand, dealers_hand)
      elsif (total_value_of_cards(players_hand)[0] > 21)
        display_cards(players_hand, dealers_hand, "yes")
        game_over("Dealer", players_hand, dealers_hand)
      else 
        dealers_turn(the_deck, players_hand, dealers_hand)
      end
    elsif player_choice == 's'
      if (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
        display_cards(players_hand, dealers_hand, "yes")
        game_over("You", players_hand, dealers_hand)
      elsif total_value_of_cards(players_hand)[0] || total_value_of_cards(players_hand)[1] > 21
        display_cards(players_hand, dealers_hand, "yes")
        game_over("Dealer", players_hand, dealers_hand)
      else
        say "You chose to stay."
        sleep(1)
        say "It's the dealer's turn."
        sleep(1)
        dealers_turn(the_deck, players_hand, dealers_hand)
      end
    end
  end
end

say "Welcome to Blackjack!"
sleep(1)
say "I'll deal the cards."
sleep(1)
play_game