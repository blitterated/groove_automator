require "debug"
#require "pry-byebug"

# Changes shell command leader from '.' to another character or string
def change_shell_command_leader(new_leader)
  match = /\.(.*)/
  shell_cmd = Pry::Commands.to_h[match]
  new_match = /#{new_leader}(.*)/
  new_options = {
     description: shell_cmd.description.gsub("'.'", "'#{new_leader}'"),
     banner: shell_cmd.banner.gsub(/\.([^\n])/, "#{new_leader}\\1"),
     command_options: shell_cmd.command_options.dup.tap do |co|
                        co[:listing] = "#{new_leader}<shell command>"
                      end,
  }
  Pry::Commands.rename_command(new_match, match, new_options)
end

# Change shell command leader from '.' to ','
change_shell_command_leader(',')

# History command aliases
Pry.config.commands.alias_command "h20", "hist -T 20", desc: "Last 20 commands"
Pry.config.commands.alias_command "hg", "hist -T 20 -G", desc: "Up to 20 commands matching expression"
Pry.config.commands.alias_command "hG", "hist -G", desc: "Commands matching expression ever used"
Pry.config.commands.alias_command "hr", "hist -r", desc: "hist -r <command number> to run a command"

if defined?(DEBUGGER__)
  puts "ruby/debugger loaded."

  class DEBUGGER__::Session
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

  DEBUGGER__::SESSION.send(:register_command,
                           'hw', "helloworld",
                           repeat: false,
                           unsafe: true,
                           cancel_auto_continue: false,
                           postmortem: true) do |arg|
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

#groove_path = File.expand_path(“grooves”, __FILE__)
#$LOAD_PATH.unshift(groove_path) unless $LOAD_PATH.include?(groove_path)
["lib", "grooves"]. each do |path|
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

require "gs_groove_automator"

require "groove_bag"
include GrooveBag
