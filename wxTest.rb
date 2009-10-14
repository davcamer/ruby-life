require "wx"
include Wx

class Population
  def initialize
    @cellStates = [ 0, 0, 1, 1, 1, 0, 0, 0, 1 ]
  end
  
  def draw(dc)
    dc.set_brush GREEN_BRUSH
    @cellStates.each_index do |i|
      if @cellStates[i] == 1
        dc.draw_rectangle 100 + (i % 3) * 10, 100 + (i / 3) * 10, 10, 10 
      end
    end    
  end
end

class MinimalApp < App
  
  def on_init
    window = Frame.new(nil, -1, "My Test App")
    @population = Population.new
    window.evt_paint do |paintEvent|
      window.paint do |dc|
        @population.draw(dc)
      end
    end
    window.show()
  end
end


MinimalApp.new.main_loop
