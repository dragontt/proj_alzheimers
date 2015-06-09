function stats=ComputeGaussFit(stats)
% This function computes gaussian fit of stats data, yielding fit function
% in second row of cell structure.

stats.Gauss_Diameter={};
stats.Gauss_Skewness={};
stats.Gauss_Kurtosis={};
stats.Gauss_Length={};
stats.Gauss_Tortuosity={};
stats.Gauss_Depth={};

try
    tmp1=stats.Diameter;
    f=fit(tmp1(:,1),tmp1(:,3)*100,'gauss1');
    stats.Gauss_Diameter=f;
% catch
%     msg=sprintf('No Gaussian fit of diameter.\n');
%     error('prog:input',msg);
end

try
    tmp2=stats.Skewness;
    f=fit(tmp2(:,1),tmp2(:,3)*100,'gauss1');
    stats.Gauss_Skewness=f;
% catch
%     msg=sprintf('No Gaussian fit of skewness.\n');
%     error('prog:input',msg);
end

try
    tmp3=stats.Kurtosis;
    f=fit(tmp3(:,1),tmp3(:,3)*100,'gauss1');
    stats.Gauss_Kurtosis=f;
% catch
%     msg=sprintf('No Gaussian fit of kurtosis.\n');
%     error('prog:input',msg);
end

try
    tmp4=stats.Length;
    f=fit(tmp4(:,1),tmp4(:,3)*100,'gauss1');
    stats.Gauss_Length=f;
% catch
%     msg=sprintf('No Gaussian fit of length.\n');
%     error('prog:input',msg);
end

try
    tmp5=stats.Tortuosity;
    f=fit(tmp5(:,1),tmp5(:,3)*100,'gauss1');
    stats.Gauss_Tortuosity=f;
% catch
%     msg=sprintf('No Gaussian fit of tortuosity.\n');
%     error('prog:input',msg);
end

try
    tmp6=stats.Depth;
    f=fit(tmp6(:,1),tmp6(:,3)*100,'gauss1');
    stats.Gauss_Depth=f;
% catch
%     msg=sprintf('No Gaussian fit of depth.\n');
%     error('prog:input',msg);
end