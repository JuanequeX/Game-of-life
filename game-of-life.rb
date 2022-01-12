require 'ruby2d'

# Title of the screen and background color
set title: "Game of life by juanequex"
set background: 'gray'

# Width and height at screen to play the game
SCREEN_SIZE = 40
set width: SCREEN_SIZE * 20
set height: SCREEN_SIZE * 15


# Class to draw th grid in the scree to print each cells
class Grid
  def initialize
    # Hash variable to put in it the coodinates to show a cell live in the grid
    @grid = {}
    @playing = false
  end

  # Metho to clear the display after match a game
  def clear
    @grid = {}
  end

  # Methos to play and pause the game
  def play_pause
   @playing = !@playing
  end

  def draw_lines
    # Vertical draw lines
    (Window.width / SCREEN_SIZE).times do |x|
      Line.new(
        width: 1,
        color: 'white',
        y1: 0,
        y2: Window.height,
        x1: x * SCREEN_SIZE,
        x2: x * SCREEN_SIZE,
      )

      # Horizontal draw lines
      (Window.height / SCREEN_SIZE).times do |y|
        Line.new(
          height: 1,
          color: 'white',
          x1:  0,
          x2: Window.width,
          y1: y * SCREEN_SIZE,
          y2: y * SCREEN_SIZE,
        )
      end
    end

    def toggle(x,y)
      if @grid.has_key?([x,y])
        # Dead cell that are lived
        @grid.delete([x,y])
      else
        # Able a live cell in a specific coordinates
        @grid[[x,y]] = true
      end
    end

    def draw_alive_cell
      @grid.keys.each do |x,y|
        Square.new(
          color: 'red',
          x: x * SCREEN_SIZE,
          y: y * SCREEN_SIZE,
          size: SCREEN_SIZE
        )
      end
    end

    def advance_frame
      if @playing
        new_grid = {}

        (Window.width / SCREEN_SIZE).times do |x|
          (Window.height / SCREEN_SIZE).times do |y|
            alive = @grid.has_key?([x,y])

            alive_neightbours = [
              @grid.has_key?([x-1, y-1]), # Top left
              @grid.has_key?([x, y-1]), # Top
              @grid.has_key?([x+1, y-1]), # Top Right
              @grid.has_key?([x+1, y ]), # Right
              @grid.has_key?([x+1, y+1]), # Bottom right
              @grid.has_key?([x, y+1]), # Bottom
              @grid.has_key?([x-1, y+1]), # Bottom left
              @grid.has_key?([x-1, y]) # Left
            ].count(true)

            if((alive && alive_neightbours.between?(2,3)) || (!alive && alive_neightbours == 3))
              new_grid[[x,y]] = true
            end
          end
        end
        @grid = new_grid
      end
    end
  end
end

# Draw grid
grid = Grid.new

update do
  clear
  grid.draw_lines
  grid.draw_alive_cell

  # Animation of the game
  if Window.frames % 40 == 0
    grid.advance_frame
  end

end

on :mouse_down do |event|
  grid.toggle(event.x / SCREEN_SIZE, event.y / SCREEN_SIZE)
end

on :key_down do |event|
  if event.key == 'p'
    grid.play_pause
  end

  if event.key == 'c'
    grid.clear
  end
end


show
