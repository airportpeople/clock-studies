-- basic
-- forever clocks and a metronome
-- that stops after `n_bars`
-- clock.sync and clock.sleep
-- both "wait" until the next
-- subdivision or time, 
-- respectively

engine.name = 'PolyPerc'

n_bars = 3
sub = 1/4
t_delay = 0.75

function init()
  -- we can manage multiple subroutines
  voice = {}
  voice[1] = clock.run(forever,333,3)
  voice[2] = clock.run(forever,666,1)
end

function forever(freq)
  while true do
    clock.sync(sub)
    engine.hz(freq)
    clock.sleep(t_delay)
    engine.hz(freq * 2)
  end
end

-- metronome
function by_bar_count(freq)
  for i = 1,n_bars/sub do
    clock.sync(sub)
    down_beat = i % (1/sub) == 1
    engine.hz(down_beat and freq * 2 or freq)
  end
end

function key(n,z)
  if n == 2 and z == 1 then
    clock.run(by_bar_count, 440)
  end

  if n == 3 and z == 1 then
    for i=1,#voice do
      clock.cancel(voice[i])
    end
  end

end