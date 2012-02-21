function statsd(host, port)
  local Statsd = { 
    ip = ip, 
    port = port,
    udp = socket.udp(),
    timers = {}
  }

  function Statsd:recordMetric(name, value, type) 
    udp:sendto(name .. ":" .. value .. "|" .. type, ip, port) 
  end

  function Statsd:resetTimers() 
    timers = {} 
  end
   
  function Statsd:recordCount(name, value, frequency) 
    return recordMetric(name,value, (frequency and "c|@"..frequency) or "c") 
  end

  function Statsd:recordTime(name, value) 
    return recordMetric(name, value, "ms") 
  end

  function Statsd:startTimer(name)
    if timers[name] == nil then 
      timers[name] = (socket.gettime()*1000)
      return true
    end
    return false
  end

  function Statsd:stopTimer(name) 
    if timers[name] ~= nil then
      local elapsed = ((socket.gettime()*1000)-timers[name])
      metrics.recordTime(name, elapsed);
      timers[name] = nil
      return elapsed
    else
      return false
    end
  end

  return Statsd
end