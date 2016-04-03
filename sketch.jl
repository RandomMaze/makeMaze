include("makeMaze.jl")

@time g = makeMaze(200, 200, [1, 1], [200, 200], 1000)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", getMap(g))
writecsv("E:\\GitHub\\makeMaze\\maze_patha_out.csv", getPath(g))

p = getPath(g);

g.path_b

g.path_b[10]

g.pa
g.pb

quit()
