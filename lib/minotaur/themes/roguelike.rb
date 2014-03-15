module Minotaur
  module Themes
    #
    #  default and testing theme
    #
    class Roguelike < Theme
      #
      #   a theme is generally structured as follows:
      #     - definitions of elements (features)
      #     - examples of particular configurations (spaces)
      #

      room do
        Room.new(
          features:   generate(:room_features),
          size:       generate(:room_size)
        )
      end


      room_size do
        Size.new(width: (3..5).to_a.sample, height: (3..5).to_a.sample)
      end

      room_features do #|opts|
        OpenStruct.new({
          atmosphere:  generate(:atmosphere),
          room_name:   generate(:room_name),
          room_type:   generate(:room_type),
          description: generate(:room_description)
        })
      end

      MORAL_ALIGNMENTS   = [ 'very good', 'good', 'slightly good',
                             'neutral', 'slightly evil', 'evil', 'very evil']
      ETHICAL_ALIGNMENTS = [ 'very lawful', 'lawful', 'slightly lawful',
                             'neutral', 'slightly chaotic', 'chaotic', 'very chaotic']

      alignment do
        moral_alignment    = MORAL_ALIGNMENTS.sample
        ethical_alignment  = ETHICAL_ALIGNMENTS.sample

        ethical_alignment = 'true' if moral_alignment == 'neutral' && ethical_alignment == 'neutral'
        Alignment.new(moral_alignment,ethical_alignment)
      end


      room_name do
        %w[ somewhere elsewhere anywhere ].sample
      end

      room_type do
        %w[ armory barracks ].sample
      end

      temperature do
        case D20.first
          when 0...3  then 'very hot'
          when 3...7  then 'hot'
          when 7...11 then 'somewhat hot'
          when 11..13 then 'mild'
          when 13..16 then 'somewhat cold'
          when 16..19 then 'cold'
          when 19..20 then 'very cold'
        end
      end

      room_description do
        case D20.first
          when 0..4 then 'This is a foul-smelling place.'
          when 4..9 then 'You can hear water dripping.'
          when 9..14 then 'There are strange carvings on the wall.'
          when 14..17 then 'A smooth and circular pit in the center of the room drops off at least 90 feet down.'
          when 17..20 then 'The remnants of a dark ritual are scattered around.'
        end
      end

      # atmosphere
      atmosphere do |opts|
        target = opts.delete(:target)
        atmosphere = target ? target.atmosphere : OpenStruct.new
        atmosphere.temperature ||= generate(:temperature)
        atmosphere
      end

    end
  end
end

      #room do
      #  room_type
      #
      #
      #end
  #    #
  #
  #
  #    def self.common_room #(target_room)
  #      case D20.first
  #       when 0..1   then 'shrine'
  #       when 2..3   then 'garden'
  #       when 4..4   then 'armory'
  #       when 6..7   then 'studio'
  #       when 8..10  then 'drawing room'
  #       when 11..13 then 'common room'
  #       when 14..17 then 'long gallery'
  #       when 18..20 then 'library'
  #      end
  #    end
  #
  #    def self.temperature
  #      case D20.first
  #        when 0...3  then 'very hot'
  #        when 3...7  then 'hot'
  #        when 7...11 then 'somewhat hot'
  #        when 11..13 then 'mild'
  #        when 13..16 then 'somewhat cold'
  #        when 16..19 then 'cold'
  #        when 19..20 then 'very cold'
  #      end
  #    end
  #
  #    room_type do |opts|
  #      target = opts.delete(:for)
  #
  #      type = if target.area < 20
  #        common_room
  #      else
  #        # rare room
  #        if target
  #          # king's throne
  #          #target.width  = 25
  #          #target.height = 15
  #          #  #    encounters do
  #          #  #      monster :mad_king
  #          #  #      monster :possessed_warlock
  #          #  #      monster :insane_advisor, 3
  #          #  #    end
  #          target.aura = #Aura.new(alignment: Alignment.new('evil', 'chaotic'))
  #          target.atmosphere      = Atmosphere.new(description: "Perhaps once a beautiful throne room, but currently in odd disrepair.")
  #        end
  #        "Mad Kings' throne room"
  #
  #      end
  #      #
  #      #type = case D20.first
  #      #  when 0..2   then 'shrine'
  #      #  when 2..4   then 'garden'
  #      #  when 4..6   then 'armory'
  #      #  when 6..9   then 'studio'
  #      #  when 9..11  then 'drawing room'
  #      #  when 11..14 then 'common room'
  #      #  when 14..16 then 'long gallery'
  #      #  when 16..17 then 'library'
  #      #  when 17..18 then
  #      #    if target
  #      #      #p target
  #      #      target.atmosphere = Atmosphere.new :description => "A well-appointed and ancient hall."
  #      #    end
  #      #    "great chamber"
  #      #  when 18..20
  #      #  else
  #      #    raise "How did you roll that?"
  #      #  end
  #
  #      RoomType.new(type)
  #    end
  #    #end
  #
  #    MORAL_ALIGNMENTS = [ 'very good', 'good', 'slightly good',
  #                         'neutral', 'slightly evil', 'evil', 'very evil']
  #    ETHICAL_ALIGNMENTS = [ 'very lawful', 'lawful', 'slightly lawful',
  #                           'neutral', 'slightly chaotic', 'chaotic', 'very chaotic']
  #
  #    alignment do
  #      moral_alignment    = MORAL_ALIGNMENTS.sample
  #      ethical_alignment  = ETHICAL_ALIGNMENTS.sample
  #
  #      ethical_alignment = 'true' if moral_alignment == 'neutral' && ethical_alignment == 'neutral'
  #      Alignment.new(moral_alignment,ethical_alignment)
  #    end
  #
  #    aura do
  #      Aura.new(alignment: generate(:alignment))
  #    end
  #
  #    atmosphere do
  #      temperature = case D20.first
  #        when 0...3  then 'very hot'
  #        when 3...7  then 'hot'
  #        when 7...11 then 'somewhat hot'
  #        when 11..13 then 'mild'
  #        when 13..16 then 'somewhat cold'
  #        when 16..19 then 'cold'
  #        when 19..20 then 'very cold'
  #      end
  #
  #      #cleanliness = case D20.first
  #      #  case 0..2 then 'very messy'
  #      #  case 2..5 then 'messy'
  #      #  case 5..8 then ''
  #      #end
  #
  #      description = case D20.first
  #        when 0..4 then 'This is a foul-smelling place.'
  #        when 4..9 then 'You can hear water dripping.'
  #        when 9..14 then 'There are strange carvings on the wall.'
  #        when 14..17 then 'A smooth and circular pit in the center of the room drops off at least 90 feet down.'
  #        when 17..20 then 'The remnants of a dark ritual are scattered around.'
  #      end
  #
  #      atmosphere = Atmosphere.new({
  #        temperature: temperature,
  #        description: description
  #      })
  #
  #      atmosphere
  #    end
  #
  #    name do |opts|
  #      target = opts.delete(:for)
  #      prefixes = []
  #      suffix = ""
  #      if target.class == Room
  #
  #        prefixes   << case target.area
  #          when 0..15    then 'modest'
  #          when 15..30   then 'small'
  #          when 30..45   then 'large'
  #          when 45..60   then 'expansive'
  #                        else 'humbling'
  #        end
  #
  #        prefixes << 'infernal' if target.aura.alignment.to_s.include?('evil')
  #        prefixes << 'hallowed' if target.aura.alignment.to_s.include?('good')
  #
  #        prefixes << 'sweltering' if target.atmosphere.to_s.include?('hot')
  #        prefixes << 'chilly'     if target.atmosphere.to_s.include?('cold')
  #
  #        assigned_name = "#{prefixes.join(' ')} #{target.type}#{suffix.empty? ? '':' '+suffix}"
  #        Name.new(assigned_name)
  #      else
  #        Name.new("John Doe")
  #      end
  #    end
  #
  #  end
  #end
#end


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
