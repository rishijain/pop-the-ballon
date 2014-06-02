require 'gosu'
require_relative 'features/car'
require_relative 'features/enemy'
require_relative 'constant'

### this is the main game window
class Game < Gosu::Window

  def initialize
    super 800, 600, false
    self.caption = 'Pop-the-Balloon'
    @car = Car.new(self)  
    xy_values = []
    BALLOONFRAMES.times do |d|
      xy_values.push([100, 400 + d*200], [200,300 + d*200], [300, 200 +d*200], [400, 100 + d*200], [500, 200 + d*200], [600, 300 +d*200], [700, 400+d*200])
    end
    @enemy_cars = []
    xy_values.each{|d| @enemy_cars.push Enemy.new(self, d[0], d[1])}
    @counter = 0
    @time_spent = 0
    @time_spent_message = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @time_spent_value = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @balloons_popped_message = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @balloons_popped_count = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @pop_sound = Gosu::Song.new(self, "beep.wav")
    @bg_sound = Gosu::Song.new(self, "laughter.mp3")
    @final_score_msg = Gosu::Image.from_text(self, "GAME OVER !!!", Gosu.default_font_name, 50)
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
    x_dist = (obj1.x - obj2.x) 
    y_dist = (obj1.y - obj2.y) 
    (x_dist >= 0.0 and x_dist <= 20.0) and (y_dist >= 0.0 and y_dist <= 45.0)
  end

  def update
    @time_spent = @time_spent + 1 if @time_spent/60 < GAMETIME
    if time_up?
      @pop_sound.stop       #stop the pop sound
      #@bg_sound.play(true)  #start the game end sound
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

game = Game.new
game.show
