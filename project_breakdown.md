Breaking down the Project 
    1. Create a Carrot/Rabbit/Wolf module with supervisors.
    2. Spike into Best graphics
    3. Add intelligent features

Questions?
1. Whats the user interface?
    A. User starts the app and initializes the number of carrot/rabbit/wolf patches.
    We show the world (the board) and the simulation just start from there.

2. Can we separate frontend and backend?
    A. ???



## How does a supervisor work in Elixir?
At the core of the OTP ser ver is a Genserver. At its most basic level a GenServer is a single process which runs 
loop that handles one message per iteration passing along an updated state. In most cases we’ll want to link processes so we use GenServer.start_link/3.
We pass in the GenServer module we’re starting, initial arguments, and a set of GenServer options. The arguments will be passed to GenServer.init/1 
which sets the initial state through its return value. Supervisors are specialized processes with one purpose: monitoring other processes.
https://elixirschool.com/en/lessons/advanced/otp-concurrency/

## Learnings: 
#### Lesson 1
I started out by building objects as process which would run a recursive function as loops.
Silly me, I forgot that!
> "The goal of a GenServer is to abstract the "receive" loop for developers, 
> automatically handling system messages, supporting code change, synchronous calls and more. 
> Therefore, you should never call your own "receive" inside the GenServer callbacks as doing 
> so will cause the GenServer to misbehave."

What I needed was to create each object as a Genserver in itself. All the logic has already been
abstracted away from me! Happy Me :)

#### Lesson 2
Wasted a lot of time figuring out why Generator's start_link function was being invoked. 
I suspected it was something to do with how I was starting the DynamicSupervisor.
The correct way to do it is:
    %{
        id: Generator,
        start: {Generator, :start_link, [[]]}
    }
versus the incorrect way I was using before:
    {DynamiSupervisor, strategy: :one_for_one, name: Generator}