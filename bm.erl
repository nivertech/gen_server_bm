#!/usr/bin/env escript 
%%! -pa ebin


measure(Client, Server, Count) ->
  Measures = 5,
  measure(Client, Server, Count, Measures, []).
  
measure(_Client, _Server, _Count, 0, Times) ->
  Sum = lists:foldl(fun(X, Sum) -> X + Sum end, 0, Times),
  round(Sum / length(Times), round(_Count / 10));
  
measure(Client, Server, Count, Measures, Times) ->
  {Time, _} = timer:tc(Client, bm, [Server, Count]),
  measure(Client, Server, Count, Measures - 1, [Time|Times]).


round(Num, Digits) ->
  round(Num / Digits) * Digits.

main([]) ->
  {ok, GenServer} = my_gen_server:start_link(),
  {ok, MyServer1} = my_server1:start_link(),
  {ok, MyServer2} = my_server2:start_link(),
  Count = 100000,
  
  measure(my_gen_client, GenServer, round(Count/10)), % Warm up beam
  
  io:format("Gen-Gen: ~p~n", [measure(my_gen_client, GenServer, Count)]),
  io:format("Gen-My1: ~p~n", [measure(my_gen_client, MyServer1, Count)]),
  io:format("Gen-My2: ~p~n", [measure(my_gen_client, MyServer2, Count)]),

  io:format("My1-Gen: ~p~n", [measure(my_client1, GenServer, Count)]),
  io:format("My1-My1: ~p~n", [measure(my_client1, MyServer1, Count)]),
  io:format("My1-My2: ~p~n", [measure(my_client1, MyServer2, Count)]),

  io:format("My2-Gen: ~p~n", [measure(my_client2, GenServer, Count)]),
  io:format("My2-My1: ~p~n", [measure(my_client2, MyServer1, Count)]),
  io:format("My2-My2: ~p~n", [measure(my_client2, MyServer2, Count)]),


  GenServer ! stop,
  MyServer1 ! stop,
  MyServer2 ! stop,
  ok.
  