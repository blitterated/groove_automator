#const ABCGlyphs =
#  Struct.new("ABCGlyphs", :hihat, :cymbal, :perc, :snare, :pedal, :tom1, :tom2, :sticking)

class ABCGlyphs

  @@hihat = {
    normal: "x".freeze,
    open:   "o".freeze,
    accent: "X".freeze
  }

  @@cymbal = {
    crash: "c".freeze,
    ride: "r".freeze,
    bell: "b".freeze
  }

  @@perc = {
    cowbell: "m".freeze,
    stacker: "s".freeze,
    click: "n".freeze,
    click_accent: "N".freeze
  }

  @@snare = {
     normal: "o".freeze,
     accent: "O".freeze,
     ghost: "g".freeze,
     cross_stick: "x".freeze,
     buzz: "b".freeze,
     flam: "f".freeze
  }

  @@pedal = {
    kick: "o".freeze,
    hat: "x".freeze,
    both: "X".freeze
  }

  @@glyph_types = [ :hihat, :cymbal, :perc, :snare, :pedal ]

  @@glyph_types.each do |gt|
    struct_name = "ABC#{gt.to_s.capitalize}Glyphs"
    glyphs = self.singleton_class.class_variable_get("@@#{gt}")
             .then do |g|
               Struct.new(struct_name, *g.keys).new(**g).freeze
             end
    define_singleton_method gt, -> { glyphs }
  end

  def self.types
      @@glyph_types
  end
end
