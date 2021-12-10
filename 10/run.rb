
opening = %w/ [ ( { < /
closing = %w/ ] ) } > /
badscoring = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
autoscoring = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }

badscore = 0  
autoscores = []
ARGF.each_line do |line|
    stack = []
    goodline = true
    line.chomp.chars.each do |c|
      if opening.index(c)
        stack.push(c)
      else
        existing = stack.pop
        if ! existing || opening.index(existing) != closing.index(c)
          badscore += badscoring[c]
          goodline = false
          break
        end
      end
    end
    autoscores << stack.reverse.each.reduce(0){|memo,c| memo*5 + autoscoring[c] } if goodline
end

puts "part 1:#{badscore}"
puts "part 2:#{autoscores.sort[autoscores.count/2]}"