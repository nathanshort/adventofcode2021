
connections = Hash.new{|h,k| h[k] = []}
ARGF.each_line do |line|
    a,b = line.chomp.split('-')
    connections[a] << b
    connections[b] << a
end

def dfs( connections, current, target, can_visit, visited=nil, path=nil, all_paths=nil )
    
    all_paths ||= []
    path ||= []
    visited ||= Hash.new(0)

    visited[current] += 1
    path << current

    if current == target
      all_paths << path.dup
    else
      connections[current].each {|c| dfs( connections, c, target, can_visit, visited, path, all_paths ) if can_visit.call( visited, c ) }    
    end

    path.pop
    visited[current] -= 1 
    all_paths 
end

can_visit1 = lambda{ |visited,c| !visited.key?(c) || visited[c] == 0 || c.upcase == c }
all_paths1 = dfs( connections, 'start', 'end', can_visit1 )
                 
can_visit2 = lambda{ |visited,c| !visited.key?(c) || visited[c] == 0 || c.upcase == c || 
                    ( ! ['start'].index(c) && visited.count{|k,v| k.downcase == k && v > 1 } == 0 ) }
all_paths2 = dfs( connections, 'start', 'end', can_visit2 )
                 
puts "part 1:#{all_paths1.count}"
puts "part 2:#{all_paths2.count}"
