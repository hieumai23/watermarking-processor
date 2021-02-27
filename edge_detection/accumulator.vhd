----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 03:22:46 PM
-- Design Name: 
-- Module Name: accumulator - Behavioral
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

entity accumulator is
    generic(n: natural:= 8);
    port (
        i_x: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        i_ctrl: in std_logic;
        i_reset: in std_logic;
        i_enable: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0);
        o_cout: out std_logic
    );
end accumulator;

architecture Behavioral of accumulator is

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
    
    component MUX21 is
    generic(n: integer:= 8);
    port(
        i_input1: in std_logic_vector(n-1 downto 0);
        i_input2: in std_logic_vector(n-1 downto 0);
        i_sel: in std_logic;
        o_res: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal i_AADD0, o_AADD0, o_AADD1: std_logic_vector(n-1 downto 0);
    signal o_cout0, o_cout1: std_logic;

begin

AADD0: addsub
    generic map(n)
    port map(
        i_a => i_AADD0,
        i_b => i_x,
        i_cin => i_cin,
        i_ctrl => i_ctrl,
        o_cout => o_cout0,
        o_z => o_AADD0
    );
    
AADD1: addsub
    generic map(n)
    port map(
        i_a => i_AADD0,
        i_b => i_x,
        i_cin => i_cin,
        i_ctrl => i_ctrl,
        o_cout => o_cout0,
        o_z => o_AADD0
    );
    
ACCUMULATOR: process(i_enable, i_reset) is
begin
    if i_reset = '1' then
        o_cout <= '0';
        i_AADD0 <= (others => '0');
        o_z <= (others => '0');
    else
        if i_enable = '1' then
            i_AADD0 <= o_AADD0;
            o_z <= i_AADD0;
            o_cout <= o_cout0;
        else
            i_AADD0 <= o_AADD1;
            o_z <= o_AADD1;
            o_cout <= o_cout1;
        end if;
    end if;
end process ACCUMULATOR;
end Behavioral;
