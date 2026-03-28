%Keona Arneson

%filters out the parsed data
%finds the best fitting VsigAC and finds the correlating Pout
%calculates a tolerance of this fit
%plots Param vs Pout

%ONLY WORKS FOR LINEAR .STEP

%raw_data = parsethd;
%writetable(raw_data,'raw_VsigDC.csv');

param = table2array(raw_data(:,"vin"));
start = min(param);
stop = max(param);

for i = 2:length(param) %finds the increment value for the .step
    if param(i-1) == param(i)
        continue;
    else
        increment = param(i) - param(i-1);
    end
end
increment = round(increment,8);
steps = start:increment:stop;
values = 100.*ones(int32((stop-start+increment)/increment),3);
values(:,1) = steps.';
values(:,3) = zeros(height(values),1); %col 1 = param, col 2 = thd difference (%), 3 = Pout

for i = 0:((stop-start)/increment) %filters through raw_Vs to find smallest thd difference, outputs it into value
    for j = 1:height(raw_data)
        if isapprox((i*increment+start),table2array(raw_data(j,1)))
            if values(i+1,2) > abs(table2array(raw_data(j,3))-1)
                values(i+1,2) = abs(table2array(raw_data(j,3)) - 1); % Update thd difference
                values(i+1,3) = table2array(raw_data(j,4)); % Update Pout
            end
        end
    end
end

tolerance = max(values(:,2));

plot(values(:,1), values(:,3));
ylabel('Pout (W)');
xlabel('Param');
title('Plot of Pout vs .step param');
grid on;
