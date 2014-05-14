
# Calculate the p2-norm over dimension dim of the array x
vectornorm(x::Array,dim::Integer) = sqrt(sum(abs2(x),dim))
#
directionvector(x1::Vector,x2::Vector) = (x2-x1) / norm(x2-x1)
directionvector(x1::Array,x2::Array) = begin
    n = zeros(size(x1))
    for ii=1:size(x1,1)
        n[ii,:] = (x2[ii,:]-x1[ii,:]) / norm(x2[ii,:]-x1[ii,:])
    end
    return n
end
