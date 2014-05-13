
# Calculate the p2-norm over dimension dim of the array x
vectornorm(x::Array,dim::Integer) = sum(abs(x).^2,dim).^(1/2)
