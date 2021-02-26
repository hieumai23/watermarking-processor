----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 12:16:21 AM
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
    generic(n: integer:= 8;
            q: integer:= 2);
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
    component array_Multiplier is 
    generic (m: natural := 8; 
             n: natural := 8;
             q: natural := 2);
    port( x : in std_logic_vector(m-1 downto 0);
          y : in std_logic_vector(n-1 downto 0); 
          o : out std_logic_vector(m-1 downto 0) ); 
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
    
    component adder is
    generic(n: integer := 8);
    port(
        i_input1: in std_logic_vector(n-1 downto 0);
        i_input2: in std_logic_vector(n-1 downto 0);
        o_output: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal o_MUX0, o_MUX1: std_logic_vector(n-1 downto 0);
    signal o_MUX2, o_MUX3: std_logic_vector(n-1 downto 0);
    signal o_MULT1, o_MULT2, o_MULT3: std_logic_vector(n-1 downto 0);
    signal o_MUX4, o_MUX5: std_logic_vector(n-1 downto 0);
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

MULT1: array_Multiplier
    generic map(n, n, q)
    port map (i_Imn, o_MUX2, o_MULT1);

MULT2: array_Multiplier
    generic map(n, n, q)
    port map (i_Wmn, o_MUX3, o_MULT2);
    
MULT3: array_Multiplier
    generic map(n, n, q)
    port map (o_MULT1, o_MULT2, o_MULT3);
    
MUX4: MUX21 
    generic map(n)
    port map(i_Imn, o_MULT1, i_select, o_MUX4);

MUX5: MUX21 
    generic map(n)
    port map(o_MULT3, o_MULT2, i_select, o_MUX5);

ADD_OUT: adder
    generic map(n)
    port map(o_MUX4, o_MUX5, o_IWmn);

end Behavioral;
