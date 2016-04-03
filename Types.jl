type mycell
  color   #颜色
  index   #对于堆栈中的坐标
end

type maze
  arr # 迷宫主体
  # 长宽
  m
  n
  # 初始点、结束点
  st
  ed
  # 路径
  path
  # 栈指针
  p
end
