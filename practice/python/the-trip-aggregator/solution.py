def aggregate_trips(trips: list[dict]) -> list[dict]:
  # Intermediate storage: {user_id: {"total_hours": int, "destinations": set}}
  user_data = {}
  
  # Single pass O(N) to aggregate data
  for trip in trips:
    user_id = trip["user_id"]
    
    if user_id not in user_data:
      user_data[user_id] = {
        "total_hours": 0,
        "destinations": set()
      }
      
    user_data[user_id]["total_hours"] += trip["duration_hours"]
    user_data[user_id]["destinations"].add(trip["destination"])
  
  # Construct the final list output
  # sorted_data = sorted(data, key=lambda x: x['age'])
  return sorted([
    {
      "user_id": user_id,
      "unique_destinations": len(data["destinations"]),
      "total_hours": data["total_hours"]
    }
    for user_id, data in user_data.items()], key=lambda x: x['user_id']
  )
