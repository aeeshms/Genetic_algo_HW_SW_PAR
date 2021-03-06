%GA for partitioning
%0 for software implementation and 1 for hardware implementation
%Read from xls file. Column (1) CPU1 time, (2) CPU2 time, (3) ASIC1 time,
%(4) ASIC2 time, (5) CPU1 cost (6)CPU2 cost (7) ASIC1 cost, (8)ASIC2 cost
%optimum result C1A1-130, C1A2-160, C2A1-110, C2A2-100
close all
clear all
clc
format long

input_mat=xlsread('test_8node.xlsx');
graph=xlsread('graph_8node.xlsx');
 [length_chromosome w]=size(input_mat);
%=========================================================================
deadline=input('enter deadline: ');
population_size=input('enter population size: ');
iteration=input('enter no of iteration: ');

%population_size=20; deadline=275; iteration=500;
loop=5;
%=========================================================================
% GENERATE RANDOM POPULATION
random_population=random_pop(length_chromosome,population_size);
    random_population1=random_population;
    random_population2=random_population;
    random_population3=random_population;
    random_population4=random_population;
    
    % OUTPUT-
%random_population;
%=========================================================================
% % 
for l=1:loop
for no_iteration=1:iteration
% %=========================================================================
    random_population1_dummy=random_population1;
    random_population2_dummy=random_population2;
    random_population3_dummy=random_population3;
    random_population4_dummy=random_population4;


 % FITNESS VALUE EVALUATION DUE TO EACH CHROMOSOME
 for i=1:population_size
        time1=0;cost1=0;dummy1=0;time2=0;cost2=0;dummy2=0;
        time3=0;cost3=0;dummy3=0;time4=0;cost4=0;dummy4=0;
      for j=1:length_chromosome
          %%%###comment lines if you want parallel execution
% %            time1=time1+input_mat(j,2*random_population1(i,j)+1);
% %            time2=time2+input_mat(j,3*random_population2(i,j)+1);
% %            time3=time3+input_mat(j,random_population3(i,j)+2);
% %            time4=time4+input_mat(j,2*random_population4(i,j)+2);
           %%%###
          if(dummy1==0 || random_population1(i,j)==1)
             cost1=cost1+input_mat(j,2*random_population1(i,j)+5);
             if(random_population1(i,j)==0)
                dummy1=1;
             end
          end
          if(dummy2==0 || random_population2(i,j)==1)
             cost2=cost2+input_mat(j,3*random_population2(i,j)+5);
             if(random_population2(i,j)==0)
                dummy2=1;
             end
          end
          if(dummy3==0 || random_population3(i,j)==1)
             cost3=cost3+input_mat(j,random_population3(i,j)+6);
             if(random_population3(i,j)==0)
                dummy3=1;
             end
          end
          if(dummy4==0 || random_population4(i,j)==1)
             cost4=cost4+input_mat(j,2*random_population4(i,j)+6);
             if(random_population4(i,j)==0)
                dummy4=1;
             end
          end 
      end
      %%### comment lines if you want serial execution
      time1=parallel_time(length_chromosome,random_population1(i,:),input_mat,graph,2,1);
      time2=parallel_time(length_chromosome,random_population2(i,:),input_mat,graph,3,1);
      time3=parallel_time(length_chromosome,random_population3(i,:),input_mat,graph,1,2);
      time4=parallel_time(length_chromosome,random_population4(i,:),input_mat,graph,2,2);
      %%###
      tot_time(1,i)=time1;
      tot_cost(1,i)=cost1;
      tot_time(2,i)=time2;
      tot_cost(2,i)=cost2;
      tot_time(3,i)=time3;
      tot_cost(3,i)=cost3;
      tot_time(4,i)=time4;
      tot_cost(4,i)=cost4;
      if(time1>deadline)
          fitness_value(1,i)=1000*(time1-deadline)+cost1;
      else
          fitness_value(1,i)=cost1;
      end
      if(time2>deadline)
          fitness_value(2,i)=1000*(time2-deadline)+cost2;
      else
          fitness_value(2,i)=cost2;
      end
      if(time3>deadline)
          fitness_value(3,i)=1000*(time3-deadline)+cost3;
      else
          fitness_value(3,i)=cost3;
      end
      if(time4>deadline)
          fitness_value(4,i)=1000*(time4-deadline)+cost4;
      else
          fitness_value(4,i)=cost4;
      end
 end
%  random_population_temp=random_population;
% %OUTPUT-
 %fitness_value
% %=========================================================================
% % SUM OF FITNESS FUNCTION VALUE
for s=1:4
 sum_fitness_value(s)=sum(fitness_value(s,:));
end
% % OUTPUT-
% fprintf('THE VALUE OF FITNESS FUNCTION AFTER %d ITERATION:\n',no_iteration);
% sum_fitness_value
% % % =========================================================================
% PROBABILITY EVALUATION DUE TO EACH CHROMOSOME
for s=1:4
st(s,:)=sort(fitness_value(s,:));
end
for i=1:population_size
for s=1:4
ff=find(st(s,:)==fitness_value(s,i));
ff_min=min(ff);
st_dummy(s,i)=(sum_fitness_value(s)+1)*(population_size+1-ff_min);
%st_dummy(i)=(sum_fitness_value+1);
for j=1:ff_min
st_dummy(s,i)=st_dummy(s,i)-st(s,j);
end
end
end

probability_value_dummy=st_dummy;
for s=1:4
  sum_probability_value_dummy(s)=sum(probability_value_dummy(s,:));
end
 for i=1:population_size
     for s=1:4
    probability_value(s,i)=probability_value_dummy(s,i)/sum_probability_value_dummy(s);
     end
 end
% OUTPUT-
% probability_value;
% %=========================================================================
% % CUMULATIVE PROBABILITY EVALUATION DUE TO EACH CHROMOSOME
for s=1:4 
cum_probability_value(s,1)=probability_value(s,1);
end
 for i=2:population_size
     for s=1:4
     cum_probability_value(s,i)=probability_value(s,i)+cum_probability_value(s,i-1);
     end
 end
%  OUTPUT-
% cum_probability_value;
% %=========================================================================

% % SELECTION
% % FOR ROULETTE WHEEL SLECTION, RANDOM NUMBER r IS GENERATED BETWEEN RANGE 
% % 0 AND 1.
 for i=1:population_size
     for s=1:4
     roulette_wheel(s,i)=rand;
     end
 end
 for i=1:population_size
     for j=2:population_size
         if roulette_wheel(1,i)>cum_probability_value(1,j-1) && roulette_wheel(1,i)<=cum_probability_value(1,j)
             new_random_population1(i,:)=random_population1(j,:);
         end 
          if roulette_wheel(2,i)>cum_probability_value(2,j-1) && roulette_wheel(2,i)<=cum_probability_value(2,j)
             new_random_population2(i,:)=random_population2(j,:);
          end 
          if roulette_wheel(3,i)>cum_probability_value(3,j-1) && roulette_wheel(3,i)<=cum_probability_value(3,j)
             new_random_population3(i,:)=random_population3(j,:);
          end 
          if roulette_wheel(4,i)>cum_probability_value(4,j-1) && roulette_wheel(4,i)<=cum_probability_value(4,j)
             new_random_population4(i,:)=random_population4(j,:);
          end 
     end
 end
% % OUTPUT-
% % roulette_wheel;
% % new_random_population;
%=========================================================================

% CROSSOVER
  new_random_population_cross1=crossover(length_chromosome,new_random_population1,population_size);
  new_random_population_cross2=crossover(length_chromosome,new_random_population2,population_size);
  new_random_population_cross3=crossover(length_chromosome,new_random_population3,population_size);
  new_random_population_cross4=crossover(length_chromosome,new_random_population4,population_size);
  new_random_population_cross1=errorcheck(new_random_population_cross1,length_chromosome,population_size);
  new_random_population_cross2=errorcheck(new_random_population_cross2,length_chromosome,population_size);
  new_random_population_cross3=errorcheck(new_random_population_cross3,length_chromosome,population_size);
  new_random_population_cross4=errorcheck(new_random_population_cross4,length_chromosome,population_size);
% OUTPUT-
%new_random_population_cross;
%==========================================================================

% MUTATION
  new_random_population_mut1=mutation(length_chromosome,population_size,new_random_population_cross1);
  new_random_population_mut2=mutation(length_chromosome,population_size,new_random_population_cross2);
  new_random_population_mut3=mutation(length_chromosome,population_size,new_random_population_cross3);
  new_random_population_mut4=mutation(length_chromosome,population_size,new_random_population_cross4);
  new_random_population_mut1=errorcheck(new_random_population_mut1,length_chromosome,population_size);
  new_random_population_mut2=errorcheck(new_random_population_mut2,length_chromosome,population_size);
  new_random_population_mut3=errorcheck(new_random_population_mut3,length_chromosome,population_size);
  new_random_population_mut4=errorcheck(new_random_population_mut4,length_chromosome,population_size);
% OUTPUT-
%new_random_population_mut;
%==========================================================================
 random_population1=new_random_population_mut1;
 random_population2=new_random_population_mut2;
 random_population3=new_random_population_mut3;
 random_population4=new_random_population_mut4;
end

for s=1:4
  final_fitness(s,l)=min(fitness_value(s,:));
  loc=find(fitness_value(s,:)==final_fitness(s,l));
  location=min(loc);
  final_time(s,l)=tot_time(s,location);
  if(s==1)
  pattern1(l,:)=random_population1_dummy(location,:);
  end
  if(s==2)
  pattern2(l,:)=random_population2_dummy(location,:);
  end
  if(s==3)
   pattern3(l,:)=random_population3_dummy(location,:);
  end
  if(s==4)
     pattern4(l,:)=random_population4_dummy(location,:);
  end
end
% % %   pattern1(l,:)=random_population1_dummy(location,:);
% % %   pattern2(l,:)=random_population2_dummy(location,:);
% % %   pattern3(l,:)=random_population3_dummy(location,:);
% % %   pattern4(l,:)=random_population4_dummy(location,:);
  
%   %OUTPUT-
%  final_fitness(l);
%  final_time(l);
%  pattern(l,:);
end
  for s=1:4
   
   FITNESS(s)=min(final_fitness(s,:));
   loc=min(find(final_fitness(s,:)==FITNESS(s)));
   TIME(s)=final_time(s,loc);
   if(s==1)
   PATTERN(s,:)=pattern1(loc,:);
   end
   if(s==2)   
   PATTERN(s,:)=pattern2(loc,:);
   end
   if(s==3)
   PATTERN(s,:)=pattern3(loc,:);
   end
   if(s==4)
   PATTERN(s,:)=pattern4(loc,:);
   end
  end
  
  %%%%%%###########DISPLAY
  disp('CPU1 AND ASIC1');
  disp(['PATTERN = ',num2str(PATTERN(1,:))]);
  disp(['COST = ',num2str(FITNESS(1)),'   TIME = ',num2str(TIME(1))]);
  schedule(length_chromosome,PATTERN(1,:),input_mat,graph,2,1);
  disp('########');
  disp('CPU1 AND ASIC2');
  disp(['PATTERN = ',num2str(PATTERN(2,:))]);
  disp(['COST = ',num2str(FITNESS(2)),'   TIME = ',num2str(TIME(2))]);
  schedule(length_chromosome,PATTERN(2,:),input_mat,graph,3,1);
  disp('#######');
  disp('CPU2 AND ASIC1');
  disp(['PATTERN = ',num2str(PATTERN(3,:))]);
  disp(['COST = ',num2str(FITNESS(3)),'   TIME = ',num2str(TIME(3))]);
  schedule(length_chromosome,PATTERN(3,:),input_mat,graph,1,2);
  disp('#######');
  disp('CPU2 AND ASIC2');
  disp(['PATTERN = ',num2str(PATTERN(4,:))]);
  disp(['COST = ',num2str(FITNESS(4)),'   TIME = ',num2str(TIME(4))]);
  schedule(length_chromosome,PATTERN(4,:),input_mat,graph,2,2);
  