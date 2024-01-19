require "uri"

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

class GrooveScribeGlyphs
  class Hihat
    HH_NORMAL='x'
    HH_OPEN='o'
    HH_ACCENT='X'
    CRASH='c'
    RIDE='r'
    RIDE_BELL='b'
    COWBELL='m'
    STACKER='s'
    CLICK='n'
    CLICK_ACCENT='N'
  end

  class Snare
    NORMAL='o'
    ACCENT='O'
    GHOST='g'
    CROSS_STICK='x'
    BUZZ='b'
    FLAM='f'
  end

  class Kick
    KICK='o'
    HAT='x'
    BOTH='X'
  end
end

class Groove
  attr_reader :title, :author, :comments, :time_signature,
    :subdivisions, :tempo, :total_measures, :hihat, :snare,
    :kick, :measures

  def initialize(
    title: nil,
    author: nil,
    comments: nil,
    time_sig: "4/4",
    subdiv: 16,
    tempo: 110,
    total_measures: 2,
    hihat: "x-x-",
    snare: "----O---",
    kick: "o-------"
  )
    @title = title
    @author = author
    @comments = comments

    @time_signature = TimeSignature.all[time_sig]
    binding.b

    @subdivisions   = subdiv
    @tempo          = tempo
    @total_measures = total_measures

    @hihat = Pattern.new(name: "Hi-Hat", pattern: hihat)
    @snare = Pattern.new(name: "Snare", pattern: snare)
    @kick  = Pattern.new(name: "Kick", pattern: kick)

    @measures = _generate_measures

    @uri_parser = URI::Parser.new
  end

  def _generate_measures
    total_subdivs = @time_signature.subdivisions_per_measure(@subdivisions)
    raise "No inifinite loops for you!" if @total_measures.nil? or total_subdivs.nil?

    measures = { hh: "|", sd: "|", kd: "|" }

    (1..@total_measures).each do
      (1..total_subdivs).each do
        measures[:hh] += @hihat.next
        measures[:sd] += @snare.next
        measures[:kd] += @kick.next
      end

      measures[:hh] += "|"
      measures[:sd] += "|"
      measures[:kd] += "|"
    end

    measures
  end

  # URL encode for GrooveScribe
  def URL_encode(qs_key, encodee)
    return "" if encodee.nil? or encodee.strip.empty?
    "#{qs_key}=#{@uri_parser.escape(encodee)}&"
  end

  def URL
    "http://localhost:8080/?" +
      "TimeSig=#{@time_signature.name}&" +
      "Div=#{@subdivisions}&" +
      URL_encode("Title", @title) +
      URL_encode("Author", @author) +
      URL_encode("Comments", @comments) +
      "Tempo=#{@tempo}&" +
      "Measures=#{@total_measures}&" +
      "H=#{@measures[:hh]}&" +
      "S=#{@measures[:sd]}&" +
      "K=#{@measures[:kd]}"
  end

  def remove_kick_on_snare
    snare_glyphs = [
      GrooveScribeGlyphs::Snare::NORMAL,
      GrooveScribeGlyphs::Snare::ACCENT,
      GrooveScribeGlyphs::Snare::CROSS_STICK,
      GrooveScribeGlyphs::Snare::FLAM
    ]

    kick_glyphs = [
      GrooveScribeGlyphs::Kick::KICK,
      GrooveScribeGlyphs::Kick::BOTH
    ]

    snare_hits = @measures[:sd].chars
    kicks = @measures[:kd].chars
    new_kicks = ""

    binding.b #DELETEME
    snare_hits.each_with_index do |sd_glyph, idx|
      kd_glyph = kicks[idx]

      new_kicks +=
        (snare_glyphs.include?(sd_glyph) and
        kick_glyphs.include?(kd_glyph)) ?
        '-' :
        kicks[idx]

      @measures[:kd] = new_kicks

      self
    end

  end
end

class GrooveBag
  def self.groove_2a
    puts Groove.new(
      title: "Modulation Etude #2.a",
      author: "Stick Twisters",
      comments: "A sinistra",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 32,
      hihat: "s-x-X-x-X-x-X-x-",
      snare: "----O-------O---|----O-------O--",
      kick:  "o-----o-o-------|o-----o-o------"
    ).URL
    ""
  end

  def self.groove_2b
    puts Groove.new(
      title: "Modulation Etude #2.b",
      author: "Stick Twisters",
      comments: "A destra",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 34,
      hihat: "s-x-X-x-X-x-X-x-",
      snare: "----O-------O---|----O-------O---|-",
      kick:  "o-----o-o-------|o-----o-o-------|-"
    ).URL
    ""
  end

  def self.groove_69a
    puts Groove.new(
#      title: "Modulation Etude #69.a",
#      author: "Stick Twisters",
#      comments: "A sinistra",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 16,
      hihat: "s-x-",
      snare: "-gg-O--g-gg-O--g|-gg-O--g-gg-O-g",
      kick:  "o--o----o--o----|o--o----o--o---"
    ).URL
    ""
  end

  def self.groove_69b
    puts Groove.new(
#      title: "Modulation Etude #69.a",
#      author: "Stick Twisters",
#      comments: "A destra",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 18,
      hihat: "s-x-",
      snare: "-gg-O--g-gg-O--g|-gg-O--g-gg-O---g",
      kick:  "o--o----o--o----|o--o----o--o-----"
    ).URL
    ""
  end

  def self.groove_345a
    puts Groove.new(
      title: "Groove 3-4-5a",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 15,
      hihat: "b-r-r",
      snare: "----O---",
      kick:  "X--ox-o-xo--"
    ).URL
    ""
  end

  def self.groove_345b
    puts Groove.new(
      title: "Groove 3-4-5b",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 15,
      hihat: "b-rr-",
      snare: "----O---",
      kick:  "X--ox-o-xo--"
    ).URL
    ""
  end

  def self.groove_345c
    puts groove.new(
      title: "groove 3-4-5c",
      author: "stick twisters",
      comments: "contorto come un vecchio albero",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 15,
      hihat: "r-b-",
      snare: "-gg-o",
      kick:  "x--ox-o-xo--"
    ).remove_kick_on_snare.url
    ""
  end

  def self.groove_bd_in_9_44
    puts Groove.new(
      title: "Groove with 9 figure in RF in 4/4",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 18,
      hihat: "Xxxx",
      snare: "----O---",
      kick:  "o---oo---"
    ).URL
    ""
  end

  def self.groove_bd_in_9_94
    puts Groove.new(
      title: "Groove with 9 figure in RF in 4/4",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "9/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 2,
      hihat: "Xxxx",
      snare: "----O---",
      kick:  "o---oo---"
    ).URL
    ""
  end
end
