Understand the Problem
  - Identify inputs and outputs given the requirements
    - requirements are explicit
      - take notes
      - the odd words problem
    - requirements are not so explicit and need to be modeled
      - requirements are shown with examples
        - examples need to be described in computational words
        - diamond of stars problem
      - implicit knowledge needs to be captured
        - convert to explicit rules, in computational language
        - what century is it problem
      - identifying and defining important terms and concepts
        - [queen attack (maybe an easy version?)](https://launchschool.com/exercises/81d3afa6)
        - same row; same column; esp. same diagonal
  - ask questions to clarify understanding!

Examples / Test Cases
  - Input / Output
  - Test cases serve two purposes:
    - help you understand the problem
    - allow you to verify your solution
  - Happy paths
    - combination of requirements; the 'obvious' result
  - Edge cases
    - focus on input
    - emptiness (nill/null, "", [], {})
    - boundary conditions
    - repetition / duplication
    - upper case / lower case
    - data types
  - Failures / Bad Input
    - raise exceptions / report errors 
    - return a special value (nil/null, 0, "", [], etc)
  - Ask questions to verify your understanding!

ODD WORDS EXAMPLE

Understanding the Problem
- Input:
  - 1 to many words
  - separated by: 
    - 0 to many spaces
    - followed by a period
  - chars: letter, space, point, up to 20 letters
  - need to handle failure?
- Output:
  - words: have the odd words reversed
  - odd means number number words, based on 0 index
  - separated by one space between words
  - terminated: 0 spaces, followed by dot

Examples / Test Cases: 

reverse_odd_words("hello.")               => "hello."
reverse_odd_words("hello .")              => "hello."
reverse_odd_words("hello world.")         => "hello dlrow."
reverse_odd_words("hello world .")        => "hello dlrow."
reverse_odd_words("hello  world .")       => "hello dlrow."
reverse_odd_words("hello  hello world.")  => "hello olleh world."
reverse_odd_words("")                     => ""