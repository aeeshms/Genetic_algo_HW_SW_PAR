function [chrom]=random_pop(m,population_size)
chrom=zeros(population_size,m);
for i=1:population_size
    chrom(i,:)=randint(1,m,[0 1]);
end