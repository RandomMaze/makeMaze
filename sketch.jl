include("makeMaze.jl")

g = makeMaze(500, 500, [1, 1], [500, 500], 100)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", g.arr)
writecsv("E:\\GitHub\\makeMaze\\maze_patha_out.csv", getPath(g))

p = getPath(g);

g.path_b

g.path_b[10]

g.pa
g.pb

quit()
