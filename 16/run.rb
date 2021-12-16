

def run(packet)

  version = packet[0,3].to_i(2)
  type = packet[3,3].to_i(2)
  value = 0
  current = 6

  if type == 4 # literal
    data = ""
    loop do
      slice = packet[current,5]
      data << slice[1,4]
      current += 5 
      break if slice[0] != '1'
    end
    value = data.to_i(2)
  else # operator
    values = []
    length = packet[6,1].to_i(2)

    if length == 0
      sub_packet_length = packet[7,15].to_i(2)
      current = 7+15
      target = current + sub_packet_length
      while current < target 
        result = run(packet[current..])
        current += result[:parsed_length]
        values << result[:value]
        version += result[:version]
      end
    else
      sub_packet_count = packet[7,11].to_i(2)
      current = 7+11
      sub_packet_count.times do
        result = run(packet[current..])
        current += result[:parsed_length]
        values << result[:value]
        version += result[:version]
      end
    end

    value =
      case type
      when 0
        values.sum
      when 1
        values.reduce(:*)
      when 2
        values.min
      when 3
        values.max
      when 5
        values[0] > values[1] ? 1 : 0
      when 6
        values[0] < values[1] ? 1 : 0
      when 7
        values[0] == values[1] ? 1 : 0
      end
  end
  
  { :version => version, :value => value, :parsed_length => current }
end

puts run( ARGF.read.chomp.chars.reduce(""){ |memo,c| memo + sprintf( '%04b', c.to_i(16) )} )
