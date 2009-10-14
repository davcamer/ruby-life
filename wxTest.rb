require "wx"
include Wx

class Population
  def initialize
    @cellStates = [ 0, 0, 0, 1, 1, 1, 0, 0, 0 ]
  end
  
  def draw(dc)
    dc.set_brush GREEN_BRUSH
    @cellStates.each_index do |i|
      if @cellStates[i] == 1
        draw_them_green dc, i
      else
        draw_them_red dc, i
      end
    end    
  end
  
  def draw_them_green(dc, i)
    dc.set_brush GREEN_BRUSH
    dc.draw_rectangle 100 + (i % 3) * 10, 100 + (i / 3) * 10, 10, 10 
  end
  
  def draw_them_red(dc, i)
    dc.set_brush RED_BRUSH
    dc.draw_rectangle 100 + (i % 3) * 10, 100 + (i / 3) * 10, 10, 10 
  end
  
  def iterate
    output = Array.new
    [0, 1, 2].each do |y|
      [0, 1, 2].each do |x|
        neighbours = 0
        [-1, 0, 1].each do |delta_y|
          neighbour_y = y + delta_y
          unless neighbour_y < 0 or neighbour_y > 2
            [-1, 0, 1].each do |delta_x|
              neighbour_x = x + delta_x
              unless neighbour_x < 0 or neighbour_x > 2 or (delta_x == delta_y && delta_x == 0)
                neighbours += @cellStates[neighbour_y * 3 + neighbour_x]
              end
            end
          end
        end
        if neighbours == 2
          new_state = @cellStates[y * 3 + x]
        elsif neighbours == 3
          new_state = 1
        else
          new_state = 0
        end
        puts "x: " + x.to_s + " y: " + y.to_s + " neighbours: " + neighbours.to_s + " new_state: " + new_state.to_s
        output[y * 3 + x] = new_state
      end
    end
    @cellStates = output
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
    Timer.every(1000) do
      puts "tick"
      @population.iterate
      window.refresh
    end
  end
end
  
MinimalApp.new.main_loop