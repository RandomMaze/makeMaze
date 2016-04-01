include("makeMaze.jl")

g = makeMaze(1000, 1000, [1, 1], [1000, 1000], 1000)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", g.arr)
writecsv("E:\\GitHub\\makeMaze\\maze_patha_out.csv", g.path_a)
g.arr

is_near([1,3],[3,3])

quit()
