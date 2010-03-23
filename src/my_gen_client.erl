-module(my_gen_client).


-export([bm/2]).


bm(_Server, 0) ->
  ok;
  
bm(Server, Count) ->
  gen_server:call(Server, client_call),
  ?MODULE:bm(Server, Count - 1).
