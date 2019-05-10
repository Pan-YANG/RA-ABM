function [ARE_P,RMSE]=cal_rain_error(rain_field_true,rain_field_esti)

ARE_P=abs(mean(mean(mean(rain_field_esti)))-mean(mean(mean(rain_field_true))))/...
    (mean(mean(mean(rain_field_true))));
RMSE=sqrt(mean(mean(mean((rain_field_esti-rain_field_true).^2))));

end
