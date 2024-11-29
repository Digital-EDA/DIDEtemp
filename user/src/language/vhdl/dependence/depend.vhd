

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vhdl_utils is
    port (
        a : in std_logic;
        b : in std_logic;
        y : out std_logic
    );
end entity vhdl_utils;

-- architecture arch of mixed is
-- begin
--     -- y <= a or b;
-- end architecture arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package my_package is
    constant MY_CONSTANT : integer := 8;

    type MY_VECTOR is array (0 to MY_CONSTANT - 1) of std_logic;

    function add_two_numbers(a, b : integer) return integer;

    procedure display_message;
end my_package;

package body my_package is
    function add_two_numbers(a, b : integer) return integer is
    begin
        return a + b;
    end add_two_numbers;

    procedure display_message is
    begin
        report "This is a message from my_package!";
    end display_message;
end my_package;
