function hundredList = hundredRuns(RECORDS,FEATURES,ratio) %convenience split data 100 times and run test
        %only function that actually needs to be run by the USER
        %creates 100 trees
        %runs 100 tests
        %retusn average error

        meanList = [];
        errorlist = [];

            
        for x = 1:100
             t = Tree();
             try
            [TRAIN,TEST] = t.splitData(RECORDS,ratio);
            t.createTree(TRAIN,FEATURES);
            error = t.test(TEST,FEATURES);
            errorlist = [errorlist,error];
             catch
                 warning('error list unchanged');

             end
        end
                 %meanList = [meanList;mean(errorlist)];

        
            hundredList = mean(errorlist);
            
end