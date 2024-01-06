require "debug"
#require "pry-byebug"

def ds; display_shortcuts; end

def display_shortcuts
  return <<~EOT
    Installed debugging Shortcuts
    ww :  whereami
    ss :  step
    nn :  next
    cc :  continue
    ff :  finish
    pp(obj)  :  pretty print object

    Stack movement
    tt :  backtrace
    ff :  frame
    uu :  up
    dd :  down
    bb :  break

    hh :  Last 20 commands
    hg :  Up to 20 commands matching expression
    hG :  Commands matching expression ever used
    hr :  hist -r <command number> to run a command
  EOT
end

Pry.config.commands.alias_command "h20", "hist -T 20", desc: "Last 20 commands"
Pry.config.commands.alias_command "hg", "hist -T 20 -G", desc: "Up to 20 commands matching expression"
Pry.config.commands.alias_command "hG", "hist -G", desc: "Commands matching expression ever used"
Pry.config.commands.alias_command "hr", "hist -r", desc: "hist -r <command number> to run a command"

if defined?(PryByebug)
  Pry.commands.alias_command 'tt', 'backtrace'
  Pry.commands.alias_command 'ss', 'step'
  Pry.commands.alias_command 'nn', 'next'
  Pry.commands.alias_command 'cc', 'continue'
  Pry.commands.alias_command 'fn', 'finish'
  Pry.commands.alias_command 'ff', 'frame'
  Pry.commands.alias_command 'uu', 'up'
  Pry.commands.alias_command 'dd', 'down'
  Pry.commands.alias_command 'bb', 'break'
  Pry.commands.alias_command 'ww', 'whereami'

  display_shortcuts

  def pp(obj)
    Pry::ColorPrinter.pp(obj)
  end
end
