class Pattern
  def initialize(name:, pattern:)
    @index = 0
    @name = name
    @pattern = pattern.delete('|').chars
  end

  def next
    retval = @pattern[@index]
    @index = next_index
    retval
  end

  def next_index
    n_idx = @index + 1
    n_idx < @pattern.length ? n_idx : 0
  end
end
