require "wx"
include Wx

class Population
  def initialize
    @size_x = @size_y = 7
    @state = PopulationState.new @size_x, @size_y
    mid_y = @size_y / 2
    @state.each_cell do |x, y|
      @state[x, y] = y == mid_y ? 1 : 0
    end
  end
  
  def draw(dc)
    @state.each_cell_with_state do |x, y, state|
      if state == 1
        draw_them_green dc, x, y
      else
        draw_them_red dc, x, y
      end
    end    
  end
  
  def draw_them_green(dc, x, y)
    draw_cell dc, x, y, GREEN_BRUSH
  end
  
  def draw_them_red(dc, x, y)
    draw_cell dc, x, y, RED_BRUSH
  end
  
  def draw_cell(dc, x, y, brush)
    dc.set_brush brush
    dc.draw_rectangle 100 + x * 10, 100 + y * 10, 10, 10 
  end
  
  def iterate
    output = PopulationState.new @size_x, @size_y
    @state.each_cell do |x, y|
      neighbours = 0
      @state.each_neighbour(x, y) do |cellState|
        neighbours += cellState
      end
      if neighbours == 2
        new_state = @state[x, y]
      elsif neighbours == 3
        new_state = 1
      else
        new_state = 0
      end
      puts "x: " + x.to_s + " y: " + y.to_s + " neighbours: " + neighbours.to_s + " new_state: " + new_state.to_s
      output[x, y] = new_state
    end
    @state = output
    puts @state.cellStates
  end
end

class PopulationState
  def initialize size_x, size_y, initialStates = nil
    @cellStates = initialStates || []
    @size_x = size_x
    @size_y = size_y
  end
  
  def [](x, y)
    @cellStates[y * @size_x + x]
  end
  
  def []=(x, y, value)
    @cellStates[y * @size_x + x] = value
  end
  
  def each_cell
    (0...@size_y).each do |y|
      (0...@size_x).each do |x|
        yield x, y
      end
    end
  end
  
  def each_cell_with_state
    each_cell { |x, y| yield x, y, self[x, y] }
  end
  
  def each_neighbour x, y
    [-1, 0, 1].each do |delta_y|
      neighbour_y = y + delta_y
      unless neighbour_y < 0 or neighbour_y >= @size_y
        [-1, 0, 1].each do |delta_x|
          neighbour_x = x + delta_x
          unless neighbour_x < 0 or neighbour_x >= @size_x or (delta_x == delta_y && delta_x == 0)
            yield self[neighbour_x, neighbour_y]
          end
        end
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
    Timer.every(1000) do
      puts "tick"
      @population.iterate
      window.refresh
    end
  end
end
  
MinimalApp.new.main_loop