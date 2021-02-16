----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2021 05:49:33 AM
-- Design Name: 
-- Module Name: 2_to_1_MUX - Behavioral
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

entity MUX21 is
    generic(n: integer:= 8);
    port(
        i_signal1: in std_logic_vector(n-1 downto 0);
        i_signal2: in std_logic_vector(n-1 downto 0);
        i_select: in std_logic;
        o_result: out std_logic_vector(n-1 downto 0)
    );
end MUX21;

architecture Behavioral of MUX21 is
begin
    o_result <= i_signal1 when (i_select = '1') else i_signal2;
end Behavioral;
