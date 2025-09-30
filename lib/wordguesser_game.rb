class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(new_word, guesses = '', wgl = [], gl= [], wwg = "-",win = :play, count = 0)
    @word = new_word
    @guesses = guesses
    @guess_list = gl
    @wrong_guesses = wgl
    @word_with_guesses = wwg * word.length
    @check_win_or_lose = win
    @count = count
  end
  attr_accessor :word, :guesses, :wrong_guesses, :guess_list, :wrong_guess_list, :word_with_guesses, :check_win_or_lose, :count
  
  def guess(guess)
    if guess == '' or guess == nil  or not(guess.match?(/[A-Z,a-z]/))
      raise ArgumentError
    end
    if not(self.guesses.include?(guess) or self.wrong_guesses.include?(guess))
      self.count+=1
    end
    if self.count == 7
      self.check_win_or_lose = :lose
    end
    for i in self.guess_list do
      if i.downcase == guess.downcase
        return true
      end
    end
    for i in self.wrong_guesses do
      if i.downcase == guess.downcase
        return true
      end
    end
    if word.include?(guess)
      self.guesses = guess
      self.guess_list.push(guess)
      for i in 0..self.word.length do
        if self.word[i] == guess
          self.word_with_guesses[i] = self.word[i]
        end
      end
      if self.word == self.word_with_guesses
        self.check_win_or_lose = :win
      end
      return false
    elsif not(word.include?(guess))
      self.wrong_guesses.push(guess)
      return false 
    end
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
