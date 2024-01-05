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

    # builds a hash of all time signatures available in GrooveScribe
    def self.build_all
        (2..15).to_a
            .product([2,4,8,16])
            .map { |b,n| TimeSignature.new(beats_per_measure: b, beat_note: n) }
            .map { |ts| [ts.name, ts] }
            .to_h
    end
end

require "ostruct"

class Grooves
    def initialize
        @time_signatures = TimeSignature.build_all
    end

    def groove_1
        groove = OpenStruct.new({
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            measures: 16,
            hh: "s-x-",
            sn: "-gg-O--g-gg-O--g-gg-O--g-gg-O-g",
            kd: "o--o----o--o----o--o----o--o---"
        })

        high_hat_pattern =   Pattern.new(name: "Hi-Hat", pattern: groove.hh)
        snare_drum_pattern = Pattern.new(name: "Snare", pattern: groove.sn)
        kick_drum_pattern =  Pattern.new(name: "Kick", pattern: groove.kd)

        measures = OpenStruct.new({
            hh: "|",
            sd: "|",
            kd: "|"
        })

        ts = @time_signatures[groove.time_sig]

        (1..groove.measures).each do
            (1..ts.subdivisions_per_measure(groove.subdiv)).each do
                measures.hh += high_hat_pattern.next
                measures.sd += snare_drum_pattern.next
                measures.kd += kick_drum_pattern.next
            end

            measures.hh += "|"
            measures.sd += "|"
            measures.kd += "|"
        end

        "http://localhost:8080/?" +
        "TimeSig=#{groove.time_sig}&" +
        "Div=#{groove.subdiv}&" +
        "Tempo=#{groove.tempo}&" +
        "Measures=#{groove.measures}&" +
        "H=#{measures.hh}&" +
        "S=#{measures.sd}&" +
        "K=#{measures.kd}"
    end

    def groove_2
        groove = OpenStruct.new({
            time_sig: "4/4",
            subdiv: 16,
            tempo: 80,
            measures: 18,
            hh: "s-x-",
            sn: "-gg-O--g-gg-O--g-gg-O--g-gg-O---g",
            kd: "o--o----o--o----o--o----o--o-----"
        })

        high_hat_pattern =   Pattern.new(name: "Hi-Hat", pattern: groove.hh)
        snare_drum_pattern = Pattern.new(name: "Snare", pattern: groove.sn)
        kick_drum_pattern =  Pattern.new(name: "Kick", pattern: groove.kd)

        measures = OpenStruct.new({
            hh: "|",
            sd: "|",
            kd: "|"
        })

        ts = @time_signatures[groove.time_sig]

        (1..groove.measures).each do
            (1..ts.subdivisions_per_measure(groove.subdiv)).each do
                measures.hh += high_hat_pattern.next
                measures.sd += snare_drum_pattern.next
                measures.kd += kick_drum_pattern.next
            end

            measures.hh += "|"
            measures.sd += "|"
            measures.kd += "|"
        end

        "http://localhost:8080/?" +
        "TimeSig=#{groove.time_sig}&" +
        "Div=#{groove.subdiv}&" +
        "Tempo=#{groove.tempo}&" +
        "Measures=#{groove.measures}&" +
        "H=#{measures.hh}&" +
        "S=#{measures.sd}&" +
        "K=#{measures.kd}"
    end
end
