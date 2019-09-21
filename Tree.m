classdef Tree < handle
%**************************************************************************
    %Tree class inherits handle class so it can hold objects in a matrix
    %Tree is
        %A root node, the root node references its children and thus the
            %rest of the nodes
    %Tree does
        %Split data between the TRAINING and TEST set
        %Creates the Tree, i.e. constructs all the nodes and creates proper
            %references
        %Runs a test on the created tree, if a tree is created
 
 %NOTES: Unable to implement depth, I believe what I call depth is in fact
 %the number of Nodes. Also test are innacurate likely due to overfitting
 %derived from the non implementation of depth as a stopping condition.
%**************************************************************************

%---------------------PROPERTIES-------------------------------------------
%depth and root Node
    properties
        depth = -1
        Node1
        
    end
%---------------------PROPERTIES-------------------------------------------

    
    methods
        
%-------------------SPLIT DATA---------------------------------------------
%INPUT: matrix: RECORDS,  float: ratio
%OUTPUT matrix: TRAINING_RECORDS, matrix: TEST_RECORDS

%Randomly permutes the input dataset and returns 2 datasets of size
%(ratio*m) and (1-ratio)*m that are a random subset TRAIN and TEST of
%RECORDS
        function [TRAIN,TEST] = splitData(self,RECORDS,ratio)
            [rownum,colnum] = size(RECORDS);
                    k = randperm(rownum, round(rownum*ratio));
                    TRAIN  = RECORDS(k, :);
                    r         = true(1,rownum);
                    r(k)      = false;
                    TEST = RECORDS(r, :);
        
        end
%--------------------END SPLIT DATA----------------------------------------
        
%--------------------CREATE TREE-------------------------------------------
%constructor of sorts.
%INPUT: matrix: RECORDS, matrix: FEATURES
%OUTPUT object: Tree

%Recursive algorithm that takes the data set and constructs a top down/trains a tree on the
%RECORDS set passed in

        function t = createTree(self,RECORDS,FEATURES)
            
            [M,N] = size(RECORDS);
            root = Node();
            
            %*******************CHECK NODES 4 LEAF*************************
            %calls stop condition method to check if the our current node
            %is a leaf node, if it is it returns the node, depth is
            %included here, but does not work
            if root.stop_cond(RECORDS,FEATURES)
                if self.depth >= 10
                    t = root;
                end
               leaf = root;
               leaf.label = leaf.classify(RECORDS);
               t = leaf;
            else
                
                %********HANDLES NON LEAF NODES****************************
                root.attribute = root.find_most_homog(RECORDS,FEATURES);

                %simply gets index of current word in features i.e. convert
                %from cell to integer
                for element = 1:length(FEATURES)
                    if isempty(setdiff(FEATURES(element),root.attribute(1))) == true
                        attribute_index = element;
                    end
                    
                    
                end
                %is now an integer
                
                %----------------split between those who have feature and those who dont-----------------------------------
                hasFeature = []
                noFeature = []
                for row = 1:M %for every row
                    if RECORDS(row,attribute_index) == 1
                        hasFeature = [hasFeature;RECORDS(row,:)];
                    else
                        noFeature = [noFeature;RECORDS(row,:)];
                    end
                end
                %----------------------------------------------------------------------------------------------------------------
                
                %-----remove feature column to avoid getting same column for homogeneity measure------------------------------------------------------------------------------------------------------
                    leftchild_records = hasFeature;
                    rightchild_records = noFeature;
                    newFeatures = FEATURES;
                    newFeatures(:,attribute_index) = [];
                    leftchild_records(:,attribute_index) = [];
                    rightchild_records(:,attribute_index) = [];
      
                %----------------------------------------------------------------------------------------------------------------------------
                %-----recurse on left and right child and add them as children to root (parent)-----------------------------------------------------------------------------------------------------------------------------------
                   self.depth = self.depth+1;
                   root.left_child_yes = self.createTree(leftchild_records,newFeatures);
                   root.right_child_no = self.createTree(rightchild_records,newFeatures);
                   leftchild = root.left_child_yes;
                   %leftchild.setDepth(root.depth+1);
                   rightchild = root.right_child_no;
                   %rightchild.setDepth(root.depth+1);
            %----------------------------------------------------------------------------------------------------------------------------------------
            end %end if stop condition

            
            %******reaches here only if node is a leaf, then works back up
            %tree
            
            self.Node1 = [root];
            self.depth = self.depth+1;
            
            %The t that is returned here is a tree with root node being one
            %of the children created above, thus t is a subset of the full
            %tree until the last recursion
            t = root;
        end %end function
%---------------------END CREATE TREE-------------------------------------- 
        
%---------------------------------------------TEST FUNTION START------------------------------------------------------------------------------------------
%******************************************************TEST FUNCTION START*********************************************************************************
%--------------------------TEST FUNCTION-------------------------------------------------------------------------------------------------------------
%this will take the training set and produce a new survival column
%it will then return the error (though called survive column) of the test
%i.e. the percent of our test set classified inccorectly.
function surviveColumn = test(self,TEST_RECORDS,TEST_FEATURES) 
    
    [M,N] = size(TEST_RECORDS); %M rows N columns
    finalcol = [];
    for row = 1:M
        
            node = self.Node1;
            if isempty(setdiff(node.received(TEST_RECORDS(row,:),TEST_FEATURES),'Dead')) %is dead
                finalcol = [finalcol;0];
            else
                finalcol = [finalcol;1];
            end
            
            
        
    end
    
    %compare survive column produced with that of the one in TEST RECORDS
    correct = 0;
    for el = 1:length(finalcol)
        if finalcol(el) == TEST_RECORDS(el,7)
            correct = correct + 1;
        else
            correct = correct;
        end
    end
    error = 1 - correct/length(finalcol);
    surviveColumn = error;
end

%---------------------------------------------TEST FUNTION END------------------------------------------------------------------------------------------
%******************************************************TEST FUNCTION*********************************************************************************
%--------------------------TEST FUNCTION-------------------------------------------------------------------------------------------------------------
        
    end %end methods
end %End tree class

