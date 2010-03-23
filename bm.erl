#!/usr/bin/env escript 
%%! -pa ebin


main([]) ->
  {ok, GenServer} = my_gen_server:start_link(),
  {ok, MyServer1} = my_server1:start_link(),
  {ok, MyServer2} = my_server2:start_link(),
  Count = 1000000,
  
  {TimeGG, _} = timer:tc(my_gen_client, bm, [GenServer, Count]),
  io:format("Gen-Gen: ~p~n", [TimeGG]),

  {TimeMG, _} = timer:tc(my_client, bm, [GenServer, Count]),
  io:format("My-Gen: ~p~n", [TimeMG]),

  {TimeGM1, _} = timer:tc(my_gen_client, bm, [MyServer1, Count]),
  io:format("Gen-My1: ~p~n", [TimeGM1]),

  {TimeGM2, _} = timer:tc(my_gen_client, bm, [MyServer2, Count]),
  io:format("Gen-My2: ~p~n", [TimeGM2]),

  {TimeM1M1, _} = timer:tc(my_client1, bm, [MyServer1, Count]),
  io:format("My1-My1: ~p~n", [TimeM1M1]),

  {TimeM1M2, _} = timer:tc(my_client1, bm, [MyServer2, Count]),
  io:format("My1-My2: ~p~n", [TimeM1M2]),

  {TimeM2M1, _} = timer:tc(my_client2, bm, [MyServer1, Count]),
  io:format("My2-My1: ~p~n", [TimeM2M1]),

  {TimeM2M2, _} = timer:tc(my_client2, bm, [MyServer2, Count]),
  io:format("My2-My2: ~p~n", [TimeM2M2]),

  GenServer ! stop,
  MyServer1 ! stop,
  MyServer2 ! stop,
  ok.
  