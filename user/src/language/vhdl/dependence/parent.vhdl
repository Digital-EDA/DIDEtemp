-- File: testbench.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_arithmetic_entity is
end entity tb_arithmetic_entity;

architecture test of tb_arithmetic_entity is
    constant WIDTH : integer := 4; -- Bit width for the test
    signal a      : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal b      : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal mode   : std_logic := '0';
    signal result : std_logic_vector(WIDTH-1 downto 0);

    -- Instantiate the arithmetic entity with a parameter
    component arithmetic_entity
        generic (
            WIDTH : integer
        );
        port (
            a      : in  std_logic_vector(WIDTH-1 downto 0);
            b      : in  std_logic_vector(WIDTH-1 downto 0);
            mode   : in  std_logic;
            result : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

begin
    -- Instantiate the arithmetic entity (choose the architecture later using configuration)
    uut: arithmetic_entity
        generic map (
            WIDTH => WIDTH -- Pass the parameter value
        )
        port map (
            a => a,
            b => b,
            mode => mode,
            result => result
        );

    -- Stimulus process
    stimulus_process: process
    begin
        -- Test 1: Addition (mode = '0')
        a <= "0011"; -- 3
        b <= "0101"; -- 5
        mode <= '0'; -- Addition mode
        wait for 10 ns;
        
        -- Test 2: Subtraction (mode = '1')
        mode <= '1'; -- Subtraction mode
        wait for 10 ns;

        -- Test 3: Another addition
        a <= "1100"; -- 12
        b <= "0010"; -- 2
        mode <= '0'; -- Addition mode
        wait for 10 ns;

        -- Test 4: Another subtraction
        mode <= '1'; -- Subtraction mode
        wait for 10 ns;

        -- Finish simulation
        wait;
    end process stimulus_process;

end architecture test;
