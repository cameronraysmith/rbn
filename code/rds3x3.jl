using Permutations

function pmatrix(M::Array{Int64,2})
    lines = split(replace(replace(string(M),"[",""),"]",""),"\n")
    rv = (String)[]
    push!(rv,"\\begin{pmatrix}")
    for l in lines
        push!(rv,string(join(split(l)," & "),"\\\\"))
    end
    push!(rv,"\\end{pmatrix}")
    return join(rv,"\n")
end

function pmatrix(M::Array{Float64,2})
    lines = split(replace(replace(string(round(M,2)),"[",""),"]",""),"\n")
    rv = (String)[]
    push!(rv,"\\begin{pmatrix}")
    for l in lines
        push!(rv,string(join(split(l)," & "),"\\\\"))
    end
    push!(rv,"\\end{pmatrix}")
    return join(rv,"\n")
end

function savelatex(pcN,sp,rsp)
    rv = (String)[]

    for (i,plist) in enumerate(sp)
        for (j,p) in enumerate(plist)
            if p > 1e-3
                  pmatstr = pmatrix(pcN[i][j])
                  push!(rv,
                        string("\$", pmatstr, "\$", " & ",
                               "$(i)", " & ",
                               "$(round(rsp[i][j],3))", " & ",
                               "$(round(sp[i][j],3))", "\\\\"))
            end
        end
    end

    return join(rv,"\n")
end


flatten{T}(a::Array{T,1}) = any(map(x->isa(x,Array),a))? flatten(vcat(map(flatten,a)...)): a
flatten{T}(a::Array{T}) = reshape(a,prod(size(a)))
flatten(a)=a

function bin2dec(I::Array{Bool,1})

  # convert boolean array to an integer
  return parseint(join(map(x->convert(Int,x),I)),2)

end

function dec2bin(N::Integer)

  # convert integer to boolean array
  map(parseint,split(bits(N),""))

end

function genbinmats(N::Integer)

  return [reshape(dec2bin(i)[64-N^2+1:end],N,N) for i in 0:2^(N^2)-1]

end

function findpermclasses(N::Integer)
    # generate matrix representations of permutations
    permmats = [matrix(Permutation(i)) for i in permutations([1:N])][2:end]
    allbinmats = genbinmats(N)
    conjclassreps = (Array{Int64,2})[]

    for (i,mat) in enumerate(allbinmats)
        ind = true
        if bin2dec(bool(flatten(mat'))) < i-1
            ind = false
        end

        for p in permmats
            if bin2dec(bool(flatten((p*mat*inv(p))))) < i-1
                ind = false
            end

            if bin2dec(bool(flatten((p*mat*inv(p))'))) < i-1
                ind = false
            end
        end

        if ind
            push!(conjclassreps,mat)
        end
    end

    classbyconnect = Array(Array{Array{Int64,2}},N^2+1)
    for i in 0:N^2
        classbyconnect[i+1] = conjclassreps[find(x->sum(x)==i,conjclassreps)]
    end

    return classbyconnect
end

function sysstab(M::Array{Float64,2})

  # Continuous time system
  ec,vc = eig(M)

  # Discrete time system L = exp(M)
  # where exp is the matrix exponential
  # L = eye(M)+M+M^2/2+M^3/6
  # ed,vd = eig(L)

  # Print system matrices
  # println("Continuous system:")
  # println(M)
  # println("Discrete system:")
  # println(L)

  # return maximum(abs(e))/sqrt(N)
  # return maximum(abs(ed)), maximum(real(ec))
  return maximum(real(ec))

end

function teststab(N::Integer,K::Integer)
    # N system size
    # K sample size
    pcN = findpermclasses(N)
    # stabprob = zeros(length(pcN))
    stabprob = (Array{Float64,1})[]

    for (k,matlist) in enumerate(pcN)
        println(k)
        connectstabprob = zeros(length(matlist))
        for (i,mat) in enumerate(matlist)
            stabnum = 0
            for j=1:K
                if sysstab(mat.*randn(N,N)) < -1e-4
                    stabnum += 1
                end
            end
            connectstabprob[i] = stabnum/K
        end
        # stabprob[k] = mean(connectstabprob)
        push!(stabprob,connectstabprob)
    end

    return pcN, stabprob
end

function teststructstab(N::Integer,K::Integer)

    # N system size
    # K sample size

    println("test stability:")
    pcN, sp = teststab(N,K)

    restabprob = [zeros(s) for s in sp]

    println("test stability to perturbations:")
    for (k,plist) in enumerate(sp)

        for (l,p) in enumerate(plist)

            if p > 1e-3

                println("Connectivity $(k) matrix number $(l)")
                count = 0
                stabnum = 0
                restabnum = 0

                while stabnum < K

                    if count > 2.0*K/p
                        println("WARNING: maxed out after $(count) attempts with $(stabnum) samples for input sample size $(K)")
                        break
                    end

                    candidate = pcN[k][l].*randn(N,N)
                    if sysstab(candidate) < -1e-4
                        stabnum += 1
                        nzinds = find(x->x>0,pcN[k][l])
                        ind = nzinds[rand(1:length(nzinds))]
                        candidate[ind] = randn()
                        if sysstab(candidate) < -1e-4
                            restabnum += 1
                        end
                    end

                    count += 1

                end

                if stabnum == 0
                    restabprob[k][l] = 0.0
                else
                    restabprob[k][l] = restabnum/stabnum
                end

            end

        end

    end

    return sp,restabprob

end


