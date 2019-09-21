classdef Node < handle
%**************************************************************************
%Node class inherits from handle so objects can be inserted into matrices
%The node is
    %the attribute it was split on based on our homogoneity
    %a container for a reference to the left and right child
%The node does
    %finds the most homogenous feature from the set and then presents and
        %removes it
    %Classifies the data passed in (if it is a leaf node)
    %test for stop conditions
    %receive records passed to it by another node (records have been
        %changed by find most homogenous method (column removed)
%**************************************************************************

%----------PROPERTIES------------------------------------------------------
    properties
    attribute
    label
    left_child_yes
    right_child_no
    depth
    end %end properties                                      
%-----------END PROPERTIES-------------------------------------------------    
methods

%-------SET DEPTH (UNUSED, BUT LEFT IN IN CASE I MISSED ALL USES-----------
    function [] = setDepth(self,depth)
        self.depth = depth;
        return
    end
%-------end set depth------------------------------------------------------

%--------------------FIND MOST HOMOGENOUS FEATURE--------------------------
%INPUT: matrix: RECORDS, matrix: FEATURES
%OUTPUT: matrix: [cell: FEATURE, float: ERROR]
%This function takes in the records and the features and finds the most
%homogenous column (i.e. the column with largest ratio of 1 to 0 or 0 to 1
%it then retusn the column name to set as the node attribute and error
        function x = find_most_homog(self,RECORDS, FEATURES) 


                featsandError = []; %matrix to hold Feature and error
                
                %-------FIND ERROR FOR ALL FEATURES------------------------
                for feat = 1:length(FEATURES);
                    hasFeature = [];
                    noFeature = [];
                    for row = 1:length(RECORDS)

                        if RECORDS(row,feat) == 1
                            hasFeature = [hasFeature;1];
                        else 
                            noFeature = [noFeature;0];
                        end %end if

                    end % end for
                    lenhasFeat = length(hasFeature);
                    lennoFeat = length(noFeature);
                    if lennoFeat > lenhasFeat
                        r = lennoFeat/(lennoFeat+lenhasFeat);
                    else
                        r = lenhasFeat/(lennoFeat+lenhasFeat);
                    end %end if
                    featsandError = [featsandError;[FEATURES(feat), r]];
                end %end for
                x = featsandError;
                %------ x = LIST OF FEATURES AND ASSOCIATED ERRORS---------
                
                
                %--------FIND THE MOST HOMOGENOUS FROM LIST----------------
                leastR = 0;
                mostHomog = [];
                [M,N] = size(featsandError);
                for entry = 1:M
                  
                    if cell2mat(featsandError(entry,2)) > leastR
                        leastR = cell2mat(featsandError(entry,2));
                        mostHomog = [featsandError(entry,:)];
                        
                    end%end if
                    
                end%end for
                x = mostHomog;
                %------RETURNS ROW OF MOST HOMOGENOUS FEAT AND ERROR-------
            end %end func
%----------END FIND MOST HOMOGENOUS----------------------------------------
            
            %------------CLASSIFY------------------------------------------
            %INPUT matrix: RECORDS
            %OUTPUT: string: 'Survived' or 'Dead'
            %At a leaf node the data is split and then classified based on
            %whether or not that group of rows (determined by stop condition)
            %has (as a majority) survived or not
            function x = classify(self,RECORDS) %you are given a 1xN array extraction of the RECORDS
                    
                    N = length(RECORDS);
                    survived = [];
                    died = [];

                    %-----split into those who survived or not-------------
                    for x = 1:N
                        if RECORDS(x) == 1
                            survived = [survived,x];
                        else
                            died = [died,x];
                    %return 'dead' label if more dead
                        end %end if
                    end%end for
                    %-----------END SPLIT----------------------------------

                    if length(survived) > length(died)
                        x = 'Survived';
                    else
                        x = 'Dead';
                    end


                    end %outputs survived or not

            %------------------------------------end classify--------------
           
            
            
            %----------------------stop conditions-------------------------
            %INPUT: matrix: RECORDS, matrix: FEATURES
            %OUTPUT: boolean: x
            %Determines whether or not a node is a leaf node based on the
            %base cases layed out in 1-4 in book, and an attempted
            %condition based on depth (non implemented)
            %Prevents overfitting hopefully
            function x = stop_cond(self,RECORDS,FEATURES) 
                    homog = self.find_most_homog(RECORDS,FEATURES);
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
                    %2. If all the data have the same feature values (Embarked =1), pick
                    %majority label (survived if embarked = 1)
                    if homogERROR == 0 | homogERROR == 1
                        x = homogERROR == 0 | homogERROR == 1;

                        return
                    

                    %3. If we’re out of features to examine, pick majority label
                    %features is empty
                    %4. If the we don’t have any data left, pick majority label of parent
                    %data is empty this.label = parent.label
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


                    
                    %5. If some other stopping criteria exists to avoid overfitting, pick

            %-----------------end stop conditions------------------------------------------------------------------------------------

function t = att_tonum(self,FEATURES)
        for element = 1:length(FEATURES)
                    if isempty(setdiff(FEATURES(element),self.attribute(1))) == 1
                        x = element;
                        break
                    else
                        x = -1;
                    end
                    
                    
        end
        t = x;
end
%-----------------------NODE RECEIVED METHOD START----------------------------------------------------------------------------------
%INPUT: matrix: row from RECORDS, matrix: FEATURES
%OUTPUT: string: label

%the node.received method takes in a row from the test records and returns
%the label if it is a leaf node
%it checks to see if itself has a label not equal to []
%if it does then it returns its label

%if not then it checks its own attribute column for the row
%it then checks if it is a 1 or 0. if a 1
%calls received for left child
%else calls received for right child
function label = received(self,row,FEATURES)
 
    if isempty(self.label) == 1 %not a leaf node
        col = self.att_tonum(FEATURES);
        %disp(self.attribute);
        if row(col) == 1 %they do have the feature
            leftchild = self.left_child_yes;
            %disp('passed to left')
            %disp(row(col))
            name = leftchild.received(row,FEATURES);
        elseif row(col) == 0
            rightchild = self.right_child_no;
            %disp(row(col))
            %disp('passed to right')
            name = rightchild.received(row,FEATURES);
        else
            %disp('row and col is not 0 or 1 but instead')
            %disp(row(col))
        end
    else
        name = self.label;
    end
    label = name;
end
%-----------------------NODE RECEIVED METHOD START-----------------------------------------------------------------------------
end%end methods                                                %methods
end %end class