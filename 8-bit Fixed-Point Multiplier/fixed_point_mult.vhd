----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2021 09:46:18 AM
-- Design Name: 
-- Module Name: fixed_point_mult - Behavioral
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
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fixed_point_mult is
    generic(n: integer:= 8);
    port(
        i_mult1: in std_logic_vector(n-1 downto 0);
        i_mult2: in std_logic_vector(n-1 downto 0);
        i_start: in std_logic;
        i_clk: in std_logic;
        o_done: out std_logic;
        o_result: out std_logic_vector(2*n-1 downto 0)
    );
end fixed_point_mult;

architecture Behavioral of fixed_point_mult is
    component cla_adder is
        generic(n: integer:= 8);
        port(
            i_add1: in std_logic_vector(n-1 downto 0);
            i_add2: in std_logic_vector(n-1 downto 0);
            o_result: out std_logic_vector(n-1 downto 0);
            o_carry: out std_logic
        );
    end component;
    
    component reg is
        generic(n: natural:= 8);
        port(
            i_data: in std_logic_vector(n-1 downto 0);
            o_data: out std_logic_vector(n-1 downto 0);
            i_clk: in std_logic;
            i_load: in std_logic;
            i_shift: in std_logic;
            i_clear: in std_logic;
            i_serIn: in std_logic
        );
    end component;

    component fixed_mult_controller is
    generic(n: natural:= 3);
    port(
        i_clk: in std_logic;
        i_Q0: in std_logic;
        i_start: in std_logic;
        o_load: out std_logic;
        o_shift: out std_logic;
        o_add: out std_logic;
        o_done: out std_logic
    );
    end component;
    
    signal o_M, o_Q: std_logic_vector(n-1 downto 0);
    signal o_D, o_A: std_logic_vector(n downto 0);
    signal s_load, s_shift, s_add: std_logic;
begin
CTRL: fixed_mult_controller
    generic map (integer(ceil(log2(real(n)))))
    port map (i_clk, o_Q(0), i_start, s_load, s_shift, s_add, o_done);

ADDN: cla_adder
    generic map (n)
    port map (o_A(n-1 downto 0), o_M, o_D(n-1 downto 0), o_D(n));
    
MREG: reg
    generic map (n)
    port map (i_mult1, o_M, i_clk, s_load, '0', '0', '0');

QREG: reg
    generic map (n)
    port map (i_mult2, o_Q, i_clk, s_load, s_shift, '0', o_A(0));

ACC: reg
    generic map (n+1)
    port map (o_D, o_A, i_clk, s_add, s_shift, s_load, '0');
    
o_result <= o_A(n-1 downto 0) & o_Q;

end Behavioral;
