#
# N*C*sigma^2 < 1
#

function spectralradrand(N::Integer,C::Float64,sigma::Float64)

  M = zeros(Float64,N,N)
  inds = randperm(N^2)[1:round(C*N^2)]
  M[inds] = (sigma^2)*randn(int(round(C*N^2)))

  e,v = eig(M)
  # return maximum(abs(e))/sqrt(N)
  return maximum(abs(e))

end

T = 1000
N = 100
C = 0.008
sigma = 1.0

sr = zeros(Float64,T)

for t = 1:T
  sr[t] = spectralradrand(N,C,sigma)
end

println("NCsigma^2: $(N*C*sigma^2)")
println("mean spectral radius: $(mean(sr))")
ng1 = length(find(x->x>1,sr))/T
println("proportion with spectral radius greater than 1: $ng1")
