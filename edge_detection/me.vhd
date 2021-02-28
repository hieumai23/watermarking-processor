----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 12:28:56 AM
-- Design Name: 
-- Module Name: me - Behavioral
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

entity me is
    port(
        i_signal1: in std_logic;
        i_signal2: in std_logic;
        i_select: in std_logic;
        o_result: out std_logic
    );
end me;

architecture Behavioral of me is

begin

o_result <= (i_signal1 nand i_select) nand (i_signal2 nand (not i_select));

end Behavioral;
