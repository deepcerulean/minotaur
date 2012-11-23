# Minotaur

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/deepcerulean/minotaur)

Dunegon- and labyrinth-generating (and solving) framework framework.

Incorporates a somewhat loose adaptation of jamis' approaches towards mazes
(e.g., here: http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking).

Nothing really sophisticated yet, but the goal is for this to eventually be a proper 'dungeon' and even 'world' generator
and simulator, which could maybe live in the cloud and be supported by an API.

Basic features:

  - Mazes [done]
   - Generation
   - Solving
  - Dungeons [in progress]
    - basic room division [done]
    - doorways [in progress]
    - differentiated rooms, treasure/encounters/etc. [planned]

Future planned work:

  - Towns, Cities [planned]
    - building placement
    - citizen generation
    - stories/simulation (history generation)

  - Worlds [planned]
    - ecosystem generation
    - cities and towns
    - history simulation


Note that generators/solvers are given symmetrically as 'extruders' (passage-carvers, generators) and 'pathfinders' (solvers)

---

One critical idea would be for an eventual merger of this and  worlds; maybe we could think of minotaur
as a privileged client in that case, which could expose a CLI toolkit, a local web gui, etc., built
around designing world/dungeon 'slugs' (compact details of how the user wants them to look/feel) and
providing zero-level visual simulations of the worlds. I.e., eventually basis for a worlds toolkit that
we'd need to start building SDKs.

## Installation

Add this line to your application's Gemfile:

    gem 'minotaur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minotaur

## Usage

At this point, you could conceivably use it to generate mazes.

This would involve using the Minotaur::Labyrinth class. It's default values permit you to specify
a size and it can generate and display a labyrinth. There are a bunch of helper functions to do different
things with the labyrinth; I'll try to document them better as this goes public.

At any rate, here's a motivational pry session that shows off what's working as of the last incremental
pre-alpha release (0.0.3a).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
