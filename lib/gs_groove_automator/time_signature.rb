class TimeSignature
  attr_reader :name, :beats_per_measure, :beat_note

  def initialize(beats_per_measure: 4, beat_note: 4)
    @name = "#{beats_per_measure}/#{beat_note}"
    @beats_per_measure = beats_per_measure
    @beat_note = beats_per_measure
  end

  def subdivisions_per_measure(subdiv)
    (subdiv / @beat_note) * @beats_per_measure
  end

  def self.all
    return @_all_time_signatures if defined? @_all_time_signatures
    self.build_all
  end

  # Builds a hash of all time signatures available in GrooveScribe.
  # Can also be used to invalidate memoized value in TimeSignature#all
  def self.build_all
    @_all_time_signatures =
      (2..15).to_a
      .product([2,4,8,16])
      .map { |b,n| TimeSignature.new(beats_per_measure: b, beat_note: n) }
      .map { |ts| [ts.name, ts] }
      .to_h
  end
end
