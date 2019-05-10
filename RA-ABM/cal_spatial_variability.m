function [spatial_variability]=cal_spatial_variability(rain_field,X,Y,X_max,Y_max,window_size)
% function to calculate the spatial variability of a window with size window_size and centralized at the 
% position of a particular agent
%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%
% rain_field is the rainfall field estimated at the previous time step
% X and Y are the x and y positions of agents
% X_max and Y_max are the dimension of the study area
% window_size is the size of window where the density is calculated

N_agent=length(X);
spatial_variability=zeros(N_agent,1);

for i=1:N_agent
	
	if ceil(X(i))-(window_size-1)/2<1
		XID=1:window_size;
	elseif ceil(X(i))+(window_size-1)/2>X_max
		XID=X_max-window_size+1:X_max;
	else
		XID=ceil(X(i))-(window_size-1)/2:ceil(X(i))+(window_size-1)/2;
	end
	
	if ceil(Y(i))-(window_size-1)/2<1
		YID=1:window_size;
	elseif ceil(Y(i))+(window_size-1)/2>Y_max
		YID=Y_max-window_size+1:Y_max;
	else
		YID=ceil(Y(i))-(window_size-1)/2:ceil(Y(i))+(window_size-1)/2;
    end
	
    rain_field_in_window=rain_field(XID,YID);
	spatial_variability(i,1)=std(rain_field_in_window(:));

end

end