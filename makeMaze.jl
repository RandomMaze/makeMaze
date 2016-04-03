include("Types.jl")

##=============判断是否可以行走=======================

# 判断是否可以向左走
function can_l(ma::maze, p)
  #colo = ma.arr[p...].color

  # 判断撞墙
  if p[1] - 1 < 1
    return false
  end

  # 判断撞到路径
  if ma.arr[(p + [-1, 0])...].color != 0
    return false
  end

  return true
end

function can_r(ma::maze, p)
  #colo = ma.arr[p...].color

  # 判断撞墙
  if p[1] + 1 > ma.m
    return false
  end

  # 判断撞到路径
  if ma.arr[(p + [1, 0])...].color != 0
    return false
  end

  return true
end

function can_u(ma::maze, p)
  #colo = ma.arr[p...].color

  # 判断撞墙
  if p[2] - 1 < 1
    return false
  end

  # 判断撞到路径
  if ma.arr[(p + [0, -1])...].color != 0
    return false
  end

  return true
end

function can_d(ma::maze, p)
  #colo = ma.arr[p...]

  # 判断撞墙
  if p[2] + 1 > ma.n
    return false
  end

  # 判断撞到自己
  if ma.arr[(p + [0, 1])...].color != 0
    return false
  end

  return true
end
#判断是否可以行走
function allCanMove(ma::maze, pa, pb)
  return (can_l(ma, pa) || can_r(ma, pa) || can_u(ma, pa) || can_d(ma, pa)) && (can_l(ma, pa) || can_r(ma, pa) || can_u(ma, pa) || can_d(ma, pa))
end

function can_move(ma::maze, p)
  return (can_l(ma, p) || can_r(ma, p) || can_u(ma, p) || can_d(ma, p))
end

##============尝试行走=========================

function nextp(ma::maze, p)
  t = false
  n = 0
  temp_p = p

  if !(can_l(ma, p) || can_r(ma, p) || can_u(ma, p) || can_d(ma, p))
    # 此点无法
    return p
  end

  while !t  && n < 1000
    n += 1
    k = rand([1, 2, 3, 4])
    if k == 1 && can_l(ma, p)#can_l
      t = true
      temp_p += [-1, 0]
      return temp_p
    end
    if k == 2 && can_r(ma, p)
      t = true
      temp_p += [1, 0]
      return temp_p
    end
    if k == 3 && can_u(ma, p)
      t = true
      temp_p += [0, -1]
      return temp_p
    end
    if k == 4 && can_d(ma, p)
      t = true
      temp_p += [0, 1]
      return temp_p
    end
  end
  throw("Cannot find any path here")
  return [-1, -1]
end

function finderr_makePathSuccess(ma::maze, pa, pb)
  if pa[1] < 1 || pa[1] > ma.m || pb[1] < 1 || pb[1] > ma.m
    throw("Break the bondary.")
  end

  if pa[2] < 1 || pa[2] > ma.n || pb[2] < 1 || pb[2] > ma.n
    throw("Break the bondary.")
  end
end

function is_near(pa, pb)
  d = sum(abs(pa - pb))
  return (d <= 1)
end

#回退
function walk_back(ma::maze, p, index)
  colo = index
  d = 20
  edx = 0

  if ma.p[index] > d
    edx = ma.p[index] - d
    if edx == 0
      throw("index = 0.")
    end
  else
    edx = 1
  end

  for i = edx + 1:ma.p[index]
    ma.arr[ma.path[index, i]...].color = 0
    ma.arr[ma.path[index, i]...].index = 0
  end
  ma.p[index] = edx
  if edx == 0
    throw("index = 0.")
  end

  return ma.path[index, edx]
end

#存入堆栈
function putin(ma::maze, t, point)
  ma.p[t] += 1
  ma.path[t, ma.p[t]] = point
  ma.arr[point...] = mycell(t, ma.p[t]) # 堆栈编号
end

# 判断周围是否有其他颜色的点
function get_near_one(ma, p)
  colo = ma.arr[p...].color
  co2 = 0
  around_move = reshape([1,0, -1,0, 0,1, 0,-1], 4, 2) # 四个方向

  for i = 1:4
    co2 = try
      ma.arr[p[1] + around_move[i,1], p[2] + around_move[i,2]].color
    catch
      -1
    end
    if co2 != colo && co2 != 0 && co2 != -1
      return ma.arr[p[1] + around_move[i,1], p[2] + around_move[i,2]].index
    end
  end

  # 未找到
  return -1
end

# 判断是否相碰，并以此修改堆栈
function get_near(ma, point_1, point_2)
  indexp = 0
  if (indexp = get_near_one(ma, point_1)) != -1
    # 清除其余路径
    for i = indexp + 1:ma.p[2]
      ma.arr[ma.path[2, i]...].color = 0
    end
    ma.p[2] = indexp  # 截断对面的路径
    return true
  elseif (indexp = get_near_one(ma, point_2)) != -1
    # 清除其余路径
    for i = indexp + 1:ma.p[1]
      ma.arr[ma.path[1, i]...].color = 0
    end
    ma.p[1] = indexp  # 截断路径
    return true
  end
  return false
end

# 尝试构建一次主干，成功则返回true,否则返回false
function makePathSuccess(ma::maze)
  pa = ma.st
  pb = ma.ed
  ma.p = [1, 1]
  ma.path[1,1] = pa
  ma.path[2,1] = pb
  ma.arr[pa...] = mycell(1, 1)
  ma.arr[pb...] = mycell(2, 1)
  n = 1
  #pa_old = pa

  #while allCanMove(ma, pa, pb) && n < 10000
  while (!get_near(ma, pa, pb)) && n < 100
    if can_move(ma, pa)
      pa = nextp(ma, pa)
      putin(ma, 1, pa) # 放入栈中
    else
      # 否则向回走
      pa = walk_back(ma, pa, 1)
      n += 1
    end

    if can_move(ma, pb)
      pb = nextp(ma, pb) # 各自颜色为1,2
      putin(ma, 2, pb)
    else
      pb = walk_back(ma, pb, 2)
      n += 1
    end

    # 染色
    #ma.arr[pa...].color = 1
    #ma.arr[pb...].color = 2
    #ma.arr[pa...].index = ma.p[1]
    #ma.arr[pb...].index = ma.p[2]

    # 防止越界
    finderr_makePathSuccess(ma, pa, pb)

  end

  #if n >= 10000
  #  throw("The path is too long")
  #end
  if get_near(ma, pa, pb)
    return true
  else
    #throw("Not near")
    return false
  end
end

function makePath(ma::maze, maxstep::Int)
  for i = 1:maxstep
    if makePathSuccess(ma)
      return 0
    else
      fill!(ma.arr, mycell(0, 0)) # 清除数据
      ma.p[1] = 1
      ma.p[2] = 1
    end
  end
  return -1
end

function reColorMaze(ma::maze)
  for i = 1:ma.m, j = 1:ma.n
    if ma.arr[i, j] != 0
      ma.arr[i, j] = 1
    end
  end
end

function makeMaze(m, n, st, ed, max_step::Int)
  temp = maze(fill(mycell(0, 0), m, n), m, n, st, ed, fill([0, 0], 2, m * n), [1, 1]) # 构建初始迷宫

  for i = 1:m, j = 1:n
    temp.arr[i, j].color = 0
    temp.arr[i, j].index = 0
  end

  temp.path[1, 1] = st
  temp.path[2, 1] = ed
  temp.arr[st...] = mycell(1,1)
  temp.arr[ed...] = mycell(2,1)

  #return temp

  #随机行走
  if makePath(temp, max_step) == -1
    throw("Cannot find any path in all trys.")
  end

  #reColorMaze(temp)

  return temp
end

#输出路径
function getPath(ma::maze)
  temp_path = Array(Int, sum(ma.p), 2)
  for i = 1:ma.p[1]
    temp_path[i, 1] = ma.path[1,i][1]
    temp_path[i, 2] = ma.path[1,i][2]
  end

  for j = 1:ma.p[2]
    temp_path[ma.p[1] + j, 1] = ma.path[2,ma.p[2] - j + 1][1]
    temp_path[ma.p[1] + j, 2] = ma.path[2,ma.p[2] - j + 1][2]
  end
  return temp_path
end

function getMap(ma::maze)
  m = ma.m
  n = ma.n

  temp_map = fill(0, m, n)
  for i = 1:m, j = 1:n
    temp_map[i, j] = ma.arr[i, j].color
  end
  return temp_map
end
