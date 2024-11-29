
architecture and_arch of vhdl_utils is
begin
    y <= a and b;
end architecture and_arch;

configuration cfg_and_arch of vhdl_utils is
    for and_arch
    end for;
end cfg_and_arch;

configuration cfg_structural of mixed is
    for structural
    end for;
end cfg_structural;

-- configuration cfg_or_arch of mixed is
--     for structural
--         for u2 : vhdl_utils use entity work.vhdl_utils(and_arch);
--     end for;
-- end cfg_or_arch;