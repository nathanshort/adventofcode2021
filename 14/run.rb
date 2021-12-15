
def score( pair2counts, template )
    by_char = Hash.new(0)
    pair2counts.each { |pair,count| by_char[pair[0]] += count }
    
    # fencepost - we never counted the last char in the template
    # luckily, it will always be the same
    by_char[template.chars.last] += 1
    by_char.values.max - by_char.values.min
end

template, inst = ARGF.read.split(/\n\n/)
instructions = {}
inst.split(/\n/).each do |i|
  pair,replace = i.scan(/\w+/)
  instructions[pair] = replace
end

# seed counts for the initial template. this keeps 
# track of the number of pairs in the current template
# ie, NB => 2, BC => 3, etc 
# when we score, we will sum the count of the first char
# in each pair
pair2counts = Hash.new(0)
(template.length-1).times { |iter| pair2counts[template[iter..iter+1]] += 1 }

40.times do |iter|
  new_pair2counts = Hash.new(0)
  pair2counts.each do |pair,count|
    insert = instructions[pair]
    new_pair2counts["#{pair[0]}#{insert}"] += count
    new_pair2counts["#{insert}#{pair[1]}"] += count
  end
  pair2counts = new_pair2counts
  puts "part 1:#{score(pair2counts,template) }" if iter == 9
  puts "part 2:#{score(pair2counts,template) }" if iter == 39
end
