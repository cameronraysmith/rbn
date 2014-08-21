require("booleannetwork.jl")

bn = BoolNet(10, 3, "random")

T = 100

println("initial state: ")
println(bn.initstate)

for i in 1:T
  update(bn)
  println("state at iteration $i")
  println(bn.state)
end
