-- File: configuration.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

configuration arithmetic_config of arithmetic_entity is
    for behavioral
    end for;
end configuration arithmetic_config;

-- 或者你可以选择另一个配置：
configuration arithmetic_pipelined_config of arithmetic_entity is
    for pipelined
    end for;
end configuration arithmetic_pipelined_config;
