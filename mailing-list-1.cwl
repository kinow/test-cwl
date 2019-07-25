#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: Workflow

steps:
  conditional:
    condition: $(expr) #allows graceful termination of a line of calculation. (Could be used as try/catch)
    in:
      inputA: ...
      inputB: ...
    out:
    - outputA
    - outputB
    run:
      ifelse: #ifelse instead of switch. Will only execute the first tool with a true condition. Takes a list as input... not just two
        - run: toolA.cwl
          condition: $(inputs.inputA == 12)
        - while:
          condition: $(inputs.inputA < 12)
          update: #allow access to the output of the last iteration of the loop
          - inputA:
              valueFrom: $(inputs.inputA + 1)
          - inputB:
              source: "#conditional/outputB"
          run: #allow nesting
            ifelse:
            - condition: $(inputs.inputA == 0)
              run: toolB.cwl
            - run: toolC.cwl #default behaviour, else statement
        - run: toolD.cwl
          condition: $(...)
        #when no condition can be fulfilled, terminate thread of calculations
