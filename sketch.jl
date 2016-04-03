include("makeMaze.jl")

@time g = makeMaze(100, 100, [1, 1], [100, 100], 1000)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", g.arr)
writecsv("E:\\GitHub\\makeMaze\\maze_patha_out.csv", getPath(g))

p = getPath(g);

g.path_b

g.path_b[10]

g.pa
g.pb

quit()
