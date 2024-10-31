-- swinging
-- K2 start, K3 stop
-- E3 change tempo

-- sync and resume at the next whole beat as usual:
-- clock.sync(1)
-- sync and resume at the next whole beat with a half-beat delay:
-- clock.sync(1, 0.5)
-- sync to the next 4th beat, but resume earlier by a quarter-beat:
-- clock.sync(4, -1/4)

engine.name = 'PolyPerc'

-- create a swinging feel for a coroutine
-- by delaying even beats by half of the beat length
local beat = 1/4
local offset = beat / 2
local swing = 0

function init()
  id = clock.run(swing_it)
  swinging = true
end

function swing_it()
  while true do
    -- make sure to keep offsets positive!!
    clock.sync(beat, offset * swing)
    engine.hz(333)
    swing = swing ~ 1  -- alternate between 0 and 1
  end
end

function key(n, z)
  if n == 2 and z == 1 then
    if not swinging then
      id = clock.run(swing_it)
      swinging = true
    end
  elseif n == 3 and z == 1 then
    clock.cancel(id)
    swinging = false
  end
end

function enc(n, d)
  if n == 3 then
    -- built-in params like clock_tempo are already defined
    params:delta('clock_tempo', d)
  end
end

------------------ FOR MIDI TRANSPORT CONTROL ------------------
-- see https://monome.org/docs/norns/clocks/#transport-callbacks

-- norns will execute this on transport start
function clock.transport.start()
  print('begin')
  id = clock.run(swing_it)
end


-- norns will execute this on transport stop
function clock.transport.stop()
  print('end')
  clock.cancel(id)
end

------------------ FOR MIDI TRANSPORT CONTROL ------------------
