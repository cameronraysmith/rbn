using Permutations

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

