using Permutations
using PyCall
# @pyimport numpy as np
@pyimport networkx as nx

macro R_str(s)
    s
end

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


function adjtograph(M::Array{Int64,2})
    # lines = split(replace(replace(string(M),"[",""),"]",""),"\n")
    rv = (String)[]
    headstring = R"\begin{tikzpicture}[scale=0.6,
every state/.style={draw=red!50,very thick,fill=red!20}]
\begin{dot2tex}[styleonly,codeonly,neato,mathmode]
digraph G {
d2ttikzedgelabels = true;
node [style=\"state\"];
edge [lblstyle=\"auto\",topath=\"bend left\",style=\"line width=1.5pt\"];"
    tailstring = R"}
\end{dot2tex}
\end{tikzpicture}"

    push!(rv,headstring)

    for i in 1:size(M)[1], j in 1:size(M)[2]
        if M[i,j] != 0
            if i != j
                push!(rv,string("$j -> $i\;"))
            else
                push!(rv,string("$j -> $i [topath=\"loop above\"]\;"))
            end
        end
    end

    push!(rv,tailstring)
    return join(rv,"\n")
end

function cyclenumber(adjmatlistlist)

    cyclecountlistlist = (Array{Int64,1})[]

    for (i,adjmatlist) in enumerate(adjmatlistlist)

        cyclecountlist = zeros(Int64,length(adjmatlist))

        for (j,adjmat) in enumerate(adjmatlist)
            g = nx.DiGraph(adjmat)
            cc = nx.simple_cycles(g)
            cc = pyeval("list(x)",x=cc)
            if length(cc)>0
                c = sum(map(x->length(x)>1,cc))
            else
                c = 0
            end
            cyclecountlist[j] = c
        end

        push!(cyclecountlistlist,cyclecountlist)

    end

    return cyclecountlistlist

end

function savelatex(pcN,sp,rsp)
    cn = cyclenumber(pcN)
    println(cn)
    rv = (String)[]

    for (i,plist) in enumerate(sp)
        for (j,p) in enumerate(plist)
            if p > 1e-3
                  # pmatstr = pmatrix(pcN[i][j])
                  pmatstr = adjtograph(pcN[i][j])
                  # string("\$", pmatstr, "\$", " & ",
                  push!(rv,
                        string(pmatstr, " & ",
                               "$(i-1)", " & ",
                               "$(cn[i][j])", " & ",
                               "$(round(rsp[i][j],3))", " & ",
                               "$(round(sp[i][j],3))", "\\\\"))
            end
        end
    end

    savedata("../data/stab3x3.tsv",sp,rsp,cn);

    return join(rv,"\n")
end

function savedata(filename,sp,rsp,cn)
    rv = (String)[]
    push!(rv,"connectivity\tstability\tresampling\tcycle")
    for (i,plist) in enumerate(sp)
        for (j,p) in enumerate(plist)
            if p > 1e-3
                  line = "$(i-1)\t$(sp[i][j])\t$(rsp[i][j])\t$(cn[i][j])"
                  push!(rv,line)
            end
        end
    end
    rv = join(rv,"\n")
    f = open(filename,"w")
    write(f,rv)
    close(f)
    return rv
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

function countorbitsize(M::Array{Int64,2})
    N = size(M)[1]
    # generate matrix representations of permutations
    permmats = [matrix(Permutation(i)) for i in permutations([1:N])]
    allbinmats = genbinmats(N)
    count = 0

    for (i,mat) in enumerate(allbinmats)

        ind = false
        if M' == mat
            ind = true
        end

        for p in permmats
            if p*M*inv(p) == mat
                ind = true
            end

            if (p*M*inv(p))' == mat
                ind = true
            end
        end

        if ind
            count += 1
        end

    end

    return count
end

function weightedavg(VW)

    # input is a tuple (vector, weights)
    inds = find(x->x>0,VW[1])
    relw = VW[2][inds]
    tot = sum(relw)

    return dot(relw/tot,VW[1][inds])

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

# @elapsed sp,rsp = teststructstab(3,10000)
# println(savelatex(pc3,sp,rsp))
# pc3 = findpermclasses(3)
# cn = cyclenumber(pc3)
# println(savedata("../data/stab3x3.tsv",sp,rsp,cn))
# os3 = map(x->map(countorbitsize,x),pc3)
# rspwa = map(weightedavg,zip(rsp,os3))
# spwa = map(weightedavg,zip(sp,os3))
