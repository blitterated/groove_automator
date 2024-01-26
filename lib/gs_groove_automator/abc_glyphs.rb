#const ABCGlyphs =
#  Struct.new("ABCGlyphs", :hihat, :cymbal, :perc, :snare, :pedal, :tom1, :tom2, :sticking)

class ABCGlyphs

  @@glyph_tree = {
    hihat: {
      normal: "x",
      open:   "o",
      accent: "X"
    },

    cymbal: {
      crash: "c",
      ride: "r",
      bell: "b"
    },

    perc: {
      cowbell: "m",
      stacker: "s",
      click: "n",
      click_accent: "N"
    },

    snare: {
       normal: "o",
       accent: "O",
       ghost: "g",
       cross_stick: "x",
       buzz: "b",
       flam: "f"
    },

    pedal: {
      kick: "o",
      hat: "x",
      both: "X"
    }
  }

  @@glyph_tree.each do |glyph_type, glyphs|
    struct_name = "ABC#{glyph_type.to_s.capitalize}Glyphs"
    frosty_glyphs = glyphs.map { |k,v| [k, v.freeze] }.to_h
    frosty_glyph_struct =
      Struct.new(struct_name, *frosty_glyphs.keys)
            .new(**frosty_glyphs).freeze
    define_singleton_method glyph_type, -> { frosty_glyph_struct }
  end

  def self.types
      return @@glyph_types if defined? @@glyph_types
      @@glyph_types = @@glyph_tree.keys.dup.freeze
  end
end
