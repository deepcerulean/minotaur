module Minotaur
  module Command
    class Runner < Thor
      desc "explore", 'explore a world'
      def explore
        puts "I'm a thor task!"
      end

      #def self.run(cmd, args)
      #  puts "=== minotaur running minotaur command #{cmd}!"
      #  puts "--- got cmd #{args}"
      #end
    end
  end
end
