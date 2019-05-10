function [pop_den]=cal_pop_den(X,Y,X_max,Y_max,window_size)
% function to calculate the spatial variability of a window with size window_size and centralized at the 
% position of a particular agent
%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%
% rain_field is the rainfall field estimated at the previous time step
% X and Y are the x and y positions of agents
% X_max and Y_max are the dimension of the study area
% window_size is the size of window where the density is calculated

N_agent=length(X);
pop_den=zeros(N_agent,1);

for i=1:N_agent
	
	if ceil(X(i))-(window_size-1)/2<1
		win_X_min=0;
        win_X_max=window_size;
	elseif ceil(X(i))+(window_size-1)/2>X_max
		win_X_min=X_max-window_size;
        win_X_max=X_max;
	else
		win_X_min=ceil(X(i))-(window_size-1)/2-1;
        win_X_max=ceil(X(i))+(window_size-1)/2;
	end
	
	if ceil(Y(i))-(window_size-1)/2<1
		win_Y_min=0;
        win_Y_max=window_size;
	elseif ceil(Y(i))+(window_size-1)/2>Y_max
		win_Y_min=Y_max-window_size;
        win_Y_max=Y_max;
	else
		win_Y_min=ceil(Y(i))-(window_size-1)/2-1;
        win_Y_max=ceil(Y(i))+(window_size-1)/2;
    end
	
    pop_in_window=(X>=win_X_min)&(X<=win_X_max)&(Y>=win_Y_min)&(Y<=win_Y_max);
	pop_den(i,1)=sum(pop_in_window)/(window_size*0.1)^2;

end

end