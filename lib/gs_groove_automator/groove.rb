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

    @subdivisions   = subdiv
    @tempo          = tempo
    @total_measures = total_measures

    @hihat = Pattern.new(name: "Hi-Hat", pattern: hihat)
    @snare = Pattern.new(name: "Snare", pattern: snare)
    @kick  = Pattern.new(name: "Kick", pattern: kick)

    @measures = _generate_measures
  end

  private def _generate_measures
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

  def remove_kick_on_snare
    sn = ABCGlyphs.snare
    snare_glyphs = [
      sn.normal,
      sn.accent,
      sn.cross_stick,
      sn.flam
    ]

    p = ABCGlyphs.pedal
    kick_glyphs = [p.kick, p.both]

    snare_hits = @measures[:sd].chars
    kicks = @measures[:kd].chars
    new_kicks = ""

    snare_hits.each_with_index do |sd_glyph, idx|
      kd_glyph = kicks[idx]

      new_kicks +=
        (snare_glyphs.include?(sd_glyph) and
        kick_glyphs.include?(kd_glyph)) ?
        '-' :
        kicks[idx]

      @measures[:kd] = new_kicks
    end
    self
  end
end
