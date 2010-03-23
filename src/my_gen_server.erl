-module(my_gen_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link(?MODULE, [], []).


init([]) ->
  {ok, gen_server}.
  
handle_call(Call, _From, State) ->
  {reply, {Call, State}, State}.

handle_cast(_Cast, State) ->
  {noreply, State}.

handle_info(stop, State) ->
  {stop, normal, State};
  
handle_info(_Message, State) ->
  {noreply, State}.
  
terminate(_A, _State) ->
  ok.
  
code_change(_A, State, _B) ->
  {ok, State}.
