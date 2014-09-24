function avgconnectcycle(infilename)
  rv = (String)[]
  push!(rv,"connectivity\tstability\tresampling\tcycle\tdistance")

  dat, head = readdlm(infilename,header=true)

  for i in unique(dat[:,1]), j in unique(dat[:,4])

    ind_1 = find(x->x==i,dat[:,1])
    ind_2 = find(x->x==j,dat[:,4])
    inds = intersect(ind_1,ind_2)
    if length(inds)>0
        avgstab = round(mean(dat[inds,2:3],1),4)
        line = "$(i)\t$(avgstab[1])\t$(avgstab[2])\t$(j)\t$(dat[inds[1],5])"
        # line = "$(i)\t$(avgstab[1])\t$(avgstab[2])\t$(dat[inds[1],4])\t$(j)"
        push!(rv,line)
    end

  end

  rv = join(rv,"\n")
  f = open("avgconnectcycle.tsv","w")
  write(f,rv)
  close(f)
  return rv

end

function avgconnectdist(infilename)
  rv = (String)[]
  push!(rv,"connectivity\tstability\tresampling\tcycle\tdistance")

  dat, head = readdlm(infilename,header=true)

  for i in unique(dat[:,1]), j in unique(dat[:,5])

    ind_1 = find(x->x==i,dat[:,1])
    ind_2 = find(x->x==j,dat[:,5])
    inds = intersect(ind_1,ind_2)

    if length(inds)>0
        avgstab = round(mean(dat[inds,2:3],1),4)

        # line = "$(i)\t$(avgstab[1])\t$(avgstab[2])\t$(j)\t$(dat[inds[1],5])"
        line = "$(i)\t$(avgstab[1])\t$(avgstab[2])\t$(dat[inds[1],4])\t$(j)"
        push!(rv,line)
    end

  end

  rv = join(rv,"\n")
  f = open("avgconnectdist.tsv","w")
  write(f,rv)
  close(f)
  return rv

end
