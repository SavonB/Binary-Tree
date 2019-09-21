            function x = stop_cond(RECORDS,FEATURES) %Handles Base Cases, given full training set to test base cases
                    %if survived is the most homgenous them make that a stop condition to
                    %prevent overfitting
                   
                    homog = Node().find_most_homog(RECORDS,FEATURES);
                    homogFEAT = cell2mat(homog(1)); %str
                    homogERROR = cell2mat(homog(2)); %num
                    [M,N] = size(RECORDS);
                    for x = 1:M%for each row, check to see if homogeneity on that feature is 1
                        sum1 = 0;
                        sum0 = 0;
                        for y = 1:N
                            if RECORDS(x,y) == 1
                                sum1 = sum1+1;
                            else
                                sum0 = sum0+1;
                            end %end if
                        end%end inner for
                    end %end for

                    %1. If all data belong to the same class (survived), pick that label (The
                    %latter of each condition is handled in main program
                    if homogERROR == 0 | homogERROR == 1
                        x = homogERROR == 0 | homogERROR == 1;

                        return
                    %2. If all the data have the same feature values (Embarked =1), pick
                    %majority label (survived if embarked = 1)

                    %3. If we’re out of features to examine, pick majority label
                    %features is empty
                    elseif isempty(FEATURES)
                        x = isempty(FEATURES);
                        return
                    elseif isempty(RECORDS)
                        x = isempty(RECORDS);
                        return%
                    elseif isempty(setdiff(homogFEAT(1),'Survived'))
                        x = isempty(setdiff(homogFEAT(1),'Survived'));
                        %most homogenous is survived
                    else 
                        x = false;
                        return

                    end %end if
            end% end stop conditions


                    %4. If the we don’t have any data left, pick majority label of parent
                    %data is empty this.label = parent.label
                    %5. If some other stopping criteria exists to avoid overfitting, pick

