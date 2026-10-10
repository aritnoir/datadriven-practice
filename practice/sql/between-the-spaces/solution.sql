SELECT
  msg_id,
 nullif(cardinality(string_to_array(content, " ")), 0)
FROM chat_msgs
