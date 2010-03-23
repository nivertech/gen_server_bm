-module(my_server2).

-export([start_link/0, loop/1]).


start_link() ->
  Pid = spawn_link(?MODULE, loop, [server]),
  {ok, Pid}.
  
loop(State) ->
  receive
    Message -> handle_msg(Message, State)
  end.
  
handle_msg({'$gen_call', {Pid, Ref}, Msg}, State) ->
  Pid ! {Ref, {Msg, State}},
  ?MODULE:loop(State);

handle_msg(stop, _State) ->
  ok.
