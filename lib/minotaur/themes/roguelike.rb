#
# default and testing theme...

#
#   a theme is generally structured as follows:
#     - definitions of elements (features)
#     - examples of particular configurations (spaces)
#
#
module Minotaur
  module Themes
    class Roguelike < Theme
      include Features

      room_type do |opts|
        target = opts.delete(:for)

        type = case D20.first
          when 0..2   then 'shrine'
          when 2..4   then 'garden'
          when 4..6   then 'armory'
          when 6..9   then 'studio'
          when 9..11  then 'drawing room'
          when 11..14 then 'common room'
          when 14..16 then 'long gallery'
          when 16..17 then 'library'
          when 17..18 then
            if target
              #p target
              target.atmosphere = Atmosphere.new :description => "A well-appointed and ancient hall."
            end
            "great chamber"
          when 18..20
            if target
              # king's throne
              #target.width  = 25
              #target.height = 15
              #  #    encounters do
              #  #      monster :mad_king
              #  #      monster :possessed_warlock
              #  #      monster :insane_advisor, 3
              #  #    end
              target.aura            = Aura.new(alignment: Alignment.new('evil', 'chaotic'))
              target.atmosphere      = Atmosphere.new(description: "Perhaps once a beautiful throne room, but currently in odd disrepair.")
            end
            "Mad Kings' throne room"
          else
            raise "How did you roll that?"
          end

          RoomType.new(type)
        end
      #end

      alignment do
        moral_alignment    = %w[ good neutral evil ].sample
        ethical_alignment  = %w[ lawful chaotic ].sample
        Alignment.new(moral_alignment,ethical_alignment)
      end

      aura do
        Aura.new(alignment: generate(:alignment))
      end

      atmosphere do
        temperature = case D20.first
          when 0...3  then 'very hot'
          when 3...7  then 'hot'
          when 7...11 then 'somewhat hot'
          when 11..13 then 'mild'
          when 13..16 then 'somewhat cold'
          when 16..19 then 'cold'
          when 19..20 then 'very cold'
        end

        #cleanliness = case D20.first
        #  case 0..2 then 'very messy'
        #  case 2..5 then 'messy'
        #  case 5..8 then ''
        #end

        atmosphere = Atmosphere.new({
          temperature: temperature
        })

        atmosphere
      end

      name do |opts|
        target = opts.delete(:for)
        prefixes = []
        suffix = ""
        if target.class == Room

          prefixes   << case target.area
          when 0..15    then 'modest'
          when 15..30   then 'small'
          when 30..45   then 'large'
          when 45..60   then 'expansive'
                        else 'humbling'
          end

          prefixes << 'infernal' if target.aura.alignment.to_s.include?('evil')
          prefixes << 'hallowed' if target.aura.alignment.to_s.include?('good')

          prefixes << 'sweltering' if target.atmosphere.to_s.include?('hot')
          prefixes << 'chilly'     if target.atmosphere.to_s.include?('cold')

          assigned_name = "#{prefixes.join(' ')} #{target.type}#{suffix.empty? ? '':' '+suffix}"
          Name.new(assigned_name)
        else
          Name.new("John Doe")
        end
      end

    end
  end
end


#class Minotaur::Themes::Roguelike < Minotaur::Theme
#
#
#  ## ?...
#  #treasure do
#  #
#  #  name "Gold pieces"
#  #  description "A few gp"
#  #  #puts "--- would be generating treasure..."
#  #  #Treasure.new(:name => "Gold pieces (24)", :description => "A few tens of gp", :value => 24)
#  #end
#
#  #treasures do
#  #  treasure 'rod of nova' do
#  #
#  #  end
#  #end
#  #
#  #rooms do
#  #  room "cave garden" do
#  #    width 15
#  #    height 10
#  #
#  #    atmosphere do
#  #      aura :neutral
#  #      description "A breath-takingly lush garden. Sunlight arcs through openings in the high cave ceilings."
#  #    end
#  #
#  #    encounters do
#  #      monster :goblin
#  #    end
#  #  end
#  #
#  #  room "Mad King's throne room", singular: true do
#  #    width 25
#  #    height 15
#  #
#  #    atmosphere do
#  #      aura :evil
#  #      description "A beautiful throne room, but in odd disrepair."
#  #    end
#  #
#  #    encounters do
#  #      monster :mad_king
#  #      monster :possessed_warlock
#  #      monster :insane_advisor, 3
#  #    end
#  #  end
#  #end
#
#  #rooms do
#  #  treasure do
#  #    case D20
#  #      when 1..2 then
#  #
#  #      end
#  #    end
#  #  end
#  #
#  #  monsters do
#  #
#  #
#  #
#  #  end
#  #
#  #  atmosphere do
#  #
#  #
#  #
#  #  end
#  #end
#end