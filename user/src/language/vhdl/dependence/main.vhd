
architecture or_arch of my_entity is
begin
    -- y <= a or b;
end architecture or_arch;

configuration cfg_or_arch of my_entity is
    for or_arch
    end for;
end cfg_or_arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.my_package.ALL;

entity top_module is
    port (
        a : in std_logic;
        b : in std_logic;
        y1 : out std_logic;
        y2 : out std_logic
    );
end top_module;


architecture structural of top_module is
    -- 声明加法器的组件
    component adder
        generic (
            WIDTH : integer := 8
        );
        port (
            a : in std_logic;
            b : in std_logic;
            sum : out std_logic
        );
    end component;
    signal temp : work.my_package.MY_VECTOR;
begin
    -- 实例化加法器组件
    u_adder : adder
        generic map (
            WIDTH => 8 -- 设置宽度为8位
        )
        port map (
            a => a,
            b => b,
            sum => y1 -- 连接顶层端口到组件端口
        );

        u1: entity work.my_entity(or_arch)
        port map (
            a => a,
            b => b,
            y => y1
        );

        u2: entity work.my_entity(and_arch)
        port map (
            a => a,
            b => b,
            y => y2
        );

        
end architecture structural;


