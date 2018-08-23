function saveTable2Latex(Mat, labels, filename)
% Mat - Matrix mxm
% labels - vector 1xm or mx1

if(length(labels)~=length(Mat))
   disp('The Labels array must be the same size of the square Matrix') 
end
TableStr = cell(size(Mat) + 1);
 
for j = 1:36
    TableStr{j,1} = labels(j);
end 

for i = 1:36
    TableStr{1,i} = [labels(i) ' & '];
    for j = 1:36
        if(Mat(j,i) == 0)
            TableStr{j+1,i+1} = '&   0   ';
        else
            TableStr{j+1,i+1} = num2str(Mat(j,i),'&  %.3f ');
        end
    end
end
i = 36;
for j = 1:36
    TableStr{j+1,i+1} = [TableStr{j+1,i+1} ' \\'];
end 

writetable(cell2table(TableStr),filename,'QuoteStrings', false, ...
                        'Delimiter',' ','WriteRowNames',false,...
                        'WriteVariableNames',false)
