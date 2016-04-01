include("Types.jl")

##=============判断是否可以行走=======================

# 判断是否可以向左走
function can_l(ma::maze, p)
  colo = ma.arr[p...]

  # 判断撞墙
  if p[1] - 1 < 1
    return false
  end

  # 判断撞到自己
  if ma.arr[(p + [-1, 0])...] == colo
    return false
  end

  return true
end

function can_r(ma::maze, p)
  colo = ma.arr[p...]

  # 判断撞墙
  if p[1] + 1 > ma.m
    return false
  end

  # 判断撞到自己
  if ma.arr[(p + [1, 0])...] == colo
    return false
  end

  return true
end

function can_u(ma::maze, p)
  colo = ma.arr[p...]

  # 判断撞墙
  if p[2] - 1 < 1
    return false
  end

  # 判断撞到自己
  if ma.arr[(p + [0, -1])...] == colo
    return false
  end

  return true
end

function can_d(ma::maze, p)
  colo = ma.arr[p...]

  # 判断撞墙
  if p[2] + 1 > ma.n
    return false
  end

  # 判断撞到自己
  if ma.arr[(p + [0, 1])...] == colo
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

function walk_back(ma::maze, p)
  colo = ma.arr[p...]
  d = 10
  edx = 0

  if colo == 1
    if ma.pa > d + 1
      edx = ma.pa - d
      if edx == 0
        throw("index = 0.")
      end
    else
      edx = 1
    end

    for i = ma.pa:edx
      ma.arr[ma.path_a[i]...] = 0
    end
    ma.pa = edx
    if edx == 0
      throw("index = 0.")
    end
    return ma.path_a[ma.pa]
  else
    if ma.pb > d + 1
      edx = ma.pb - d
      if edx == 0
        throw("index = 0.")
      end
    else
      edx = 1
    end

    for i = ma.pb:edx
      ma.arr[ma.path_b[i]...] = 0
    end
    ma.pb = edx
    return ma.path_b[ma.pb]
  end
end

#存入堆栈
function putin(ma::maze, index, p)
  if index == 1
    ma.pa += 1
    ma.path_a[ma.pa] = p
  else
    ma.pb += 1
    ma.path_b[ma.pb] = p
  end
end


# 尝试构建一次主干，成功则返回true,否则返回false
function makePathSuccess(ma::maze)
  pa = ma.st
  pb = ma.ed
  ma.arr[pa...] = 1
  ma.arr[pb...] = 2
  n = 1
  #pa_old = pa

  #while allCanMove(ma, pa, pb) && n < 10000
  while (!is_near(pa, pb))# && n < 1000
    if can_move(ma, pa)
      pa = nextp(ma, pa)
      putin(ma, 1, pa) # 放入栈中
    else
      # 否则向回走
      pa = walk_back(ma, pa)
      n += 1
    end

    if can_move(ma, pb)
      pb = nextp(ma, pb) # 各自颜色为1,2
      putin(ma, 2, pb)
    else
      pb = walk_back(ma, pb)
      n += 1
    end

    # 染色
    ma.arr[pa...] = 1
    ma.arr[pb...] = 2

    # 防止越界
    finderr_makePathSuccess(ma, pa, pb)

  end

  #if n >= 10000
  #  throw("The path is too long")
  #end
  if is_near(pa, pb)
    return true
  else
    return false
  end
end

function makePath(ma::maze, maxstep::Int)
  for i = 1:maxstep
    if makePathSuccess(ma)
      return 0
    else
      fill!(ma.arr, Int8(0)) # 清除数据
      ma.pa = 1
      ma.pb = 1
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
  temp = maze(fill(Int8(0), m, n), m, n, st, ed, fill([0, 0], m * n), fill([0, 0], m * n), 1, 1) # 构建初始迷宫
  temp.path_a[1] = st
  temp.path_b[1] = ed

  #随机行走
  if makePath(temp, max_step) == -1
    throw("Cannot find any path in all trys.")
  end

  reColorMaze(temp)

  return temp
end

#输出路径
function getPath(ma::maze)
  temp_path = Array(Int, ma.pa + ma.pb, 2)
  for i = 1:ma.pa
    temp_path[i, 1] = ma.path_a[i][1]
    temp_path[i, 2] = ma.path_a[i][2]
  end

  for j = 1:ma.pb
    temp_path[ma.pa + j, 1] = ma.path_b[ma.pb - j + 1][1]
    temp_path[ma.pa + j, 2] = ma.path_b[ma.pb - j + 1][2]
  end
  return temp_path
end
