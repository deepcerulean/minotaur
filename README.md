# Minotaur

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/deepcerulean/minotaur)

# Dungeons in Ruby!

A dungeon- and labyrinth-generating (and solving) framework framework. Currently working towards expanding its flexibility a little bit so that it can generate things like cities too (the square-packing algorithms are very similar.)

Incorporates a somewhat loose adaptation of jamis' approaches towards mazes
(e.g., here: http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking) though at this point we've moved a little bit on from perfect mazes.

A further move might involve a minotaur server living in the cloud, accessible by an API, and which could support actual games in production. (See roguecraft for some ideas on how this might be done; and zephyr for an even earlier proof-of-concept)

Current features:

  - Mazes
   - Generation
   - Solving
  - Dungeons
   - Room extrusion w/ connecting doorways, stairwells between levels
   - Room notes (atmosphere, treasure.)

In progress:

  - Towns, Cities
    - building placement


## Installation

Add this line to your application's Gemfile:

    gem 'minotaur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minotaur

## Usage

You can play around in a generated world using the built-in 'minotaur' tool. Just run 'minotaur explore' to generate
a random dungeon and explore it in a text-based mode.

At this point, you could also conceivably use the library to generate dungeon outlines and mazes.

This would involve using the Minotaur::Labyrinth class. It's default values permit you to specify
a size and it can generate and display a labyrinth. There are a bunch of helper functions to do different
things with the labyrinth; I'll try to document them better as this goes public.

At any rate, here's a motivational pry session that shows off what's working as of the last incremental
pre-alpha release (0.0.3)...

       >>> labyrinth = Minotaur::Labyrinth.new width: 5, height: 5
     ===>
    /---|---|---|---|---|
    |   |   |   |   |   |
    |---|---|---|---|---|
    |   |   |   |   |   |
    |---|---|---|---|---|
    |   |   |   |   |   |
    |---|---|---|---|---|
    |   |   |   |   |   |
    |---|---|---|---|---|
    |   |   |   |   |   |
    |---|---|---|---|---|

       >>> labyrinth.extrude!
     ===>
    /---|---|---|---|---|
    |       |           |
    |---|   |---|   |   |
    |   |       |   |   |
    |   |---|   |   |   |
    |           |   |   |
    |   |---|---|   |   |
    |           |   |   |
    |---|---|   |---|   |
    |                   |
    |---|---|---|---|---|

You can also generate dungeons, or layers of room-oriented labyrinths connected by stairs... 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

