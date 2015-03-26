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

require 'pry'

CARD_VALUE_LEGEND = {"Ace"=>1, "Two"=>2, "Three"=>3, "Four"=>4, "Five"=>5, "Six"=>6, "Seven"=>7, "Eight"=>8, "Nine"=>9, "Ten"=>10, "Jack"=>10, "Queen"=>10, "King"=>10}

def say(str)
  puts "=> #{str} "
end

def deal_cards(deck, receiving_hand, num_of_cards=1)
  num_of_cards.times do
    card = deck.to_a.sample
    card_type = card[1].sample
    card_suit = card[0]
    receiving_hand << [card_type, card_suit]
    deck[card_suit].delete(card_type)
  end
end

def total_value_of_cards(hand)
  total_value = [0,0]
  hand.each do |card| 
    if card[0] == "Ace" 
      total_value[0] += 1
      total_value[1] += 11
    else
      total_value[0] += CARD_VALUE_LEGEND[card[0]]
      total_value[1] += CARD_VALUE_LEGEND[card[0]]
    end
  end
  total_value
end

def announce_value(players_hand, dealers_hand, final_announcement=nil)
  if final_announcement
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
    if total_value_of_cards(players_hand)[0] != total_value_of_cards(players_hand)[1]
      say "The total value of your cards is #{total_value_of_cards(players_hand)[0]} or #{total_value_of_cards(players_hand)[1]}."
    else
      say "The total value of your cards is #{total_value_of_cards(players_hand)[0]}."
    end
  end
end

def display_cards(players_hand, dealers_hand, full_reveal="no")
  system "clear"
  puts "     \n"
  puts "     Your Cards"
  players_hand.each { |card| puts "#{card[0]} of #{card[1]}" }
  puts "     \n"
  puts "     Dealer's Cards"
  if full_reveal == "no"
    dealers_showing_card = dealers_hand.sample if dealers_showing_card == nil 
    puts "#{dealers_showing_card[0]} of #{dealers_showing_card[1]}"
    if (dealers_hand.length - 1) > 1
      puts "..And #{dealers_hand.length - 1} hidden cards."
    elsif (dealers_hand.length - 1) == 1
      puts "..And 1 hidden card."
    end
  elsif full_reveal == "yes"
    dealers_hand.each { |card| puts "#{card[0]} of #{card[1]}" }
  end
  puts "     \n"
end

def game_over(winner_name, players_hand, dealers_hand)
  if winner_name == "You"
    say "Yay!! You won!"
    announce_value(players_hand, dealers_hand, 'final_announcement')
  elsif winner_name == "Dealer"
    say "Aww, looks like the dealer won!!"
    announce_value(players_hand, dealers_hand, 'final_announcement')
  else
    say "Ay, it's a tie!"
    announce_value(players_hand, dealers_hand, 'final_announcement')
  end
  sleep(1)
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

def compare_hands
  say "Comparing hands.."
  sleep(1)
  dealers_highest_hand = total_value_of_cards(dealers_hand).sort.last
  players_highest_hand = total_value_of_cards(players_hand).sort.last
  if (dealers_highest_hand > players_highest_hand)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "Dealer"
    game_over(winner, players_hand, dealers_hand)
    exit
  elsif (players_highest_hand > dealers_highest_hand)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "You"
    game_over(winner, players_hand, dealers_hand)
    exit
  else
    display_cards(players_hand, dealers_hand, "yes")
    winner = "Tie"
    game_over(winner, players_hand, dealers_hand)
    exit
  end
end

def dealers_turn(deck, players_hand, dealers_hand, dealer_stays=false)
  say "It's the dealer's turn."
  sleep(1)
  if ((total_value_of_cards(dealers_hand)[0] != total_value_of_cards(dealers_hand)[1]) && (total_value_of_cards(dealers_hand)[0] < 17)) || ((total_value_of_cards(dealers_hand)[0] == total_value_of_cards(dealers_hand)[1]) && (total_value_of_cards(dealers_hand)[0] < 17))
    say "Dealer draws a card.."
    sleep(2)
    deal_cards(deck, dealers_hand)
    display_cards(players_hand, dealers_hand)
    announce_value(players_hand, dealers_hand)
  elsif (total_value_of_cards(dealers_hand)[0] == 21) || (total_value_of_cards(dealers_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "Dealer"
    game_over(winner, players_hand, dealers_hand)
    exit
  elsif (total_value_of_cards(dealers_hand)[0] > 21)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "Dealer"
    game_over(winner, players_hand, dealers_hand)
    exit
  else
    say "Dealer stays."
    if dealer_stays
      say "Comparing hands.."
      sleep(1)
      dealers_highest_hand = total_value_of_cards(dealers_hand).sort.last
      players_highest_hand = total_value_of_cards(players_hand).sort.last
      if (dealers_highest_hand > players_highest_hand)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "Dealer"
        game_over(winner, players_hand, dealers_hand)
        exit
      elsif (players_highest_hand > dealers_highest_hand)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "You"
        game_over(winner, players_hand, dealers_hand)
        exit
      else
        display_cards(players_hand, dealers_hand, "yes")
        winner = "Tie"
        game_over(winner, players_hand, dealers_hand)
        exit
      end
    end
    sleep(1)
  end
end

def play_game
  suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
  cards = ['Ace', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King']
  the_deck = {}
  suits.each do |suit|
    the_deck[suit] = []
    cards.each do |card|
      the_deck[suit] << card
    end
  end
  players_hand = []
  dealers_hand = []
  winner = nil

  deal_cards(the_deck, players_hand, 2) 
  deal_cards(the_deck, dealers_hand, 2)

  display_cards(players_hand, dealers_hand)
  players_hand_value = total_value_of_cards(players_hand)
  dealers_hand_value = total_value_of_cards(dealers_hand)
  announce_value(players_hand, dealers_hand)

  if (total_value_of_cards(dealers_hand)[0] == 21) || (total_value_of_cards(dealers_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "Dealer"
    game_over(winner, players_hand, dealers_hand)
    exit
  elsif (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
    display_cards(players_hand, dealers_hand, "yes")
    winner = "You"
    game_over(winner, players_hand, dealers_hand)
    exit
  end

  until winner
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
      announce_value(players_hand, dealers_hand)
      if (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "You"
        game_over(winner, players_hand, dealers_hand)
        exit
      elsif (total_value_of_cards(players_hand)[0] > 21)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "Dealer"
        game_over(winner, players_hand, dealers_hand)
        exit
      else 
        dealers_turn(the_deck, players_hand, dealers_hand)
      end
    elsif player_choice == 's'
      if (total_value_of_cards(players_hand)[0] == 21) || (total_value_of_cards(players_hand)[1] == 21)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "You"
        game_over(winner, players_hand, dealers_hand)
        exit
      elsif (total_value_of_cards(players_hand)[0] > 21) || (total_value_of_cards(players_hand)[1] > 21)
        display_cards(players_hand, dealers_hand, "yes")
        winner = "Dealer"
        game_over(winner, players_hand, dealers_hand)
        exit
      else
        say "You chose to stay."
        sleep(1)
        dealers_turn(the_deck, players_hand, dealers_hand, dealer_stays=true)
      end
    end
  end
end

say "Welcome to Blackjack!"
sleep(1)
say "I'll deal the cards."
sleep(1)
play_game