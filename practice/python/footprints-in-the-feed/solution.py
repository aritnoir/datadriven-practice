def aggregate_trades(lines: list[str]) -> list:
  day_aggregator = {}
  day_exchange_aggregator = {}
  exchange_aggregator = {}
  for line in lines:
    line_splitted = line.split(",")
    
    day_byte = day_aggregator.get(line_splitted[0], 0)
    day_aggregator[line_splitted[0]] = day_byte + int(line_splitted[-1])
    
    # if day_exchange_aggregator[line_splitted[0]]:
    #   exchange_aggregator = day_exchange_aggregator[line_splitted[0]]
    #   exchange_data = exchange_aggregator.get(line_splitted[1].split('_')[0], 0)
    #   exchange_aggregator[line_splitted[1].split('_')[0]] = day_byte + int(exchange_data)
    #   day_exchange_aggregator[line_splitted[0]] = exchange_aggregator
    # else:
    #   day_exchange_aggregator[line_splitted[0]] = {line_splitted[1].split('_')[0]:line_splitted[-1]}  
    
    exchange_aggregator = day_exchange_aggregator.get(line_splitted[0], {})
    if exchange_aggregator == {}:
      day_exchange_aggregator[line_splitted[0]] = {line_splitted[1].split('_')[0]:int(line_splitted[-1])} 
    else:
      exchange_aggregator = day_exchange_aggregator[line_splitted[0]]
      exchange_data = exchange_aggregator.get(line_splitted[1].split('_')[0], 0)
      exchange_aggregator[line_splitted[1].split('_')[0]] = int(line_splitted[-1]) + int(exchange_data)
      day_exchange_aggregator[line_splitted[0]] = exchange_aggregator
      
  return [day_aggregator, day_exchange_aggregator]
