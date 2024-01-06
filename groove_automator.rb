class Pattern
    def initialize(name:, pattern:)
        @index = 0
        @name = name
        @pattern = pattern.each_char.map {|c| c}
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

class Groove
    attr_reader :time_signature, :subdivisions, :tempo,
                :total_measures, :hihat, :snare,
                :kick, :measures

    def initialize(
        time_sig: "4/4",
        subdiv: 16,
        tempo: 80,
        total_measures: 16,
        hihat: "x-x-",
        snare: "----O---",
        kick: "o-------"
    )
        @time_signature = TimeSignature.all[time_sig]

        @subdivisions   = subdiv
        @tempo          = tempo
        @total_measures = total_measures

        @hihat = Pattern.new(name: "Hi-Hat", pattern: hihat)
        @snare = Pattern.new(name: "Snare", pattern: snare)
        @kick  = Pattern.new(name: "Kick", pattern: kick)

        @measures = { hh: "|", sd: "|", kd: "|" }

        total_subdivs = @time_signature.subdivisions_per_measure(@subdivisions)
        raise "No inifinite loops for you!" if @total_measures.nil? or total_subdivs.nil?

        (1..@total_measures).each do
            (1..total_subdivs).each do
                @measures[:hh] += @hihat.next
                @measures[:sd] += @snare.next
                @measures[:kd] += @kick.next
            end

            @measures[:hh] += "|"
            @measures[:sd] += "|"
            @measures[:kd] += "|"
        end
    end

    def URL
        "http://localhost:8080/?" +
        "TimeSig=#{@time_signature.name}&" +
        "Div=#{@subdivisions}&" +
        "Tempo=#{@tempo}&" +
        "Measures=#{@total_measures}&" +
        "H=#{@measures[:hh]}&" +
        "S=#{@measures[:sd]}&" +
        "K=#{@measures[:kd]}"
    end
end

class GrooveBag
    def self.groove_1
        puts Groove.new(
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            total_measures: 16,
            hihat: "s-x-",
            snare: "-gg-O--g-gg-O--g-gg-O--g-gg-O-g",
            kick: "o--o----o--o----o--o----o--o---"
        ).URL
        ""
    end

    def self.groove_2
        puts Groove.new(
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            total_measures: 18,
            hihat: "s-x-",
            snare: "-gg-O--g-gg-O--g-gg-O--g-gg-O---g",
            kick:  "o--o----o--o----o--o----o--o-----"
        ).URL
        ""
    end

    def self.groove_3
        puts Groove.new(
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            total_measures: 16,
            hihat: "s-x-X-x-X-x-X-x-",
            snare: "----O-------O--",
            kick: "o-----o-o------"
        ).URL
        ""
    end

    def self.groove_4
        puts Groove.new(
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            total_measures: 18,
            hihat: "s-x-X-x-X-x-X-x-",
            snare: "----O-------O----",
            kick: "o-----o-o--------"
        ).URL
        ""
    end
end
