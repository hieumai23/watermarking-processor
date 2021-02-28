library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;


entity add_sub_16b is
    port (
        a: in unsigned(15 downto 0);
        b: in unsigned(15 downto 0);
        z: out unsigned(15 downto 0);
        c_in: in std_logic;
        ctrl: in std_logic;
        c_out: out std_logic
    );
end entity add_sub_16b;

architecture MyHDL of add_sub_16b is

begin

ADD_SUB_16B_LOGIC: process (ctrl, b, a, c_in) is
    variable p: unsigned(15 downto 0);
    variable g: unsigned(15 downto 0);
    variable c: unsigned(15 downto 0);
    variable b_sub: unsigned(15 downto 0);
    variable temp_b: unsigned(15 downto 0);
    variable temp_s: unsigned(15 downto 0);
    variable temp_c_in: std_logic;
begin
    p := to_unsigned(0, 16);
    g := to_unsigned(0, 16);
    c := to_unsigned(0, 16);
    b_sub := (b xor to_unsigned(65535, 16));
    temp_b := to_unsigned(0, 16);
    temp_s := to_unsigned(0, 16);
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
    for i in 1 to (16 - 1)-1 loop
        c((i + 1)) := (g(i) or (p(i) and c(i)));
    end loop;
    c_out <= (g((16 - 1)) or (p((16 - 1)) and c((16 - 1))));
    z(0) <= (temp_s(0) xor temp_c_in);
    z(16-1 downto 1) <= (temp_s(16-1 downto 1) xor c(16-1 downto 1));
end process ADD_SUB_16B_LOGIC;

end architecture MyHDL;