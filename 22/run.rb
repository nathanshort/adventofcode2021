
class CRange

  attr_reader :x1,:x2,:y1,:y2,:z1,:z2

  def initialize( range )
    @x1,@x2,@y1,@y2,@z1,@z2 = range
  end
end


class Cuboid

  def initialize( range )
    @range = range
    @cutouts = []
  end

  # given 2 coords like  [10,13], [9,11]
  # returns where they intersect ( [10,11] ) or nil
  def self.intersect( p11,p12,p21,p22 )
    return nil if p21 > p12 or p11 > p22
    return [p11, p12, p21, p22].sort[1,2]
  end

  def subtract( orange )

    cutouts = 
      [ Cuboid::intersect( @range.x1, @range.x2, orange.x1, orange.x2 ),
        Cuboid::intersect( @range.y1, @range.y2, orange.y1, orange.y2 ),
        Cuboid::intersect( @range.z1, @range.z2, orange.z1, orange.z2 ) ]
    return nil if cutouts.any?{ |x| x.nil? }

    cutout_bounds = CRange.new( cutouts.flatten )
    @cutouts.each { |c| c.subtract( cutout_bounds )}
    @cutouts << Cuboid.new( cutout_bounds )
  end

  def volume
    ( @range.x2 - @range.x1 + 1) * ( @range.y2 - @range.y1 + 1) * ( @range.z2 - @range.z1 + 1 ) -
      @cutouts.sum { |c| c.volume }
  end

end


cuboids = []
ARGF.each_line do |line|
  crange = CRange.new( line.chomp.scan(/-?\d+/).map(&:to_i) )
  onoff = line.split(/\s/)[0]
  cuboids.each { |c| c.subtract( crange ) }
  cuboids << Cuboid.new( crange ) if onoff == 'on'
end

p cuboids.map( &:volume).sum

