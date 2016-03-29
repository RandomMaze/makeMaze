include("Types.jl")

#判断是否可以行走
function allCanMove(ma::maze, pa, pb)
  might_move_a = fill(pa, 2)
  might_move_b = fill(pb, 2)

  can_move_a = fill(true, 2, 2)
  can_move_b = fill(true, 2, 2)

  might_move_a[1, 1] += 1
  might_move_a[2, 1] += -1
  might_move_a[1, 2] += 1
  might_move_a[2, 2] += -1

  might_move_b[1, 1] += 1
  might_move_b[2, 1] += -1
  might_move_b[1, 2] += 1
  might_move_b[2, 2] += -1

  # 判断是否到边界
  for i = 1:2, j = 1:2
    if might_move_a[i,j] < 0
      can_move_a[i, j] = false
    end

    if might_move_b[i,j] < 0
      can_move_b[i, j] = false
    end

    if i == 1
      if j == 1
        if might_move_a[i,j] > m
          can_move_a[i, j] = false
        end
      elseif might_move_b

  end

  # 偶数坐标代表向增大方向走
end


function makePathSuccess(ma::maze)
  pa = ma.st
  pb = ma.ed
  while allCanMove(ma, pa, pb)
    nextp(pa, 1)
    nextp(pb, 2) # 各自颜色为1,2

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
