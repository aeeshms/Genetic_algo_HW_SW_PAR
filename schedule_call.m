function[]=schedule_call(length_chromosome,random_population,input_mat,graph,y,z)
est(1)=0;
lst(1)=input_mat(1,y*random_population(1)+z)*input_mat(1,end);
%disp(lst(1));
for i=2:length_chromosome
    f=find(graph(i,:)==1);
    %disp(f);
     %len=length(f);
     %val=zeros(1,len);
    % for l=1:len
    %val(l)=est(f(l))+input_mat(f(l),y*random_population(f(l))+z);
    val=lst(f);
    % end
    estdummy1=max(val);
    estdummy2=0;zz=-1;
    for j=1:i-1
        if (random_population(j)==random_population(i));
            zz=j;
        end
    end
    if(zz>=0)
       estdummy2=lst(zz);
    end
    est(i)=max(estdummy1,estdummy2);
    lst(i)=est(i)+input_mat(i,y*random_population(i)+z)*input_mat(i,end);
        
end
for i=1:length_chromosome
disp(['node ',num2str(i),'   start = ',num2str(est(i)),'   end = ',num2str(lst(i))]);
end
