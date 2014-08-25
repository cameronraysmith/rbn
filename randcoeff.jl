# stable:    N*C*sigma^2 < 1 sqrt(N*C)*s < 1
# unstable:  N*C*sigma^2 > 1 sqrt(N*C)*s > 1


function randsys(N::Integer,C::Float64,sigma::Float64)

  # Generate random system of size N x N
  # with connectivity C
  # and m_ii = -1
  M = zeros(Float64,N,N)
  inds = randperm(N^2)[1:round(C*N^2)]
  M[inds] = (sigma)*randn(int(round(C*N^2)))

  # for i = 1:N
  #   M[i,i] = -1.0
  # end

  return M

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

T = 1000
N = 40
C = .0441
# standard deviation sigma, variance sigma^2
sigma = 0.5

discspec = zeros(Float64,T)
contspec = zeros(Float64,T)

for t = 1:T
  discspec[t],contspec[t] = sysstab(randsys(N,C,sigma))
end

println("NCsigma^2: $(N*C*sigma^2)")
println("sqrt(NC)sigma: $(sqrt(N*C)*sigma)")
println("mean spectral radius: $(mean(discspec))")
msr = length(find(x->x>1,discspec))/T
println("proportion with spectral radius greater than 1: $msr")
mrp = length(find(x->x>0,contspec))/T
println("mean maximum real part: $(mean(contspec))")
println("proportion with real part greater than 0: $mrp")
