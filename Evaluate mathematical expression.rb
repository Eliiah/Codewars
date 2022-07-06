=begin

Instructions

Given a mathematical expression as a string you must return the result as a number.
Numbers

Number may be both whole numbers and/or decimal numbers. The same goes for the returned result.
Operators

You need to support the following mathematical operators:

    Multiplication *
    Division / (as floating point division)
    Addition +
    Subtraction -

Operators are always evaluated from left-to-right, and * and / must be evaluated before + and -.
Parentheses

You need to support multiple levels of nested parentheses, ex. (2 / (2 + 3.33) * 4) - -6
Whitespace

There may or may not be whitespace between numbers and operators.

An addition to this rule is that the minus sign (-) used for negating numbers and parentheses will never be separated by whitespace. I.e all of the following are valid expressions.

1-1    // 0
1 -1   // 0
1- 1   // 0
1 - 1  // 0
1- -1  // 2
1 - -1 // 2
1--1   // 2

6 + -(4)   // 2
6 + -( -4) // 10

And the following are invalid expressions

1 - - 1    // Invalid
1- - 1     // Invalid
6 + - (4)  // Invalid
6 + -(- 4) // Invalid

Validation

You do not need to worry about validation - you will only receive valid mathematical expressions following the above rules.

=end

def tokenize_expression(expression)
  
    cat = expression.gsub(/\s/,"")
    
    while aeonax = cat.match(%r{(?<![\d\)])-}) do 
      cat[aeonax.begin(0)] = "n"
    end
    
    index = []
      while not cat.empty?
        if not cat.match(%r{^\d}).nil?      
          aeonax = cat.match(%r{[\d\.]+})
          cat = aeonax.post_match
          index << aeonax[0].to_f
        else
          index << cat[0]                
          cat = cat[1..-1]  
        end
      end
        index
    end
    
    def senya_popka(index)
      result = []
      stack = []
      primary, *other = *index
      while not primary.nil? do
        case primary                            
          when '('                          
            stack.push result                 
            result = []                      
          when ')'
            infant = result                   
            result = stack.pop               
            result << infant                   
          else 
            result << primary                   
        end    
        primary, *other = other
      end
      result
    end
    
    def senya_zluka(index)
      return index if not index.is_a? Array
      index = index.map!{|i| senya_zluka(i)}    
    
      result = []
      primary, *other = index
      while not primary.nil? 
        case primary
          when "n"
            second, *other = other
            result << [primary, second]        
          else
            result << primary
        end
        primary, *other = other
      end
      result
    end
    
    def senya_prem_dancer(index, chop = ["*","/"])
      return index if not index.is_a? Array
      index = index.map! {|i| senya_prem_dancer(i, chop)}    
    
      result = []
      primary, *other = index
      while not primary.nil?
        second = other.first                  
        if chop.include? second                          
          second, third, *other = other
          primary = [second, primary, third]      
          next                                
        else
          result << primary
        end
        primary, *other = other
      end
      result
    end
    
    def calc(expression)
      index = tokenize_expression(expression)
      index = senya_popka(index)
      index = senya_zluka(index)
      index = senya_prem_dancer(index, ["*","/"])
      index = senya_prem_dancer(index, ["+","-"])
      
    def answer(bdsm)
      return bdsm if not bdsm.is_a? Array     
      bdsm = bdsm.map! {|i| answer(i)}          
      return bdsm.first if bdsm.length == 1   
      primary, second, third = bdsm             
      case primary
        when "n" then return -second
        when "+" then return (second + third)
        when "-" then return (second - third)
        when "*" then return (second * third)
        when "/" then return (second / third) 
      end  
    end
      answer(index)
end    