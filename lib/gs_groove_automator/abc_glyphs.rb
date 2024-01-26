#const ABCGlyphs =
#  Struct.new("ABCGlyphs", :hihat, :cymbal, :perc, :snare, :pedal, :tom1, :tom2, :sticking)

class ABCGlyphs

  @@glyph_tree = {
    hihat: -> {
      return @@hihat if defined? @@hihat
      @@hihat = {
        normal: "x".freeze,
        open:   "o".freeze,
        accent: "X".freeze
      }.then do |h|
        Struct.new("ABCHiHatGlyphs", *h.keys).new(**h)
      end
    },
    cymbal: -> {
      return @@cymbal if defined? @@cymbal
      @@cymbal = {
        crash: "c".freeze,
        ride: "r".freeze,
        bell: "b".freeze
      }.then do |c|
        Struct.new("ABCCymbalGlyphs", *c.keys).new(**c)
      end
    },
    perc: -> {
      return @@perc if defined? @@perc
      @@perc = {
        cowbell: "m".freeze,
        stacker: "s".freeze,
        click: "n".freeze,
        click_accent: "N".freeze
      }.then do |p|
        Struct.new("ABCPercussionGlyphs", *p.keys).new(**p)
      end
    },
    snare: -> {
      return @@snare if defined? @@snare
      @@snare = {
         normal: "o".freeze,
         accent: "O".freeze,
         ghost: "g".freeze,
         cross_stick: "x".freeze,
         buzz: "b".freeze,
         flam: "f".freeze
      }.then do |s|
        Struct.new("ABCSnareGlyphs", *s.keys).new(**s)
      end
    },
    pedal: -> {
      return @@pedal if defined? @@pedal
      @@pedal = {
        kick: "o".freeze,
        hat: "x".freeze,
        both: "X".freeze
      }.then do |p|
        Struct.new("ABCPedalGlyphs", *p.keys).new(**p)
      end
    }
  }.freeze

  @@glyph_tree.each do |method_name, method_body|
    define_singleton_method method_name, &method_body
  end

  def self.types
      return @@types if defined? @@types
      @@types = @@glyph_tree.keys.dup.freeze
  end
end
