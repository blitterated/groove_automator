module GrooveBag
  def groove_2a
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

  def groove_2b
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

  def groove_69a
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

  def groove_69b
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

  def groove_345a
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

  def groove_345b
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

  def groove_345c
    puts Groove.new(
      title: "Groove 3-4-5c",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "4/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 15,
      hihat: "r-b-",
      snare: "-gg-O",
      kick:  "X--ox-o-xo--"
    ).remove_kick_on_snare.URL
    ""
  end

  def groove_bd_in_9_44
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

  def groove_bd_in_9_94
    puts Groove.new(
      title: "Groove with 9 figure in RF in 9/4",
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

  def groove_bd_in_9_34
    puts Groove.new(
      title: "Groove with 9 figure in RF in 3/4",
      author: "Stick Twisters",
      comments: "Contorto come un vecchio albero",
      time_sig: "3/4",
      subdiv: 16,
      tempo: 110,
      total_measures: 6,
      hihat: "Xxxx",
      snare: "----O---",
      kick:  "o---oo---"
    ).URL
    ""
  end
end
