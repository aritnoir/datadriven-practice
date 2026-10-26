def unflatten(flat: dict) -> dict:
  nested = {}
  
  for flat_key, value in flat.items():
    parts = flat_key.split(".")
    curr = nested
    
    # Traverse or create nested dictionaries for all parts except the last one
    for part in parts[:-1]:
      if part not in curr:
        curr[part] = {}
      curr = curr[part]
      
    # Assign the value to the final leaf key
    curr[parts[-1]] = value
    
  return nested
