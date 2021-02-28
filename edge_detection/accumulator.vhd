----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2021 02:09:57 PM
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
        i_clk: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0);
        o_cout: out std_logic
    );
end accumulator;

architecture Behavioral of accumulator is

    component addsub is
    generic (n: natural:= 8);
    port(
        i_a: in std_logic_vector(n-1 downto 0);
        i_b: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        i_ctrl: in std_logic;
        o_cout: out std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal o_tmp1, o_tmp2, o_tmp3: std_logic_vector(n-1 downto 0);
    signal o_cout_tmp1, o_cout_tmp2: std_logic;

begin
    U1: addsub
        generic map (n)
        port map(
            i_a => o_tmp1,
            i_b => i_x,
            i_cin => i_cin,
            i_ctrl => i_ctrl,
            o_cout => o_cout_tmp1,
            o_z => o_tmp2
        );

    U2: addsub
        generic map (n)
        port map(
            i_a => o_tmp1,
            i_b => (others => '0'),
            i_cin => i_cin,
            i_ctrl => i_ctrl,
            o_cout => o_cout_tmp2,
            o_z => o_tmp3
        );
            
ACC: process(i_clk) is
begin
    if i_clk = '1' and i_clk'event then
        if i_reset = '1' then
            o_cout <= '0';
            o_tmp1 <= (others => '0');
            o_z <= (others => '0');
        else
            if i_enable = '1' then
                o_tmp1 <= o_tmp2;
                o_z <= o_tmp2;
                o_cout <= o_cout_tmp1;
            else
                o_tmp1 <= o_tmp3;
                o_z <= o_tmp3;
                o_cout <= o_cout_tmp2;
            end if;
        end if;
    end if;
end process ACC;
end Behavioral;
