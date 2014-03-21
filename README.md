# Minotaur

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/deepcerulean/minotaur)

Dunegon- and labyrinth-generating (and solving) framework framework.

Incorporates a somewhat loose adaptation of jamis' approaches towards mazes
(e.g., here: http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking).

Nothing really very sophisticated yet, but the goal is for this to eventually be a proper 'dungeon' and even 'world' generator
and simulator.

An extremely simple client which is packaged in the gem lets you traverse a dungeon in a 'first-person' text interface.
(Still in progress.)

A further move might involve a minotaur server living in the cloud, accessible by an API, and which could support
actual games in production.

Current features:

  - Mazes
   - Generation
   - Solving
  - Dungeons
   - Room extrusion w/ connecting doorways
   - Room notes (atmosphere, etc.)
   - Simple CLI "client"


[Note that generators/solvers are given symmetrically as 'extruders' (passage-carvers, generators) and 'pathfinders' (solvers)]

In progress:

  - Dungeons
    - Enhancements to CLI "client"
    - Notes
      - Treasure
      - Encounters

Planned work:

  - General
    - Player class

  - Dungeons
    - More sophisticated generation strategies
    - Better atmosphere notes, etc.

  - Towns, Cities
    - building placement
    - citizen generation
    - stories/simulation (history generation)

Backlog:

  - Refactoring throughout

  - Worlds
    - ecosystem generation
    - cities and towns
    - history simulation

  - API/Server
    - Sessions
    - World protocol; generalized entities
    - Would need to be able to manage "game state" reliably, etc.


One idea would be for an eventual merger of this and  worlds; maybe we could think of another minotaur CLI tool
that would be the "privileged client" -- exposing a deep toolkit, or working alongside a 'local' web app/server, etc.

The core would be designing game/world/dungeon 'slugs' (compact details of how the user wants them to look/feel)
-- and maybe to connect back with the text-only minotaur 'browser' -- could also provide zero-level visual simulations
of the worlds.

(This could, potentially, eventually become the basis for a worlds toolkit that could support building SDKs, etc.)

## Working Notes

Eventually we really want a combo of dijkstra and recursive-backtracking -- recursive-backtracking at the room-graph level, and dijkstras between points...

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

