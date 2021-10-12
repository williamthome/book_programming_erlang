-module(processes).
-export([max/1]).

%% Ouputs the max number of processes
%% who the computer can execute

max(NProcesses) ->
  Max = erlang:system_info(process_limit),
  io:format("Maximum allowed processes: ~p~n",[Max]),
  statistics(runtime), % Time took from here...
  statistics(wall_clock),
  Spawns = for(1, NProcesses, fun() -> spawn(fun() -> wait() end) end),
  {_, Time1} = statistics(runtime), % to here.
  {_, Time2} = statistics(wall_clock),
  lists:foreach(fun(Pid) -> Pid ! die end, Spawns),
  U1 = Time1 * 1000 / NProcesses,
  U2 = Time2 * 1000 / NProcesses,
  io:format("Process spawn time= ~p (~p) microseconds~n", [U1, U2]).

wait() ->
  receive
    die -> void
  end.

%% For loop implementation

for(N, N, F) -> [F()];
for(I, N, F) -> [F() | for(I+1, N, F)].
