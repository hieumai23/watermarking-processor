----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2021 09:33:41 PM
-- Design Name: 
-- Module Name: cla_adder - Behavioral
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

entity cla_adder is
    generic(n: integer:= 8);
    port(
        i_add1: in std_logic_vector(n-1 downto 0);
        i_add2: in std_logic_vector(n-1 downto 0);
        o_result: out std_logic_vector(n-1 downto 0);
        o_carry: out std_logic
    );
end cla_adder;

architecture Behavioral of cla_adder is
    component adder 
        Port(
            i_bit1: in std_logic;
            i_bit2: in std_logic;
            i_carry: in std_logic;
            o_sum: out std_logic
            --o_carry: out std_logic
        );
    end component;
    
    signal w_G: std_logic_vector(n-1 downto 0);
    signal w_P: std_logic_vector(n-1 downto 0);
    signal w_C: std_logic_vector(n downto 0);
    signal w_SUM: std_logic_vector(n-1 downto 0);
begin
    CLA_ADDER: for i in 0 to n-1 generate
        CLA_ADDER_i: adder 
            port map (
                i_bit1 => i_add1(i),
                i_bit2 => i_add2(i),
                i_carry => w_C(i),
                o_sum => w_SUM(i)
                --o_carry => open
            );
    end generate;

    GEN_CLA: for j in 0 to n-1 generate
        w_G(j) <= i_add1(j) and i_add2(j);
        w_P(j) <= i_add1(j) or i_add2(j);
        w_C(j+1) <= w_G(j) or (w_P(j) and w_C(j));
    end generate;
    
    w_C(0) <= '0';
    o_carry <= w_C(n);
    o_result <= w_SUM;
end Behavioral;