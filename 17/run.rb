require_relative '../lib/common'

xrange = ( 282..314 )
yrange = ( -80..-45 )
maxy = nil
hits = {}

(0..xrange.max).each do |xtry|
  (yrange.min..300).each do |ytry| # is there a better bound for yvel max?

    xvel,yvel = xtry,ytry
    p = Point.new(0,0)
    found_match = false
    maxylocal = nil

    loop do
      p.x += xvel
      p.y += yvel
      xvel = xvel > 0 ? xvel - 1 : ( xvel < 0 ? xvel + 1 : xvel )
      yvel -= 1
      maxylocal = p.y if maxylocal.nil? || maxylocal < p.y
      break if p.x > xrange.max || p.y < yrange.min

      if xrange.cover?(p.x) && yrange.cover?(p.y)
        hits[[xtry,ytry]] = true
        found_match = true
        break
      end

    end
    if found_match && ( maxy.nil? || ( maxy < maxylocal) )
      maxy = maxylocal
    end
  end
end

puts "part 1:#{maxy}"
puts "part 2:#{hits.keys.count}"


