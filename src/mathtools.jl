# Transform from spherical to cartesian coordinate system
sph2cart(phi,theta,r) = r.*cos(theta).*cos(phi), r.*cos(theta).*sin(phi), r.*sin(theta).+0.*phi

# Calculate the p2-norm over dimension dim of the array x
vectornorm(x::Array,dim::Integer) = vec(sqrt(sum(abs2(x),dim)))
# Calculate the vector product for vectors stored in a matrix
vectorproduct(x1::Array,x2::Array,dim::Integer) = vec(sum(x1.*x2,dim))
# Return the direction vector pointing from to x1 to x2
directionvector(x1::Vector,x2::Vector) = (x2-x1) / norm(x2-x1)
directionvector(x1::Matrix,x2::Vector)  = (x2'.-x1) ./ vectornorm(x2'.-x1,2)
directionvector(x1::Vector,x2::Matrix)  = -directionvector(x2,x1)
directionvector(x1::Matrix,x2::Matrix)   = begin
    @assert size(x1,1)==size(x2,1)
    n = zeros(size(x1))
    for ii=1:size(x1,1)
        n[ii,:] = (x2[ii,:]-x1[ii,:]) / norm(x2[ii,:]-x1[ii,:])
    end
    return n
end
