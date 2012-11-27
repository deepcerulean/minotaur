module Minotaur
  module Explorer
    class Explorer
      include Support::PositionHelpers
      attr_accessor :still_exploring, :labyrinth, :current_room
      def initialize(opts={})
        self.labyrinth        = opts.delete(:labyrinth) do
          l = Labyrinth.new(
            width:  30,
            height: 40,
            extruder: Extruders::SubdividingRoomExtruder
          )
          l.extrude!
          l
        end

        self.current_room     = opts.delete(:current_room) { labyrinth.rooms.first }
      end

      def describe #(room)
        say "\n"
        say("Current room: #{current_room.atmosphere.name}.")
        say("This room is a #{current_room.atmosphere.type}.")
        say("This room's temperature is #{current_room.atmosphere.temperature}.")
        say(current_room.atmosphere.description)
        say "\n"
      end

      # kick off an interactive session
      def explore!
        say("Welcome to Minotaur explorer!")
        self.still_exploring = true
        while self.still_exploring
          say("\n"*10)
          describe #(current_room)
          say "Please select an action: \n"
          choose do |action|
            action.prompt = "What would you like to do?  "
            action.choice(:move)  do
              choose do |next_room|
                next_room.prompt = "Which room would you like to move to? "
                current_room.doors.each_with_index do |door, _|
                  other_room = door.room_connected_to(current_room)
                  next_room.choice(other_room.atmosphere.name.to_sym) do
                    self.current_room = other_room
                  end
                end
              end
              say("Good choice!")
            end
            action.choices(:quit) do
              say("Well, bye!")
              self.still_exploring = false
            end
          end
        end
      end
    end
  end
end

# TODO a tool to traverse through a generated space in a text-mode kind of way
#      should maybe show off the 'dynamic' generative aspects of the project
#      (i.e., a dungeon created as you walk through it...)