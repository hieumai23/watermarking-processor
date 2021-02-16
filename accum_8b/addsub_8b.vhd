library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;


entity add_sub_8b is
    port (
        a: in unsigned(7 downto 0);
        b: in unsigned(7 downto 0);
        z: out unsigned(7 downto 0);
        c_in: in std_logic;
        ctrl: in std_logic;
        c_out: out std_logic
    );
end entity add_sub_8b;

architecture MyHDL of add_sub_8b is

begin

ADD_SUB_8B_LOGIC: process (ctrl, b, a, c_in) is
    variable p: unsigned(7 downto 0);
    variable g: unsigned(7 downto 0);
    variable c: unsigned(7 downto 0);
    variable b_sub: unsigned(7 downto 0);
    variable temp_b: unsigned(7 downto 0);
    variable temp_s: unsigned(7 downto 0);
    variable temp_c_in: std_logic;
begin
    p := to_unsigned(0, 8);
    g := to_unsigned(0, 8);
    c := to_unsigned(0, 8);
    b_sub := (b xor to_unsigned(255, 8));
    temp_b := to_unsigned(0, 8);
    temp_s := to_unsigned(0, 8);
    temp_c_in := '0';
    if (ctrl = '1') then
        temp_b := b;
        temp_c_in := c_in;
    else
        temp_b := b_sub;
        temp_c_in := stdl((not bool(c_in)));
    end if;
    temp_s := (a xor temp_b);
    g := (a and temp_b);
    p := (a or temp_b);
    c(1) := (g(0) or (p(0) and temp_c_in));
    for i in 1 to (8 - 1)-1 loop
        c((i + 1)) := (g(i) or (p(i) and c(i)));
    end loop;
    c_out <= (g((8 - 1)) or (p((8 - 1)) and c((8 - 1))));
    z(0) <= (temp_s(0) xor temp_c_in);
    z(8-1 downto 1) <= (temp_s(8-1 downto 1) xor c(8-1 downto 1));
end process ADD_SUB_8B_LOGIC;

end architecture MyHDL;
