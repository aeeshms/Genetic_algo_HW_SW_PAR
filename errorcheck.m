function finalrand= errorcheck(randpop,chromlen,popsize)
a=(zeros(popsize,chromlen));
[m,n]= size(randpop);
if(m ~= popsize)
    a(1:m,:)=randpop(:,:);
    finalrand=a;
else
    finalrand=randpop;
end

