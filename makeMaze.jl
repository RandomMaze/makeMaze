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

##============尝试行走=========================

function nextp(ma::maze, p)
  t = false
  n = 0
  temp_p = p

  while !t && n < 1000
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

# 尝试构建一次主干，成功则返回true,否则返回false
function makePathSuccess(ma::maze)
  pa = ma.st
  pb = ma.ed
  ma.arr[pa...] = 1
  ma.arr[pb...] = 2
  n = 1
  pa_old = pa

  while allCanMove(ma, pa, pb) && n < 1000
    n += 1
    pa = nextp(ma, pa)
    if (pa_old == pa)
      throw("pa was not changed.")
    end
    pb = nextp(ma, pb) # 各自颜色为1,2

    # 染色
    ma.arr[pa...] = 1
    ma.arr[pb...] = 2

    finderr_makePathSuccess(ma, pa, pb)

    if pa == pb
      return true
    end
  end

  if n >= 1000
    throw("The path is too long")
  end

  return false
end

function makePath(ma::maze, maxstep::Int)
  for i = 1:maxstep
    if makePathSuccess(ma)
      return 0
    else
      fill!(ma.arr, Int8(0)) # 清除数据
    end
  end
  return -1
end

function makeMaze(m, n, st, ed)
  temp = maze(fill(Int8(0), m, n), m, n, st, ed) # 构建初始迷宫

  #随机行走
  if makePath(temp, 100) == -1
    throw("Cannot find a path in 100 trys.")
  end

  return temp
end
