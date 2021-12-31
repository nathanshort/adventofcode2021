require_relative '../lib/pqueue'

$destinations = { 'A' => 2, 'B' => 4, 'C' => 6, 'D' => 8 }
$destination_indexes = $destinations.values
$costs = {'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }

# this is horribly inefficient - using arrays for all of the moves. prob could find a better encoding
# that avoids all the array copy overhead, but .. who cares
def get_possible_moves( slots )

  next_moves, next_costs = [],[]

  slots.each_with_index do |slot,index|

    next if slot.empty?
    my_char = slot.first

    next if $destinations[my_char] == index && slot.all?{ |x| x == my_char }

    # we are not at a destination index, and, we are not empty.
    # the only legal move is to our destination index
    if ! $destination_indexes.index( index )
      my_destination = $destinations[my_char]

      # someone else is in my destination.  cant move there yet
      next if slots[my_destination].any?{ |s| s != my_char }

      min,max = [my_destination, index ].minmax

      # there isn't a path to move to the destination - its blocked
      next if ( (min..max).to_a - $destination_indexes ).any?{ |x| x!=min && x!=max && ! slots[x].empty? }

      new_slots = Marshal.load(Marshal.dump(slots))
      to_move = new_slots[index].shift
      moves = max - min + ( $depth - new_slots[my_destination].count )
      cost = $costs[my_char] * moves
      new_slots[my_destination].unshift(to_move)
      next_moves << new_slots
      next_costs << cost
    else

      # find all moves to the left
      (0..(index-1)).to_a.reverse.each do |next_left|

        # cant stop directly above a destination
        next if $destination_indexes.index(next_left)

        # cant go any further if this slot is occupied
        break if ! slots[next_left].empty?

        new_slots = Marshal.load(Marshal.dump(slots))
        moves = index - next_left + ( $depth - new_slots[index].count + 1 )
        to_move = new_slots[index].shift
        cost = $costs[my_char] * moves
        new_slots[next_left].unshift(to_move)
        next_moves << new_slots
        next_costs << cost
      end
    end

    # find all moves to the right
    (index+1..slots.count-1).each do |next_right| 

      # cant stop directly above a destination
      next if $destination_indexes.index(next_right)

      # cant go any further if this slot is occupied
      break if ! slots[next_right].empty?

      new_slots = Marshal.load(Marshal.dump(slots))
      moves = next_right - index + ( $depth - new_slots[index].count + 1 )
      to_move = new_slots[index].shift
      cost = $costs[my_char] * moves
      new_slots[next_right].unshift(to_move)
      next_moves << new_slots
      next_costs << cost
    end

  end

  [next_moves,next_costs]
end



def find_path( start, target )

  visited, distances, prev = {},{},{}
  pq = PQueue.new {|x,y| distances[x] < distances[y] }

  pq.push( start )
  visited[ start ] = true
  distances[ start ] = 0

  while ! pq.empty?
    current = pq.pop
    visited[current] = true

    next_moves,next_costs = get_possible_moves( current )
    next_moves.each_with_index do |m,i| 
      next if visited.key?(m)
      distance = next_costs[i] + distances[current] 
      if ! distances.key?(m) || distances[m] > distance
        distances[m] = distance
        prev[m] = [current,distance]
        pq.push(m)
      end
    end
  end

  prev[target]
end


$depth = 2
start = [[],[],['A','B'],[],['D','C'],[], ['A','D'],[],['B','C'],[],[]]
target = [[],[],['A','A'],[],['B','B'],[], ['C','C'],[],['D','D'],[],[]]
p find_path( start, target )


$depth = 4
start = [[],[],['A','D','D','B'],[],['D','C','B','C'],[], ['A','B','A','D'],[],['B','A','C','C'],[],[]]
target = [[],[],['A','A', 'A','A'],[],['B','B','B','B'],[], ['C','C','C','C'],[],['D','D','D','D'],[],[]]
p find_path( start, target )
