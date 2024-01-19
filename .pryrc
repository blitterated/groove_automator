require "debug"
#require "pry-byebug"

Pry.config.commands.alias_command "h20", "hist -T 20", desc: "Last 20 commands"
Pry.config.commands.alias_command "hg", "hist -T 20 -G", desc: "Up to 20 commands matching expression"
Pry.config.commands.alias_command "hG", "hist -G", desc: "Commands matching expression ever used"
Pry.config.commands.alias_command "hr", "hist -r", desc: "hist -r <command number> to run a command"

if defined?(DEBUGGER__)
  puts "ruby/debugger loaded."

  class DEBUGGER__::Session
    def register_my_command *names, repeat: nil, unsafe: nil,
                            cancel_auto_continue: nil, postmortem: nil,
                             &b
      register_command *names, repeat, unsafe,
                       cancel_auto_continue, postmortem,
                       &b
    end

    def clone_command(cmd_name)
      cmd = @commands[cmd_name]

      if cmd.nil?
        puts "Command \"#{cmd_name}\" is not a registered command."
        nil
      else
        #SessionCommand.new(cmd.block, cmd.repeat, cmd.unsafe,
        #                   cmd.cancel_auto_continue, cmd.postmortem)
        cmd.clone
      end
    end
  end

  DEBUGGER__::SESSION.register_my_command 'hw', "helloworld",
                      repeat: false, unsafe: true, cancel_auto_continue: false, postmortem: true do |arg|
    puts "Hello world!"
  end
end

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
  Pry.commands.alias_command 'ds', 'display_shortcuts'

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

  display_shortcuts

  def ds; display_shortcuts; end

  def pp(obj)
    Pry::ColorPrinter.pp(obj)
  end
end

load "./groove_automator.rb"
