module Minotaur
  module Explorer
    class Explorer
      include Support::PositionHelpers
      attr_accessor :still_exploring, :labyrinth, :current_room

      def initialize(opts={})
        self.labyrinth        = opts.delete(:labyrinth) do
          l = Labyrinth.new(
            width:  20,
            height: 20,
            extruder: Extruders::SubdividingRoomExtruder
          )
          l.extrude!
          l
        end

        self.current_room     = opts.delete(:current_room) { labyrinth.rooms.first }
      end

      def connected_rooms
        current_room.doors.map { |d| d.room_connected_to(current_room) }
      end

      def describe!
        description = "\n"
        description << ("Current room: #{current_room.room_name}.")
        description << ("This room is a #{current_room.room_type}.")
        description << ("This room's temperature is #{current_room.atmosphere.temperature}.")
        description << (current_room.description)
        description <<  "\n"
        description
      end

      # kick off an interactive session
      def explore!
        say("Welcome to Minotaur explorer!")
        self.still_exploring = true
        while self.still_exploring
          say("\n"*10)
          say(describe!) #(current_room)
          say "Please select an action: \n"

          choose do |action|
            action.prompt = "What would you like to do?  "
            action.choice(:move)  do
              choose do |next_room|
                next_room.prompt = "Which room would you like to move to? "
                connected_rooms.each do |other_room|
                  next_room.choice(other_room.atmosphere.name) do
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