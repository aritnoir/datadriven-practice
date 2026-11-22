def inverted_triangle(n: int) -> list[str]:
  temp = []
  for i in range(n, 0, -1):
    temp.append("*" * i)
  return temp
