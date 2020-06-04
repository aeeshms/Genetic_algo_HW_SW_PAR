function[random_population]=mutation(length_chromosome,population_size,random_population)
mutation_prob=0.02;
total_bits=length_chromosome*population_size;
for i=1:total_bits
    %GENERATE A RANDOM NUMBER r from the range [0 1]
    r_mutation(i)=rand;
end

%START
k=1;
mutation_chrom=[];
for i=1:total_bits
    if r_mutation(i) <mutation_prob
        mutation_chrom(k)=i;
        k=k+1;
    end
end
%END
if(~isempty(mutation_chrom))
for i=1:length(mutation_chrom)
    x=floor(mutation_chrom(i)/length_chromosome)+1;
    y=rem(mutation_chrom(i),length_chromosome);
    if y==0
        x=x-1;
        y=length_chromosome;
    end
    if random_population(x,y)==1
        random_population(x,y)=0;
    elseif random_population(x,y)==0
        random_population(x,y)=1;
    end
end
end

        

