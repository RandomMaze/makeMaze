# Make a Maze

This program written in Julia is made to make a random maze automaticlly. We use **GSAW process** and **backtracking algorithm** to make the main path. And then, we use GSAW again to make other paths.

## Some examples:

By running following code:
```
include("makeMaze.jl")

g = makeMaze(500, 500, [1, 1], [500, 500], 100)

writecsv("E:\\GitHub\\makeMaze\\maze_out.csv", g.arr)
writecsv("E:\\GitHub\\makeMaze\\maze_patha_out.csv", getPath(g))
```

You will get two `.CSV` files. The first one is not very useful, but can show you an image of the maze:

![image of maze 1](https://github.com/RandomMaze/makeMaze/raw/master/Images/maze_01.png)

And the second one contains the main path of the maze(drawn by Wolfram Mathematica):

![image of maze 2](https://github.com/RandomMaze/makeMaze/raw/master/Images/maze_02.png)

##TODO

The maze the program generated is not able to be called a "real maze", because it do not have any branches to confuse people. And the following work is to finish this part.
