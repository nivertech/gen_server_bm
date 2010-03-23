-module(my_client2).


-export([bm/2]).


bm(_Server, 0) ->
  ok;
  
bm(Server, Count) ->
  Ref = erlang:make_ref(),
  Server ! {'$gen_call', {self(), Ref}, client_call},
  erlang:yield(),
  receive
    {Ref, _Reply} -> ?MODULE:bm(Server, Count - 1)
  after
    1000 -> erlang:error(timeout_call)
  end.

