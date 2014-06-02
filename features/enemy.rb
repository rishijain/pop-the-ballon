#### Enemy class is here meant to be balloons which needs to be popped
#### Will change it to Balloon eventually
class Enemy
  attr_reader :x, :y, :w, :h

  def initialize(window, x, y)
    @x = x
    @y = y
    @w = 10
    @h = 20
    @image = Gosu::Image.new(window, 'red-balloon.png', false)
  end

  def update
    @y = @y - 2
  end

  def draw
    @image.draw(@x, @y, 1)
  end
end
