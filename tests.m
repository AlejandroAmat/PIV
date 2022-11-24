%for i = 2 : li-1
%     for j = 2 : wi-1
%          pos1 = bin_cb(i,j);
%          pos_y1 = bin_cr(i,j);
%         
%            
%          prob = histcountPielNormalized (pos1, pos_y1);
%          prob_b = histcountFondoNormalized(pos1, pos_y1);
%          
%          prob2 = histcountPielNormalized (pos1-1, pos_y1);
%          prob_b2 = histcountFondoNormalized(pos1-1, pos_y1);
%          prob3 = histcountPielNormalized (pos1+1, pos_y1);
%          prob_b3 = histcountFondoNormalized(pos1+1, pos_y1);
%          prob4 = histcountPielNormalized (pos1, pos_y1 +1);
%          prob_b4 = histcountFondoNormalized(pos1, pos_y1+1);
%          
%          
%          
%          
%          if((prob+prob2+prob3+prob4)*0.5 < (prob_b + prob_b2 + prob_b3+ prob_b4))
%             mask_image(i,j) = 1; 
%          end
%          
%     end