require 'gosu'

### this is the main game window
class Game < Gosu::Window

  GAMETIME = 15 #in seconds
  BALLOONCOUNT = 40

  def initialize
    super 800, 600, false
    self.caption = 'Pop-the-Balloon'
    @car = Car.new(self)  
    @enemy_cars = []
    BALLOONCOUNT.times {|d| @enemy_cars.push Enemy.new(self, 100*rand(5), 100*rand(5) + 400)}
    @counter = 0
    @time_spent = 0
    @time_spent_message = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @time_spent_value = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @balloons_popped_message = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @balloons_popped_count = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @pop_sound = Gosu::Song.new(self, "beep.wav")
    @bg_sound = Gosu::Song.new(self, "laughter.mp3")
    @final_score_msg = Gosu::Image.from_text(self, "Total Balloons popped: #{@counter}", Gosu.default_font_name, 50)
    @message_height = 700 #for message to be invisible at start of game
  end

  def draw
    @car.draw
    @enemy_cars.each {|car| car.draw}
    @time_spent_message.draw("Time Remaining:", 0 , 0, 1)
    @time_spent_value.draw(GAMETIME - @time_spent/60, 150, 0, 1)
    @balloons_popped_message.draw("Balloons Popped:", 0 , 50, 1)
    @balloons_popped_count.draw(@counter, 160 , 50, 1)
    @final_score_msg.draw(200, @message_height, 1)
  end

  def balloon_popped?(obj1, obj2)
    obj1.x > obj2.x - obj1.w and obj1.x < obj2.x + obj2.w and obj1.y > obj2.y - obj1.h and obj1.y < obj2.y + obj2.h
  end

  def update
    @time_spent = @time_spent + 1 if @time_spent/60 < GAMETIME
    if time_up?
      @pop_sound.stop       #stop the pop sound
      @bg_sound.play(true)  #start the game end sound
      @message_height = 250 #set height so that message moves up the screen where it could be seen
    else
      @enemy_cars.each do |balloon| 
        if balloon_popped?(@car, balloon)
          @enemy_cars.delete balloon
          @pop_sound.play

          @counter = @counter + 1
        else
          balloon.update
        end
      end
      if button_down?(Gosu::KbUp)
        @car.move_up
      elsif button_down?(Gosu::KbDown)
        @car.move_down
      elsif button_down?(Gosu::KbLeft)
        @car.move_left
      elsif button_down?(Gosu::KbRight)
        @car.move_right
      end
    end
  end

  def time_up?
    @time_spent/60 == GAMETIME 
  end
end


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


game = Game.new
game.show
