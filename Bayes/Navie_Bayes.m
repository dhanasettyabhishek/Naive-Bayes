function [ result ] = Navie_Bayes( training_set, test_example )

n_examples = size(training_set, 1);
n_positive = nnz(training_set(:, 5) == 1);
n_negitive = size(training_set, 1) - n_positive;

positive_probability = [];
negative_probability = [];

for inx = 1:size(test_example, 2)
    
    examples_with_values = training_set(training_set(:,inx)== test_example(1, inx),:);
    
    n_value_examples  = size( examples_with_values, 1);
                
    n_pos_examples = size( examples_with_values(examples_with_values(:,end)== 1,:), 1);

    n_neg_examples =  n_value_examples - n_pos_examples;
    
    if(n_pos_examples == 0)
        m = 1;
        n = n_positive;
        p = length(unique(training_set(:, inx)));
        
        m_estimate = (n_pos_examples + m * p) / (n + m);
        
        positive_probability = [positive_probability;m_estimate];
        
        if(n_neg_examples == 0)
            
            m = 1;
            n = n_negitive;
            p = length(unique(training_set(:, inx)));

            m_estimate = (n_pos_examples + m * p) / (n + m);

            negative_probability = [negative_probability;m_estimate];
            
        else
            negative_probability = [negative_probability;n_neg_examples/n_value_examples];           
            
        end
        
        continue;
        
    elseif(n_neg_examples == 0)
        
        m = 1;
        n = n_negitive;
        p = length(unique(training_set(:, inx)));
        
        m_estimate = (n_pos_examples + m * p) / (n + m);
        
        negative_probability = [negative_probability;m_estimate];
        
         if(n_pos_examples == 0)
            m = 1;
            n = n_positive;
            p = length(unique(training_set(:, inx)));

            m_estimate = (n_pos_examples + m * p) / (n + m);

            positive_probability = [positive_probability;m_estimate];
            
         else
             
            positive_probability = [positive_probability;n_pos_examples/n_value_examples]; 
            
         end
         
        continue;
    else
        
        positive_probability = [positive_probability;n_pos_examples/n_value_examples];    
    
        negative_probability = [negative_probability;n_neg_examples/n_value_examples];
        
    end
     
end
    total_positive_probability = (n_positive/ n_examples ) * prod(positive_probability);
    
    total_negative_probability = (n_negitive/ n_examples ) * prod(negative_probability);
   
    if(total_positive_probability > total_negative_probability)
        result = 'yes';
    else
        result = 'no';
    end
end

