require "debug"

# History command aliases
Pry.config.commands.alias_command "h20", "hist -T 20", desc: "Last 20 commands"
Pry.config.commands.alias_command "hg", "hist -T 20 -G", desc: "Up to 20 commands matching expression"
Pry.config.commands.alias_command "hG", "hist -G", desc: "Commands matching expression ever used"
Pry.config.commands.alias_command "hr", "hist -r", desc: "hist -r <command number> to run a command"

if defined?(DEBUGGER__)
  puts "ruby/debugger loaded."

#  DEBUGGER__::SESSION.send(:register_command,
#                           'hw', "helloworld",
#                           repeat: false,
#                           unsafe: true,
#                           cancel_auto_continue: false,
#                           postmortem: true) do |arg|
#                                               puts "Hello world!"
#                                             end
end

["lib", "grooves"]. each do |path|
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

require "gs_groove_automator"
require "groove_bag"
include GrooveBag
