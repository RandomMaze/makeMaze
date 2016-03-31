include("makeMaze.jl")

g = makeMaze(50, 50, [1, 1], [50, 50], 10000)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", g.arr)

g.arr

quit()
