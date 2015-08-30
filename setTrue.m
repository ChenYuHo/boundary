function setTrue(stash, record)
   points = size(stash,2);
   while(points >= 3)
      point = stash(:,1);
      for row = -1:1:1
         for col = -1:1:1
            try
               record(point(1)+row, point(2)+col) = true;
            catch err
               if (strcmp(err.identifier,'MATLAB:badsubscript'))
               %Do Nothing
               else            
                  rethrow(err);  % rethrow any other errors
               end
            end
         end
      end
      stash = stash(:,2:points);
      points=points-1;
   end
end