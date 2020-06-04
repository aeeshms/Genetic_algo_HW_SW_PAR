%GA for partitioning
%0 for software implementation and 1 for hardware implementation
%Read from xls file. Column (1) s/w time, (2) h/w time, (3) s/w cost and
%(4)h/w cost
close all
clear all
clc
format long

input_mat=xlsread('test.xlsx');
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
% OUTPUT-
%random_population;
%===========================================================================
% 
 for l=1:loop
 for no_iteration=1:iteration
% %=========================================================================
 % FITNESS VALUE EVALUATION DUE TO EACH CHROMOSOME
 for i=1:population_size
        time=0;cost=0;dummy=0;
      for j=1:length_chromosome      
		  time=time+input_mat(j,random_population(i,j)+1);
          if(dummy==0 || random_population(i,j)==1)
             cost=cost+input_mat(j,random_population(i,j)+3);
             if(random_population(i,j)==0)
                dummy=1;
             end
          end
      end
      tot_time(i)=time;
      tot_cost(i)=cost;
      if(cost>deadline)
          fitness_value(i)=1000*(cost-deadline)+time;
      else
          fitness_value(i)=time;
      end
 end
 random_population_temp=random_population;
% %OUTPUT-
 %fitness_value
% %=========================================================================
% % SUM OF FITNESS FUNCTION VALUE
 sum_fitness_value=sum(fitness_value);
% % OUTPUT-
% fprintf('THE VALUE OF FITNESS FUNCTION AFTER %d ITERATION:\n',no_iteration);
% sum_fitness_value
% %=========================================================================
% % PROBABILITY EVALUATION DUE TO EACH CHROMOSOME
st=sort(fitness_value);
for i=1:population_size

ff=find(st==fitness_value(i));
ff_min=min(ff);
st_dummy(i)=(sum_fitness_value+1)*(population_size+1-ff_min);
%st_dummy(i)=(sum_fitness_value+1);
for j=1:ff_min
st_dummy(i)=st_dummy(i)-st(j);
end
end

probability_value_dummy=st_dummy;

  sum_probability_value_dummy=sum(probability_value_dummy);
 for i=1:population_size
 probability_value(i)=probability_value_dummy(i)/sum_probability_value_dummy;
 end
% % OUTPUT-
% probability_value;
% %=========================================================================
% % CUMULATIVE PROBABILITY EVALUATION DUE TO EACH CHROMOSOME
 cum_probability_value=probability_value(1);
 for i=2:population_size
     cum_probability_value(i)=probability_value(i)+cum_probability_value(i-1);
 end
 % OUTPUT-
% cum_probability_value;
% %=========================================================================

% SELECTION
% FOR ROULETTE WHEEL SLECTION, RANDOM NUMBER r IS GENERATED BETWEEN RANGE 
% 0 AND 1.
 for i=1:population_size
     roulette_wheel(i)=rand;
 end
 for i=1:population_size
     for j=2:population_size
         if roulette_wheel(i)>cum_probability_value(j-1) && roulette_wheel(i)<=cum_probability_value(j)
             new_random_population(i,:)=random_population(j,:);
          end 
     end
 end
%OUTPUT-
%roulette_wheel;
%new_random_population;
%=========================================================================

% CROSSOVER
 new_random_population_cross=crossover(length_chromosome,new_random_population,population_size);
% OUTPUT-
%new_random_population_cross;
%==========================================================================

% MUTATION
 new_random_population_mut=mutation(length_chromosome,population_size,new_random_population_cross);
% OUTPUT-
%new_random_population_mut;
%==========================================================================
random_population=new_random_population_mut;
 end
 final_fitness(l)=min(fitness_value);
 loc=find(fitness_value==final_fitness(l));
 location=min(loc);
 pattern(l,:)=random_population(location,:);
 final_cost(l)=tot_cost(location);
  %OUTPUT-
 final_fitness(l);
 final_cost(l);
 pattern(l,:);
 end
  FITNESS=min(final_fitness)
  loc=min(find(final_fitness==FITNESS));
  COST=final_cost(loc)
  PATTERN=pattern(loc,:)