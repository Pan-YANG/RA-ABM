function [rain_field_esti,rain_field_var]=esti_rain_field_parfor(radar_field,rain_field_true,gauge_data,P_obs,X_obs,Y_obs,time_step,folder,loop_ID)
% function to estimate the rainfall field by merging radar, rain gauge and crowd-sourced observations

%%%%%% INPUTS %%%%%%
% radar_field is the radar estimated rainfall field
% rain_field_true is the ground truth rainfall field
% gauge_data is a structure containing information about the position and obs of rain gauges
%     gauge_data.X is the X positions of the rain gauges
%     gauge_data.Y is the Y positions of the rain gauges
%     gauge_data.obs is the obs of the rain gauges
% P_obs is the obs of the agents	(NA if agent is not participating)
% X_obs is the X positions of agents (NA if agent is not participating)
% Y_obs is the Y positions of agents (NA if agent is not participating)
% time_step is the current time step when merging is operated
% folder is the folder where the .csv files is written
% loop_ID is an indicator for the par pooling index

%%%%%% OUTPUTS %%%%%%
% rain_field_esti is the estimated rainfall field, and rain_field_var is the associated std

radar_field=radar_field(:,:,time_step);
rain_field_true=rain_field_true(:,:,time_step);

%% preparing data for radar obs
[X_Lim,Y_Lim]=size(radar_field); % set up the x and y positions of radar obs
radar_x=zeros(X_Lim,Y_Lim);
radar_y=zeros(X_Lim,Y_Lim);
for i=1:X_Lim
	for j=1:Y_Lim
		radar_x(i,j)=i-0.5;
		radar_y(i,j)=j-0.5;
	end
end

radar_x=radar_x(:);
radar_y=radar_y(:);
radar_obs=radar_field(:); 
rain_field_true_export=rain_field_true(:); % change the data into 1d array

%% preparing data for gauge obs
gauge_x=gauge_data.X_obs;
gauge_y=gauge_data.Y_obs;
gauge_obs=gauge_data.P_obs(:,time_step);
gauge_radar=diag(radar_field(ceil(gauge_x),ceil(gauge_y)));


%% preparing data for crowd obs
ID_inf=isinf(P_obs)|isnan(P_obs);
crowd_obs=P_obs(~ID_inf);
crowd_X=X_obs(~ID_inf);
crowd_Y=Y_obs(~ID_inf);
crowd_radar=diag(radar_field(ceil(crowd_X),ceil(crowd_Y)));
crowd_true=diag(rain_field_true(ceil(crowd_X),ceil(crowd_Y)));


if (sum(sum(gauge_obs)+sum(crowd_obs))==0)||(sum(radar_field(:)>0)<=20)
    rain_field_esti=zeros(X_Lim,Y_Lim);
    rain_field_var=zeros(X_Lim,Y_Lim);
else
    
    %% start exporting the data
    % radar
    file_name=sprintf('%s%s%s%s',folder,'radar_rainfall_',mat2str(loop_ID),'.csv');
    header{1}='x';
    header{2}='y';
    header{3}='radar';
    header{4}='TRUE';
    F_ID=fopen(file_name,'w');
    fprintf(F_ID,'%s,',header{1:end-1});
    fprintf(F_ID,'%s\n',header{end});
    fclose(F_ID);
    dlmwrite(file_name,[radar_x,radar_y,radar_obs,rain_field_true_export],'-append');

    % gauge
    file_name=sprintf('%s%s%s%s',folder,'gauge_rainfall_',mat2str(loop_ID),'.csv');
    header{1}='x';
    header{2}='y';
    header{3}='obs';
    header{4}='radar';
    F_ID=fopen(file_name,'w');
    fprintf(F_ID,'%s,',header{1:end-1});
    fprintf(F_ID,'%s\n',header{end});
    fclose(F_ID);
    dlmwrite(file_name,[gauge_x,gauge_y,gauge_obs,gauge_radar],'-append');

    % crowd
    file_name=sprintf('%s%s%s%s',folder,'crowd_rainfall_',mat2str(loop_ID),'.csv');
    header{1}='x';
    header{2}='y';
    header{3}='obs';
    header{4}='radar';
    F_ID=fopen(file_name,'w');
    fprintf(F_ID,'%s,',header{1:end-1});
    fprintf(F_ID,'%s\n',header{end});
    fclose(F_ID);
    dlmwrite(file_name,[crowd_X,crowd_Y,crowd_obs,crowd_radar],'-append');

    % both gauge and crowd
    file_name=sprintf('%s%s%s%s',folder,'gauge_crowd_rainfall_',mat2str(loop_ID),'.csv');
    header{1}='x';
    header{2}='y';
    header{3}='obs';
    header{4}='radar';
    F_ID=fopen(file_name,'w');
    fprintf(F_ID,'%s,',header{1:end-1});
    fprintf(F_ID,'%s\n',header{end});
    fclose(F_ID);
    dlmwrite(file_name,[[gauge_x;crowd_X],[gauge_y;crowd_Y],[gauge_obs;crowd_obs],[gauge_radar;crowd_radar]],'-append');    
    
%     % loop_ID
%     file_name=sprintf('%s%s',folder,'loop_ID.csv');
%     header='ID';
%     F_ID=fopen(file_name,'w');
%     fprintf(F_ID,'%s\n',header);
%     fclose(F_ID);
%     dlmwrite(file_name,[loop_ID],'-append');    

    %% run the R function and retrieve the data
    R_argument=sprintf('%s%s%s%s','"C:/Program Files/R/R-3.5.0/bin/Rscript" ',folder,'KED_merge_batch_loop.R ',mat2str(loop_ID));
    dos(R_argument);
    try
        rain_field_esti=dlmread(sprintf('%s%s%s%s',folder,'pred_export_',mat2str(loop_ID),'.csv'),',',1,1);
        rain_field_esti=rain_field_esti(:,1);
        rain_field_esti=reshape(rain_field_esti,X_Lim,Y_Lim);

        rain_field_var=dlmread(sprintf('%s%s%s%s',folder,'pred_var_',mat2str(loop_ID),'.csv'),',',1,1);
        rain_field_var=rain_field_var(:,1);
        rain_field_var=reshape(rain_field_var,X_Lim,Y_Lim);
    catch
        warning('+++++++++++++UNREASONABLE PREDICTIONS+++++++++++++++++')
        rain_field_esti=zeros(X_Lim,Y_Lim);
        rain_field_var=zeros(X_Lim,Y_Lim);
    end
end

end
