
architecture or_arch of vhdl_utils is
begin
    y <= a or b;
end architecture or_arch;

configuration cfg_or_arch of vhdl_utils is
    for or_arch
    end for;
end cfg_or_arch;

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.my_package.ALL;

entity mixed is
    port (
        a : in MY_VECTOR;
        b : in MY_VECTOR;
        sum : out MY_VECTOR;
        y1 : out std_logic;
        y2 : out std_logic
    );
end mixed;


architecture structural of mixed is

    component full_adder
        generic (
            WIDTH : integer := 8
        );
        port (
            A : in MY_VECTOR;
            B : in MY_VECTOR;
            Cin : in std_logic;
            Cout : out std_logic;
            Sum : out MY_VECTOR
        );
    end component;
    signal Cin : std_logic;
    signal Cout : std_logic;
begin

    u_adder : full_adder
    generic map (
        WIDTH => 8 
    )
    port map (
        A => a,
        B => b,
        Cin => Cin,
        Cout => Cout,
        Sum => sum
    );

    u1 : entity work.vhdl_utils(or_arch)
    port map (
        a => Cin,
        b => Cout,
        y => y1
    );

    u2 : entity work.vhdl_utils(and_arch)
    port map (
        a => Cin,
        b => Cout,
        y => y2
    );

end architecture structural;

configuration cfg_structural of mixed is
    for structural
    end for;
end cfg_structural;
