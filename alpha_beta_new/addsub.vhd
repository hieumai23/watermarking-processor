----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2021 02:09:57 PM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity addsub is
    generic (n: natural:= 8);
    port(
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

ADDSUB: process (i_a, i_b, i_cin, i_ctrl) is
    variable p, g, c, b_sub, temp_b, temp_s, c_neg_one: std_logic_vector(n-1 downto 0);
    variable temp_cin: std_logic;
    
begin
    p := (others => '0');
    g := (others => '0');
    c := (others => '0');
    c_neg_one := (others => '1');
    b_sub := (i_b xor c_neg_one);
    temp_b := (others => '0');
    temp_s := (others => '0');
    temp_cin := '0';
    
    if i_ctrl = '1' then
        temp_b := i_b;
        temp_cin := i_cin;
    else
        temp_b := b_sub;
        temp_cin := not i_cin;
    end if;
    
    temp_s := (i_a xor temp_b);
    g := (i_a and temp_b);
    p := (i_a or temp_b);
    c(1) := (g(0) or (p(0) and temp_cin));
    
    for i in 1 to (n-2) loop
        c(i+1) := g(i) or (p(i) and c(i));
    end loop;
    
    o_cout <= g(n-1) or (p(n-1) and c(n-1));
    o_z(0) <= temp_s(0) xor temp_cin;
    o_z(n-1 downto 1) <= temp_s(n-1 downto 1) xor c(n-1 downto 1);
    
    end process ADDSUB;
end Behavioral;
