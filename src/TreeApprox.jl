
#We start with a predefined tree. We already known the bushiness of the treee, number of stages in the tree, height of the tree,
#leaves in the tree, nodes of the tree e.t.c. The tree we start with is just random and is not good for stochastic approximation.
#Therefore, we take a path, either GaussianSamplePath or RunningMaximum and a number of scenarios and then try to improve this tree using the simulated path.
#The function Stochastic approximation tree takes a path, newtree, samplesize, p and Wassertein parameter = r.

using LinearAlgebra: norm, transpose

"""
<<<<<<< HEAD
<<<<<<< HEAD
	TreeApproximation!()
Returns a valuated probability scenario tree. Note that the inputs are in the following order: Tree(), path, sample size, 2,2

"""

function TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,pNorm::Int64=2,rwasserstein::Int64=2)
    leaf,omegas,probaLeaf = leaves(newtree)                      #leaves,omegas and probabilities of the leaves of the tree
    dm = size(newtree.state,2)                                   #We get the dim from the dimsention of the states we are working on.
    T = height(newtree)                                          #height of the tree
    n = length(leaf)                                             #number of leaves = no of omegas
=======
	TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,pNorm::Int64=2,rwasserstein::Int64=2)
=======
	TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,p::Int64=2,r::Int64=2)
>>>>>>> master

Returns a valuated probability scenario tree approximating the input stochastic process.

Args:
newtree - Tree with a certain branching structure,
genPath - function generating samples from the stochastic process to be approximated,
p - choice of norm (default p = 2 (Euclidean distance)), and,
r - transportation distance parameter
"""
function TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,p::Int64=2,r::Int64=2)
    leaf,omegas,probaLeaf = leaves(newtree)                               #leaves,omegas and probabilities of the leaves of the tree
    dm = size(newtree.state,2)                                            #We get the dim from the dimsention of the states we are working on.
    T = height(newtree)                                                   #height of the tree
    n = length(leaf)                                                      #number of leaves = no of omegas
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288
    d = zeros(Float64,dm,length(leaf))
    samplepath = zeros(Float64,T+1,dm)

    probaLeaf = zero(probaLeaf)
<<<<<<< HEAD
    probaNode = nodes(newtree)                                  #all nodes of the tree

    path_to_leaves = [root(newtree,i) for i in leaf]            # all the paths from root to the leaves
    path_to_all_nodes = [root(newtree,j) for j in probaNode]    # all paths to other nodes
=======
    probaNode = nodes(newtree)                                             #all nodes of the tree

    path_to_leaves = [root(newtree,i) for i in leaf]                       # all the paths from root to the leaves
    path_to_all_nodes = [root(newtree,j) for j in probaNode]               # all paths to other nodes
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288

    @inbounds for k = 1: samplesize
        critical = max(0.0,0.2*sqrt(k) - 0.1* n)
        #tmp = findall(xi -> xi <= critical, probaLeaf)
        tmp = Int64[inx for (inx,ppf) in enumerate(probaLeaf) if ppf <= critical]
<<<<<<< HEAD
        samplepath .= genPath(T+1,dm)                          #sample path (nStages,nPaths) i.e a new scenario path
=======
        samplepath .= genPath()                                           #sample path (nStages,nPaths) i.e a new scenario path
<<<<<<< HEAD
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288

        """
          This part addresses the critical probabilities of the tree so that we don't loose the branches
        """
<<<<<<< HEAD
=======

>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288
=======
        #The following part addresses the critical probabilities of the tree so that we don't loose the branches
>>>>>>> master
        if !isempty(tmp) && !iszero(tmp)
            probaNode = zero(probaNode)
            probaNode[leaf] = probaLeaf
            @inbounds for i = leaf
                while newtree.parent[i] > 0
                    probaNode[newtree.parent[i]] = probaNode[newtree.parent[i]] + probaNode[i]
                    i = newtree.parent[i]
                end
            end
            @inbounds for tmpi = tmp
                rt = path_to_leaves[tmpi]
<<<<<<< HEAD
                #rt = getindex(path_to_leaves,tmpi)
=======
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288
                #tmpi = findall(pnt -> pnt <= critical, probaNode[rt])
                tmpi = Int64[ind for (ind,pnt) in enumerate(probaNode[rt]) if pnt <= critical]
                newtree.state[rt[tmpi],:] .= samplepath[tmpi,:]
            end
        end
<<<<<<< HEAD

        #To the step STOCHASTIC COMPUTATIONS
                                    
        EndLeaf = 0 #start from the root

=======
        #To the step  of STOCHASTIC COMPUTATIONS
        EndLeaf = 0 #start from the root
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288
        for t = 1:T+1
            tmpleaves = newtree.children[EndLeaf+1]
            disttemp = Inf #or fill(Inf,dm)
            for i = tmpleaves
                dist = norm(view(samplepath, 1:t) - view(newtree.state, path_to_all_nodes[i]), p)
                if dist < disttemp
                    disttemp = dist
                    EndLeaf = i
                end
            end
        end
        #istar = findall(lf -> lf == EndLeaf, leaf)
        istar = Int64[idx for (idx,lf) in enumerate(leaf) if lf == EndLeaf]
<<<<<<< HEAD
        probaLeaf[istar] .= probaLeaf[istar] .+ 1.0
        StPath = path_to_leaves[EndLeaf-(leaf[1]-1)]          #counter 
        delta = newtree.state[StPath,:] - samplepath
        d[:,istar] .= d[:,istar] .+ norm(delta, pNorm).^(rwasserstein)
        delta .=  rwasserstein .* norm(delta, pNorm).^(rwasserstein - pNorm) .* abs.(delta)^(pNorm - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) .^ 0.75
=======
        probaLeaf[istar] .= probaLeaf[istar] .+ 1.0                                                            #counter  of probabilities
        StPath = path_to_leaves[EndLeaf-(leaf[1]-1)]
        delta = newtree.state[StPath,:] - samplepath
<<<<<<< HEAD
        d[:,istar] .= d[:,istar] .+ norm(delta, pNorm).^(rwasserstein)
        delta .=  rwasserstein .* norm(delta, pNorm).^(rwasserstein - pNorm) .* abs.(delta)^(pNorm - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) #.^ 0.75
>>>>>>> e9b1bc9cdc5c989ee6e99a1505eeecf47d22e288
=======
        d[:,istar] .= d[:,istar] .+ norm(delta, p).^(r)
        delta .=  r .* norm(delta, p).^(r - p) .* abs.(delta)^(p - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) #.^ 0.75        # sequence for convergence
>>>>>>> master
        newtree.state[StPath,:] = newtree.state[StPath,:] - delta .* ak
    end
    probabilities  = map(plf -> plf/sum(probaLeaf), probaLeaf) #divide every element by the sum of all elements
    transportationDistance = (d * hcat(probabilities) / samplesize) .^ (1/r)
    newtree.name = "Stochastic Approximation ,d=$(round.(transportationDistance,digits=5)),$(samplesize) scenarios"
    newtree.probability .= buildProb!(newtree,hcat(probabilities)) #build the probabilities of this tree
    return newtree
end
