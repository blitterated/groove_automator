require "uri"

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
