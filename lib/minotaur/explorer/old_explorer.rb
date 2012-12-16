#require 'curses'
#
##module Minotaur
##  module Explorer
#class Explorer
#  include Curses
#
#  include Minotaur::Extruders
#  include Support::PositionHelpers
#
#  attr_accessor :still_exploring, :labyrinth, :current_room
#
#  def initialize(opts={})
#    self.labyrinth        = opts.delete(:labyrinth) do
#      l = Labyrinth.new(
#          width:    20,
#          height:   20,
#          extruder: Minotaur::Extruders::AssemblingRoomExtruder
#      )
#      l.extrude!
#      l
#    end
#
#    self.current_room     = opts.delete(:current_room) { labyrinth.rooms.first }
#  end
#
#  def connected_rooms
#    current_room.doors.map { |d| d.room_connected_to(current_room) }
#  end
#
#  def describe!
#    description = "\n"
#    description << ("Current room: #{current_room.room_name}.")
#    description << ("This room is a #{current_room.room_type}.")
#    description << ("This room's temperature is #{current_room.atmosphere.temperature}.")
#    description << (current_room.description)
#    description <<  "\n"
#    description
#  end
#
#  def still_exploring?
#    @still_exploring ||= true
#  end
#
#  # kick off an interactive session
#  def explore!
#
#    init_screen
#    begin
#      crmode
#      setpos((lines - 5) / 2, (cols - 10) / 2)
#      addstr("Welcome to Minotaur explorer!")
#      refresh
#      getch
#
#      # TODO step through character creation?
#
#      #show_message("Hello, World!")
#      #refresh
#
#      #crmode
#      while still_exploring?
#        #width = message.length + 6
#        map = Window.new(labyrinth.height*2+2, labyrinth.width*4+2,
#                         (lines - labyrinth.height*2) / 2, (cols - labyrinth.width*4) / 2)
#        #win.box('||', '--')
#        map.bkgd(COLOR_WHITE)
#        map.setpos(0,0)
#        labyrinth.to_s.split("\n").each do |line|
#          map.addstr(line+"\n")
#        end
#        map.refresh
#        #win.getch
#
#
#
#        #show_message('(1) move')
#        #width = message.length + 6
#        win = Window.new(15, 20,
#                         0,0)
#
#        win.keypad(true)
#        #win.bkgd(COLOR_CYAN)
#
#        win.box('||', '--')
#        win.setpos(1,1)
#        win.addstr("actions:\n")
#        win.addstr("(j) move left\n")
#        win.addstr("(k) move right\n")
#        win.refresh
#
#        case win.getch
#          when KEY_UP    then show_message("moving north...")
#          when KEY_DOWN  then show_message("moving south...")
#          when KEY_LEFT  then show_message("moving east...")
#          when KEY_RIGHT then show_message("moving west...")
#          else show_message('huh?')
#        end
#
#        win.close
#
#
#        map.close
#
#      end
#
#
#    ensure
#      close_screen
#    end
#  end
#
#
#  def show_message(message)
#    width = message.length + 6
#    win = Window.new(5, width,
#                     (lines - 5) / 2, (cols - width) / 2)
#    win.box('||', '--')
#    win.setpos(2, 3)
#    win.addstr(message)
#    win.refresh
#    win.getch
#    win.close
#  end
#
#  def show_menu(items=[],options={})
#    width = message.length + 6
#    win = Window.new(5, width,
#                     (lines - 5) / 2, (cols - width) / 2)
#    win.box('||', '--')
#    win.setpos(2, 3)
#    win.addstr(message)
#    win.refresh
#    win.getch
#    win.close
#  end
#
#end
##  end
##end
#
## TODO a tool to traverse through a generated space in a text-mode kind of way
##      should maybe show off the 'dynamic' generative aspects of the project
##      (i.e., a dungeon created as you walk through it...)