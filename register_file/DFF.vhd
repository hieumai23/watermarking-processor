----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 12:40:28 PM
-- Design Name: 
-- Module Name: DFF - Behavioral
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

entity DFF is
port (
    d: in std_logic;
    clk: in std_logic;
    rw_en: in std_logic_vector (1 downto 0);
    q: out std_logic
);
end DFF;

architecture Behavioral of DFF is

signal mem: std_logic := '0';

begin

process(clk)
begin

if clk'event and clk = '1' then
    case rw_en is
        when "01" => --read
            q <= mem;
        when "10" =>
            mem <= d;
        when others =>
            q <= 'Z';
    end case;
end if;

end process;


end Behavioral;
