----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2021 05:21:49 AM
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
    generic(n: integer:= 8);
    port(
        i_amax: in std_logic_vector(n-1 downto 0);
        i_ak: in std_logic_vector(n-1 downto 0);
        i_bmax: in std_logic_vector(n-1 downto 0);
        i_bk: in std_logic_vector(n-1 downto 0);
        
        i_clk: in std_logic;
        i_select: in std_logic;
        i_start: in std_logic;
        i_BlockCompleted: in std_logic;
        i_ImageCompleted: in std_logic;
        
        i_edge: in std_logic;
        i_regfile: in std_logic_vector(n-1 downto 0);
        i_aI: in std_logic_vector(n-1 downto 0);
        
        i_Imn: in std_logic_vector(n-1 downto 0);
        i_Wmn: in std_logic_vector(n-1 downto 0);
        
        o_IWmn: out std_logic_vector(n-1 downto 0)
    );
end datapath;

architecture Behavioral of datapath is
    component fixed_point_mult is
        generic(n: integer:= 8);
        port(
            i_mult1: in std_logic_vector(n-1 downto 0);
            i_mult2: in std_logic_vector(n-1 downto 0);
            i_start: in std_logic;
            i_clk: in std_logic;
            o_done: out std_logic;
            o_result: out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    component MUX21 is
    generic(n: integer:= 8);
    port(
        i_signal1: in std_logic_vector(n-1 downto 0);
        i_signal2: in std_logic_vector(n-1 downto 0);
        i_select: in std_logic;
        o_result: out std_logic_vector(n-1 downto 0)
    );
    end component;
    
    component cla_adder is
    generic(n: integer:= 8);
    port(
        i_add1: in std_logic_vector(n-1 downto 0);
        i_add2: in std_logic_vector(n-1 downto 0);
        o_result: out std_logic_vector(n-1 downto 0);
        o_carry: out std_logic
    );
    end component;
    
    signal o_MUX0, o_MUX1: std_logic_vector(n-1 downto 0);
    signal o_MUX2, o_MUX3: std_logic_vector(n-1 downto 0);
    signal o_MUX4, o_MUX5: std_logic_vector(n-1 downto 0);
    signal o_MULT1, o_MULT2: std_logic_vector(n-1 downto 0);
    signal o_MULT1_done, o_MULT2_done: std_logic;
    signal i_MULT3_rdy: std_logic;
    signal o_MULT3: std_logic_vector(n-1 downto 0);
    signal o_MULT3_done: std_logic;
    signal o_ADDER: std_logic_vector(n-1 downto 0);
    
begin
MUX0: MUX21 
    generic map(n)
    port map(i_amax, i_ak, i_edge, o_MUX0);

MUX1: MUX21 
    generic map(n)
    port map(i_bmax, i_bk, i_edge, o_MUX1);

MUX2: MUX21 
    generic map(n)
    port map(i_regfile, o_MUX0, i_select, o_MUX2);

MUX3: MUX21 
    generic map(n)
    port map(i_aI, o_MUX1, i_select, o_MUX3);
    
MULT1: fixed_point_mult
    generic map(n)
    port map(i_Imn, o_MUX2, i_start, i_clk, o_MULT1_done, o_MULT1);
    
MULT2: fixed_point_mult
    generic map(n)
    port map(i_Wmn, o_MUX3, i_start, i_clk, o_MULT2_done, o_MULT2);

i_MULT3_rdy <= (o_MULT1_done and o_MULT2_done);

MULT3: fixed_point_mult
    generic map(n)
    port map(o_MULT1, o_MULT2, i_MULT3_rdy, i_clk, o_MULT3_done, o_MULT3);
    
MUX4: MUX21 
    generic map(n)
    port map(i_Imn, o_MULT1, i_select, o_MUX4);

MUX5: MUX21 
    generic map(n)
    port map(o_MULT3, o_MULT2, i_select, o_MUX5);
    
ADDER: cla_adder
    generic map(n)
    port map(o_MUX4, o_MUX5, o_ADDER, open);

o_IWmn <= o_ADDER;

end Behavioral;
