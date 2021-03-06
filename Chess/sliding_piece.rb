class SlidingPiece < Piece
  def generate_dirs(dir) #Generate movement deltas
    dirs = []
    (1..7).each do |n|
      dir.permutation(2).to_a.uniq.map { |dir| dirs << [dir[0]*n,dir[1]*n]}
    end
    dirs
  end

  def diagonal_dirs
    generate_dirs([1,1,-1,-1])
  end

  def horizontal_dirs
    generate_dirs([1,-1,0]).select { |dir| dir[1] == 0}
  end

  def vertical_dirs
    generate_dirs([1,-1,0]).select { |dir| dir[0] == 0}
  end

  def filter_unblocked(moves)
    unblocked = []
    moves.each do |move|
      x, y = move
      if @board.empty?(x,y) || @board.enemy?(x, y, color) #Target square is valid
        unblocked << move if open_path?(move) #All squares in between are empty?
      end
    end
    unblocked
  end

  #Returns a boolean of whether a piece can move from its current position to the end position (end_pos)
  def open_path?(end_pos)
    pos = [@position, end_pos].sort
    x1, y1 = pos[0]
    x2, y2 = pos[1]
    x_diff = x2 - x1
    y_diff = y2 - y1

    if x_diff != 0 && y_diff != 0 # Scanning diagonal move path
      (1..x_diff - 1).each do |delta|
        x = x1 + delta
        y_diff > 0? (y = y1 + delta):(y = y1 - delta) #Determine diagonal directionality
        return false unless @board.empty?(x,y)
      end
    elsif x_diff != 0 # Scanning horizontal move path
      (x1 + 1...x2).each { |x| return false unless @board.empty?(x, y1) }
    elsif y_diff != 0 # Scanning vertical move path
      (y1 + 1...y2).each { |y| return false unless @board.empty?(x1, y) }
    end

    true
  end
end
