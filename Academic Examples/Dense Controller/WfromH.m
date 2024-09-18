function [W] = WfromH(H)
len = length(H);
W = zeros(len,1);
counter = 1;
for i = 1:len
    for j = i:len
        if i==j
            W(counter)=H(i,j);
            counter=counter+1;
        else
            W(counter)=2*H(i,j);
            counter=counter+1;
        end
    end
% end
% %         if i==j
% %             H(i,j)=W(counter);
% %             counter = counter + 1;
% %         else
% %             H(i,j)=W(counter)/2;
% %             H(j,i)=H(i,j);
% %             counter = counter + 1;
% %         end
%     end
% end
end