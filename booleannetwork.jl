using Graphs

type BoolNet

  N::Integer # network size
  K::Integer # average in-degree
  gt::String # graph type in ["random","smallworld"]
  network::AbstractGraph
  functionlist::Array{Array{Bool,1},1}
  P::Float64
  initstate::Array{Bool,1}
  state::Array{Bool,1}

  function BoolNet(N::Integer,K::Integer,gt::String)
    network = gengraph(N,K,gt)
    indegs = [in_degree(i,network) for i in network.vertices]
    functionlist = [samplerba(2^i) for i in indegs]
    P = mean(map(homogeneity,functionlist))
    state = samplerba(N)
    new(N,K,gt,network,functionlist,P,deepcopy(state),deepcopy(state))
  end

end

function homogeneity(I::Array{Bool,1})
  if sum(I) > length(I)/2
    return sum(I)/length(I)
  else
    return (length(I)-sum(I))/length(I)
  end
end

function samplerba(K::Integer)
  # sample a random boolean array of length K
  return [bool(rand(0:1)) for i in 1:K]
end

function boolinputtoint(I::Array{Bool,1})

  # convert boolean array that represents
  # input to a boolean function to an integer
  # representing which of the outputs of
  # a given boolean function is selected
  # by that input

  return parseint(join(map(x->convert(Int,x),I)),2)+1

end

function gengraph(N::Integer,K::Integer,gt::String)

  if gt=="random"
    sg = simple_graph(N)
    return erdos_renyi_graph(sg,N,K/N)
  elseif gt=="smallworld"
    if mod(K,2)==0
      sg = simple_graph(N)
      erdos_renyi_graph(sg,N,K/N)
      return watts_strogatz_graph(sg,N,K,0.1)
    else
      println("base degree (K) must be even")
    end
  else
    println("must give graphtype of \"random\" or \"smallworld\"")
  end

end

function update(bn::BoolNet)

  for n in bn.network.vertices
    inputvertexarray = in_neighbors(n,bn.network)

    if length(inputvertexarray) > 0
      inputstatearray = bn.state[(Integer)[i for i in inputvertexarray]]
      outputindex = boolinputtoint(inputstatearray)
      bn.state[n] = deepcopy(bn.functionlist[n][outputindex])
    else
      continue
    end

  end

end

#-------------------------------------------------------
#-------------------------------------------------------
#-------------------------------------------------------

function samplerbf(K::Integer)

  # sample a boolean function
  # by choosing an integer
  # in the range 0:2^2^K-1
  # http://stackoverflow.com/a/24968459/446907

  buffer = Array(Uint8,32)
  ccall((:__gmp_randinit_default,:libgmp),Void,(Ptr{Uint8},),buffer)
  x = BigInt(0)
  y = 2^2^BigInt(K)-1

  ccall((:__gmpz_urandomm,:libgmp),Void,(Ptr{BigInt},Ptr{Uint8},Ptr{BigInt}),&x,buffer,&y)

  return x

end

function bfbitarray(index::Integer,K::Integer)

  # extract the boolean function
  # by converting the integer index
  # to a bit array

  fstring = bits(index)[64-2^K+1:end]

  fbitarray = map(x->bool(parseint(x,2)),collect(fstring))

  return fbitarray

end
