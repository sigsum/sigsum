# Notes on writing a witness and/or bastion in elixir

author: nisse

These are some notes by a total elixir/erlang newbie, after looking at
the available docs. Getting started info:
https://hexdocs.pm/elixir/introduction.html

## Needed pieces

A witness needs just a few different parts, so could be an easy
project for an elixir newbie.

* ssh-agent client. If there's no suitable module for that already, it
  should be straight forward to write on top of :gen_tcp. Would be
  interesting to apply the binary pattern matching to the ssh-agent
  protocol.
  
* actual witness operation, parsing checkpoints, verifying signatures
  and consistency proofs. Should be straight forward functional
  programming, so I haven't looked into the details of how to do it in
  elixir.
  
* http api, it looks like "Plug" is one way to do it,
  https://hexdocs.pm/plug/readme.html#hello-world. There appears to be
  a choice of underlying web server, 
  "cowboy" or "bandit". No clue what would be most appropriate.
  
* persistent storage. "Mnesia" appears to be the erlang way to store
  data. See https://www.erlang.org/doc/apps/mnesia/mnesia.html and
  https://elixirschool.com/en/lessons/storage/mnesia. Not sure if it
  is appropriate or overkill for our usecase, or if there's any
  simpler alternative (besides just doing direct file i/o, which may
  be a bit too primitive).
  
* To do bastion things, we'd need to mix and match tls connections,
  alpn, http/2, etc. I've not found the way to do this; the http
  client (Mint, https://hexdocs.pm/mint/api-reference.html) seems to
  want to take a host and port and create the connection itself,
  rather than accepting an already open connection. On the server side
  (Plug), I'd expect this is doable, but not obvious from a first look
  at the docs.

* Deps: Unclear if there's any security for dependencies, or if adding
  a dependency like `{:plug_cowboy, "~> 2.0"}` will just download and
  run whatever code is that available on the Internet and labeled with
  this name and version.
