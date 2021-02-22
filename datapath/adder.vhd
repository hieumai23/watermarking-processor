----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 12:43:12 AM
-- Design Name: 
-- Module Name: adder - Behavioral
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

entity adder is
    generic(n: integer := 8);
    port(
        i_input1: in std_logic_vector(n-1 downto 0);
        i_input2: in std_logic_vector(n-1 downto 0);
        o_output: out std_logic_vector(n-1 downto 0)
    );
end adder;

architecture Behavioral of adder is
    component pe is
    port(xi, yi, psi, ci: in  std_logic ;
         xo, yo, pso, co: out std_logic);
    end component;
    signal o_cout: std_logic_vector(n-1 downto 0);
    signal o_sum: std_logic_vector(n-1 downto 0);
begin
        ADD0: pe port map (i_input1(0), i_input2(0), '0', '0',
        open, open, o_sum(0), o_cout(0));
    A0: for i in 1 to n-1 generate
        ADDi: pe port map (i_input1(i), i_input2(i), o_sum(i-1), o_cout(i-1),
        open, open, o_sum(i), o_cout(i));
    end generate A0;
end Behavioral;
