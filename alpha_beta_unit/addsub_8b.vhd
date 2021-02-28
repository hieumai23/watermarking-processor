----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 12:49:45 PM
-- Design Name: 
-- Module Name: addsub - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity addsub is
    generic(n: natural := 8);
    port (
        i_a: in std_logic_vector(n-1 downto 0);
        i_b: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        i_ctrl: in std_logic;
        o_cout: out std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
end addsub;

architecture Behavioral of addsub is
begin
ADD_SUB_8B_LOGIC: process (i_a, i_b, i_cin, i_ctrl) is
    variable p: std_logic_vector(n-1 downto 0);
    variable g: std_logic_vector(n-1 downto 0);
    variable c: std_logic_vector(n-1 downto 0);
    variable b_sub: std_logic_vector(n-1 downto 0);
    variable temp_b: std_logic_vector(n-1 downto 0);
    variable temp_s: std_logic_vector(n-1 downto 0);
    variable temp_c_in: std_logic;
    variable neg_one: std_logic_vector(n-1 downto 0);
begin
    neg_one := (others => '1');
    b_sub := i_b xor neg_one;
    temp_c_in := '0';
    if (i_ctrl = '1') then
        temp_b := i_b;
        temp_c_in := i_cin;
    else
        temp_b := b_sub;
        temp_c_in := not i_cin;
    end if;
    temp_s := (i_a xor temp_b);
    g := (i_a and temp_b);
    p := (i_a or temp_b);
    c(1) := (g(0) or (p(0) and temp_c_in));
    for i in 1 to (8 - 1)-1 loop
        c((i + 1)) := (g(i) or (p(i) and c(i)));
    end loop;
    o_cout <= (g(n - 1) or (p(n - 1) and c(n - 1)));
    o_z(0) <= (temp_s(0) xor temp_c_in);
    o_z(n-1 downto 1) <= (temp_s(n-1 downto 1) xor c(n-1 downto 1));
end process ADD_SUB_8B_LOGIC;

end Behavioral;
