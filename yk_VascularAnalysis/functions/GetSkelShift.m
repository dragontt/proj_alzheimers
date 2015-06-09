function shift=GetSkelShift(Skel,Skel2)
% This function computes skeleton point shift after auto-alginment. It
% outputs shift of individual points, stats of individual skeleton and
% overall skeletons.

shift=struct;
shift.IndivShift=cell(1,size(Skel,2));
shift.ListShiftAvg=zeros(size(Skel,2),1);
shift.ListShiftStd=zeros(size(Skel,2),1);
shift.OverallShiftAvg=[];
shift.OverallShiftStd=[];

shiftList=NaN(100,1);
counter=0;
for i=1:size(Skel,2)
    tmpShiftXYZ=Skel{1,i}-Skel2{1,i};
    tmpShiftDist=sqrt(tmpShiftXYZ(:,1).^2+tmpShiftXYZ(:,2).^2+tmpShiftXYZ(:,3).^2);
    if counter+length(tmpShiftDist)+1<=length(shiftList)
        shiftList(counter+1:counter+length(tmpShiftDist))=tmpShiftDist;
        counter=counter+length(tmpShiftDist);
    else
        shiftList(length(shiftList)+1:length(shiftList)+100)=NaN(1,100);
        shiftList(counter+1:counter+length(tmpShiftDist))=tmpShiftDist;
        counter=counter+length(tmpShiftDist);
    end
    tmpShiftAvg=mean(tmpShiftDist);
    tmpShiftStd=std(tmpShiftDist);
    
    shift.IndivShift{i}.ShiftXYZ=tmpShiftXYZ;
    shift.IndivShift{i}.ShiftDist=tmpShiftDist;
    shift.ListShiftAvg(i)=tmpShiftAvg;
    shift.ListShiftStd(i)=tmpShiftStd;
    shift.IndivShift{i}.ShiftAvg=tmpShiftAvg;
    shift.IndivShift{i}.ShiftStd=tmpShiftStd;
end
shiftList=shiftList';
shiftList(any(isnan(shiftList),1))=[];

shift.OverallShiftAvg=mean(shiftList);
shift.OverallShiftStd=std(shiftList);
