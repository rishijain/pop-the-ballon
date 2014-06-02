#### Car is class is meant to be pin
#### will have to change image to image of a pin
#### will eventually change name of class
class Car
  attr_reader :x, :y, :w, :h

  def initialize(window)
    @x = 600
    @y = 400
    @w = 10
    @h = 20
    @image = Gosu::Image.new(window, 'pin.png', false)
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  def move_up
    @y = @y - 10
  end

  def move_down
    @y = @y + 10
  end

  def move_left
    @x = @x - 10
  end

  def move_right
    @x = @x + 10
  end
end
