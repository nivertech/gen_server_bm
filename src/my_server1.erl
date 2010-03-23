-module(my_server1).

-export([start_link/0, loop/1]).


start_link() ->
  Pid = spawn_link(?MODULE, loop, [server]),
  {ok, Pid}.
  
loop(State) ->
  receive
    {'$gen_call', {Pid, Ref}, Msg} ->
      Pid ! {Ref, {Msg, State}},
      ?MODULE:loop(State);
    stop ->
      ok
  end.
  