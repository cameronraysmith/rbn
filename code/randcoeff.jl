# stable:    N*C*sigma^2 < 1 sqrt(N*C)*s < 1
# unstable:  N*C*sigma^2 > 1 sqrt(N*C)*s > 1

using Iterators

function randsys(N::Integer,L::Integer,C::Float64,sigma::Float64)

  # Generate random system of size N x M
  # with connectivity C
  # and m_ii = -1
  M = zeros(Float64,N,L)
  inds = randperm(N*L)[1:round(C*N*L)]
  M[inds] = (sigma)*randn(int(round(C*N*L)))

  # for i = 1:N
  #   M[i,i] = -1.0
  # end

  return M

end

function randsys(N::Integer,C::Float64,sigma::Float64)
  randsys(N,N,C,sigma)
end

function connectmods(modarray::Array{Array{Float64,2},1},C::Float64,sigma::Float64)
  L = length(modarray)
  modulepairs = Iterators.product(1:L,1:L)
  n = map(x->size(x,1),modarray) # array of nodes in each module
  N = sum(n)
  M = zeros(Float64,N,N)

  for(i,j) in modulepairs
    if i==j
      M[(n[i]*(i-1)+1):(n[i]*i),(n[j]*(j-1)+1):(n[j]*j)] = modarray[i]
    else
      M[(n[i]*(i-1)+1):(n[i]*i),(n[j]*(j-1)+1):(n[j]*j)] = randsys(n[i],n[j],C,sigma)
    end
  end

  return M
end

function randhiermodsys(n::Integer,C::Float64,sigma::Float64,m::Integer,h::Integer,r::Float64)
  # N - number of nodes at level 0
  # m - number of modules at level 1
  # h - number of hierarchical levels
  # r - \frac{\rho_{h+1}}{\rho_h} ratio

  L = 2^(h-1)*m # total number of modules
  N = L*n # total number of nodes
  M = zeros(Float64,N,N)

  rhovec = zeros(Float64,h+1)
  rhovec[1] = C
  for i = 2:length(rhovec)
    rhovec[i] = rhovec[i-1]*r
  end

  modvec = zeros(Integer,h+1)
  modvec[1] = m
  modvec[2:end] = 2

  modarray = [[randsys(n,rhovec[1],sigma) for j in 1:m] for k in 1:2^(h-1)]

  connectmods(vcat(
                connectmods()
              ))

  # for i in 1:h



  # for i = 2:h
  #   modarray = [connectmods(modarray,rhovec[i]) for j in 1:modvec[i]]
  # end

  # modulepairs = Iterators.product(1:L,1:L)

  # for (i,j) in modulepairs
  #   if i==j
  #     M[(n*(i-1)+1):n*i,(n*(j-1)+1):n*j] = randsys(n,rhovec[1],sigma)
  #   else
  #     M[(n*(i-1)+1):n*i,(n*(j-1)+1):n*j] = randsys(n,rhovec[2],sigma)
  #   end
  # end

  # return M
end


function sysstab(M::Array{Float64,2})

  # Continuous time system
  ec,vc = eig(M)

  # Discrete time system L = exp(M)
  # where exp is the matrix exponential
  L = eye(M)+M+M^2/2+M^3/6
  ed,vd = eig(L)

  # Print system matrices
  # println("Continuous system:")
  # println(M)
  # println("Discrete system:")
  # println(L)

  # return maximum(abs(e))/sqrt(N)
  return maximum(abs(ed)), maximum(real(ec))

end

# T = 1000
# N = 40
# C = .0441
# # standard deviation sigma, variance sigma^2
# sigma = 0.5

# discspec = zeros(Float64,T)
# contspec = zeros(Float64,T)

# for t = 1:T
#   discspec[t],contspec[t] = sysstab(randsys(N,C,sigma))
# end

# println("NCsigma^2: $(N*C*sigma^2)")
# println("sqrt(NC)sigma: $(sqrt(N*C)*sigma)")
# println("mean spectral radius: $(mean(discspec))")
# msr = length(find(x->x>1,discspec))/T
# println("proportion with spectral radius greater than 1: $msr")
# mrp = length(find(x->x>0,contspec))/T
# println("mean maximum real part: $(mean(contspec))")
# println("proportion with real part greater than 0: $mrp")
