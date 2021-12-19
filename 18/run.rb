
# returns hash of
#  :exploded -> true/false depending on whether or not this iteration exploded
#  :value -> resulting value - either after explosion, or, the regular value
#  :left -> first value of the pair that exploded. will try to distribute to 1st left neighbor
#  :right -> last value of the pair that exploded. will try to distribute to 1st right neighbor
def explode( data, depth = 0 )

  #  p "#{data} #{depth}"
  return { :exploded => false, :value => data, :left => nil, :right => nil } if data.is_a?(Integer)
  return { :exploded => true, :value => 0, :left => data[0], :right => data[1] } if depth == 4

  x = data[0]
  y = data[1]

  # try to explode left
  result = explode( x, depth + 1 )
  if result[:exploded]
    return {:exploded => true, :left => result[:left], :right => nil, :value => [ result[:value], left( y, result[:right] )] }
  end

  # no left exploded.  try to explode right
  result = explode( y, depth + 1 )
  if result[:exploded]
    return {:exploded => true, :left => nil, :right => result[:right], :value => [ right( x, result[:left]), result[:value] ] }
  end

  # no explosion
  return { :exploded => false, :right => nil, :left => nil, :value => data }

end


def right(data,value)
  return data if value.nil?
  return data + value if data.is_a?(Integer)
  return [ data[0], right(data[1],value)]
end


def left(data,value)
  return data if value.nil?
  return data + value if data.is_a?(Integer)
  return [ left(data[0],value),data[1]]
end


def split( data )

  if data.is_a?(Integer)
    return {:did_split => true, :value => [(data.to_f/2).floor,(data.to_f/2).ceil]} if data >= 10
    return {:did_split => false, :value => data }
  end

  x,y = data[0],data[1]
  result = split(x)
  return {:did_split => true, :value => [result[:value],y]} if result[:did_split]
  result = split(y)
  return {:did_split => result[:did_split], :value => [x,result[:value]]}
end


def magnitude( data )
  return data if data.is_a?(Integer)
  return magnitude(data.first)*3 + magnitude(data.last)*2
end


def reduce( line )
  loop do
    result = explode(line)
    if result[:exploded]
      line = result[:value]
      next
    end
    result = split(line)
    if result[:did_split]
      line = result[:value]
      next
    end
    break
  end
  line
end


all_lines = ARGF.each_line.map{ |line| eval(line.chomp) }
prev_line = nil
all_lines.each { |line| prev_line = reduce( prev_line ? [prev_line,line] : line ) }
puts "part 1:#{magnitude( prev_line )}"
puts "part 2: #{all_lines.permutation(2).to_a.map { |a,b| magnitude( reduce([a,b]) ) }.max}"

