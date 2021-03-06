function[chrom1]=crossover(m,chrom1,population_size)
crossover_prob=0.5;
%__________________________________________________________________________
for i=1:population_size
    %GENERATE A RANDOM NUMBER r from the range [0 1]
    r_crossover(i)=rand;
end
%__________________________________________________________________________

crossover_chrom=[];
%__________________________________________________________________________
%SELECT THE GIVEN CHROMOSOME FOR r<0.5
%START
k=1;
for i=1:population_size
    if r_crossover(i) <crossover_prob
        crossover_chrom(k)=i;
        k=k+1;
    end
end
%END
%__________________________________________________________________________

%__________________________________________________________________________
%IF THE NO OF CHROMOSOMES SELECTED FOR CROSSOVER ARE ODD
%START
if(~isempty(crossover_chrom))
if rem(length(crossover_chrom),2)==1
    sorted_r_crossover=sort(r_crossover);
    for i=1:population_size
        if sorted_r_crossover(i)>crossover_prob 
            temp=sorted_r_crossover(i);
            break
        end
    end
    for i=1:population_size
        if r_crossover(i)==temp
            crossover_chrom(k)=i;
        end
    end
end
%END
%__________________________________________________________________________

%__________________________________________________________________________
%GENERATE A RANDOM POSITION FROM THE RANGE [1 33] FOR EACH
%CHROMOSOME TO CROSSOVER
%START
no_pos=length(crossover_chrom)/2;
for i=1:no_pos
    pos=randint(1,no_pos,[1 m]);
end
%END
%__________________________________________________________________________

%__________________________________________________________________________
%CROSSOVER
%START
for i=1:2:no_pos
%chrom1(crossover_chrom(i),:)  chk
%chrom1(crossover_chrom(i+1),:)  chk
    perm1=chrom1(crossover_chrom(i),1:pos(i));
    temp1=chrom1(crossover_chrom(i),(pos(i)+1):m);
    perm2=chrom1(crossover_chrom(i+1),1:pos(i));
    temp2=chrom1(crossover_chrom(i+1),(pos(i)+1):m);
    chrom1(crossover_chrom(i),:)=[perm1 temp2];
    chrom1(crossover_chrom(i+1),:)=[perm2 temp1];
%chrom1(crossover_chrom(i),:) check
%chrom1(crossover_chrom(i+1),:)check
end
end
%END
%__________________________________________________________________________



