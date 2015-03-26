def calculate_total(cards) 
  arr = cards.map{|e| e[1] }
  total = 0
  arr.each do |value|
    if value == "A"
      total += 11
    elsif value.to_i == 0
      total += 10
    else
      total += value.to_i
    end
  end

  # Correct for Aces
  arr.select{ |e| e == "A" }.count.times do 
    if total > 21
      total -= 10
    end
  end

  total
end

puts "Welcome to Blackjack!"

suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
deck = suits.product(cards)
deck.shuffle!

# Deal cards
my_cards = []
dealers_cards = []
my_cards << deck.pop
dealers_cards << deck.pop

dealer_total = calculate_total(dealers_cards)
my_total = calculate_total(my_cards)

# Show cards

puts "Dealer has: #{dealers_cards[0]} and #{dealers_cards[1]} for a total of #{dealer_total}."
puts "You have: #{my_cards[0]} and #{my_cards[1]} for a total of #{my_total}."
puts ""

# Player turn

if my_total == 21
  puts "Congratulations, you hit blackjack! You win"
  exit
end

while my_total < 21
  puts "What would you like to do? 1) Hit or 2) Stay?" 
  hit_or_stay = gets.chomp

  if !['1', '2'].include?(hit_or_stay)
    puts "Error: you must enter 1 or 2"
    next
  end

  if hit_or_stay == "2"
    put "You chose to stay."
    break
  end

  # Hit
  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  my_cards << new_card
  my_total = calculate_total(my_cards)
  puts "You total is #{my_total}"

  if my_total == 21
    puts "Congratulations, you hit blackjack! You win!"
    exit
  elsif my_total > 21
    puts "Sorry, it looks like you busted!"
    exit
  end

end

# Dealer's turn

if dealer_total == 21
  puts "Sorry, dealer hit blackjack. You lose."
  exit
end

while dealer_total < 17
  # hit
  new_card = deck.pop
  puts "Dealing new card to dealer: #{new_card}"
  dealers_cards << new_card
  dealer_total = calculate_total(dealers_cards)
  puts "Dealer total is now: #{dealertotal}"

  if dealer_total == 21
    puts "Sorry, dealer hit blackjack. You lose."
    exit
  elsif dealer_total > 21
    puts "Congratulations, dealer busted! You win!"
    exit
  end
end

# Compare hands

puts "Dealer's cards: "
dealers_cards.each do |card|
  puts "=> #{card}"
end
puts ""
puts "Your cards:"
my_cards.each do |card|
  puts "=> #{card}"
end
puts ""

if dealer_total > my_total
  puts "Sorry, dealer wins."
elsif my_total > dealer_total
  puts "Congratulations, you win!"
else
  puts "It's a tie!"
end