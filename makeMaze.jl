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
  while !t
    k = rand([1, 2, 3, 4])
    if k == 1 && can_l(ma, p)#can_l
      t = true
      p += [-1, 0]
      return 0
    end
    if k == 2 && can_r(ma, p)
      t = true
      p += [1, 0]
      return 0
    end
    if k == 3 && can_u(ma, p)
      t = true
      p += [0, -1]
      return 0
    end
    if k == 4 && can_d(ma, p)
      t = true
      p += [0, 1]
      return 0
    end
  end
  return -1
end

# 尝试构建一次主干，成功则返回true,否则返回false
function makePathSuccess(ma::maze)
  pa = ma.st
  pb = ma.ed
  while allCanMove(ma, pa, pb)
    nextp(ma, pa, 1)
    nextp(ma, pb, 2) # 各自颜色为1,2

    # 染色
    ma.arr[pa...] = 1
    ma.arr[pb...] = 2
    if pa == pb
      return true
    end
  end

  return false
end

function makePath(ma::maze, maxstep)
  for i = 1:maxstep
    if makePathSuccess(ma)
      return ma
    else
      fill!(ma.arr, int8(0)) # 清除数据
    end
  end

  return ma
end

function makeMaze(m, n, st, ed)
  temp = maze(fill(int8(0), m, n), m, n, st, ed) # 构建初始迷宫

  #随机行走
  makePath(temp, 1000)

  return temp
end
