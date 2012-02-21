require "socket"

function statsd(host, port)
  local Statsd = { 
    ip = assert(socket.dns.toip(host)),
    port = port,
    udp = socket.udp(),
    timers = {}
  }

  function Statsd:recordMetric(name, value, type) 
    Statsd.udp:sendto(name .. ":" .. value .. "|" .. type, Statsd.ip, Statsd.port) 
  end

  function Statsd:resetTimers() 
    Statsd.timers = {} 
  end
   
  function Statsd:recordCount(name, value, frequency) 
    return Statsd:recordMetric(name,value, (frequency and "c|@"..frequency) or "c") 
  end

  function Statsd:recordTime(name, value) 
    return Statsd:recordMetric(name, value, "ms") 
  end

  function Statsd:startTimer(name)
    if Statsd.timers[name] == nil then 
      Statsd.timers[name] = (socket.gettime()*1000)
      return true
    end
    return false
  end

  function Statsd:stopTimer(name) 
    if Statsd.timers[name] ~= nil then
      local elapsed = ((socket.gettime()*1000)-Statsd.timers[name])
      Statsd:recordTime(name, elapsed);
      Statsd.timers[name] = nil
      return elapsed
    else
      return false
    end
  end

  return Statsd
end
