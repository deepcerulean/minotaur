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
        end

        self.current_room     = opts.delete(:current_room) { labyrinth.rooms.first }
      end

      # kick off an interactive session
      def explore!
        say("Welcome to Minotaur explorer!")
        self.still_exploring = true
        while self.still_exploring
          say("The room you are in currently in is a #{current_room.to_s}.")
          choose do |action|
            action.prompt = "What would you like to do?  "
            action.choice(:move)  do
              choose do |next_room|
                next_room.prompt = "Where would you like to go to? "
                current_room.doors.each_with_index do |door, _|
                  other_room = door.room_connected_to(current_room)
                  next_room.choice(other_room.to_s.to_sym) do
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