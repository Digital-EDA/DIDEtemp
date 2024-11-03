-- File: arithmetic_entity.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity with a generic parameter and ports
entity arithmetic_entity is
    generic (
        WIDTH : integer := 4 -- Parameter for the bit width of the inputs and outputs
    );
    port (
        a      : in  std_logic_vector(WIDTH-1 downto 0);
        b      : in  std_logic_vector(WIDTH-1 downto 0);
        mode   : in  std_logic; -- '0' for addition, '1' for subtraction
        result : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity arithmetic_entity;

-- File: arithmetic_entity_behavioral.vhdl
architecture behavioral of arithmetic_entity is
begin
    process (a, b, mode)
    begin
        if mode = '0' then
            result <= std_logic_vector(unsigned(a) + unsigned(b)); -- Addition
        else
            result <= std_logic_vector(unsigned(a) - unsigned(b)); -- Subtraction
        end if;
    end process;
end architecture behavioral;

-- File: arithmetic_entity_pipelined.vhdl
architecture pipelined of arithmetic_entity is
    signal result_reg : std_logic_vector(WIDTH-1 downto 0);
begin
    process (a, b, mode)
    begin
        if mode = '0' then
            result_reg <= std_logic_vector(unsigned(a) + unsigned(b)); -- Addition
        else
            result_reg <= std_logic_vector(unsigned(a) - unsigned(b)); -- Subtraction
        end if;
    end process;
    
    -- Output the registered result with a delay of one clock cycle
    process
    begin
        wait for 5 ns; -- Simulate pipeline delay
        result <= result_reg;
    end process;
end architecture pipelined;

