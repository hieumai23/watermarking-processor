----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 07:48:20 PM
-- Design Name: 
-- Module Name: comparator_8b - Behavioral
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

entity comparator_8b is
    generic(n: integer := 8);
    port(
         A: in std_logic_vector(n-1 downto 0);
         B: in std_logic_vector(n-1 downto 0);
         geq: out std_logic;
         lt: out std_logic
         ); 
end comparator_8b;

architecture Behavioral of comparator_8b is

    component addsub is
       generic(n: natural := 8);
        port (
            i_a: in std_logic_vector(n-1 downto 0);
            i_b: in std_logic_vector(n-1 downto 0);
            i_cin: in std_logic;
            i_ctrl: in std_logic;
            o_cout: out std_logic;
            o_z: out std_logic_vector(n-1 downto 0)
        );
    end component;

    signal addsub_out: std_logic;

begin

AS: addsub
    generic map(n)
    port map(i_a => A,
             i_b => B,
             i_cin => '0',
             i_ctrl => '0', -- subtract
             o_cout => addsub_out,
             o_z => open
             );
    
    geq <= addsub_out and '1';
    lt <= not (addsub_out and '1');

end Behavioral;
