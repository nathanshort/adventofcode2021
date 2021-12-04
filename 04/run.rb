#!/usr/bin/env ruby

class Board

    @@rcount, @@ccount = 5,5
    
    def initialize(data)
      @by_spot = {}
      @by_position = {}
      @marks = {}
       
      data.split(/\n/).each_with_index do |row,rindex|
        row.scan(/\d+/).each_with_index do |col,cindex|
         position = "#{rindex},#{cindex}"
         spot = col.to_i
         @by_spot[spot] = position
         @by_position[position] = spot
        end
      end
   end

   def mark( spot )
     @marks[@by_spot[spot]] = true if @by_spot.key?( spot )
   end

   def score
    sum = 0
    @@rcount.times.each do |row|
      @@ccount.times.each do |col|
        key = "#{row},#{col}"
        sum += @by_position[key] if ! @marks.key?( key )
      end
    end  
    sum
   end

   def scan
    @@rcount.times.each do |i1|
      marks_i1, marks_i2 = 0,0  
      @@ccount.times.each do |i2|     
        i1key, i2key = "#{i1},#{i2}", "#{i2},#{i1}"
        marks_i1 += 1 if @marks.key?( i1key )
        marks_i2 += 1 if @marks.key?( i2key )
        return true if ( marks_i1 == @@rcount || marks_i2 == @@ccount )
      end
    end
  false
end
end

calls, *b = ARGF.read.split(/\n\n/)
calls = calls.split(',').map{ |x| x.to_i }
boards = b.map { |bb| Board.new( bb ) }

winning_scores = []
winners = {}
calls.each do |spot|    
  boards.each do |board|
  next if winners.key?(board) 
  board.mark( spot )
  if board.scan
    score = board.score * spot
    winning_scores << score
    winners[board] = true
  end
 end
end

puts "part 1:#{winning_scores.first}"
puts "part 1:#{winning_scores.last}"



