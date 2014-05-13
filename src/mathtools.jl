
# Calculate the p2-norm over dimension dim of the array x
vectornorm(x::Array,dim::Integer) = sqrt(sum(abs2(x),dim))
