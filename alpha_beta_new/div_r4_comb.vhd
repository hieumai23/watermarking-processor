-----------------------------------------------------------------------
---- Combinational radix 4 Divisor based on Arch2 (half arch)
---- A, and B naturals (non negative integers) with XBITS and YBITS width
---- there is no restriction XBITS >= YBITS. 
---- Return quotient Q of XBITS and remainder R of NBITS
---- GRAIN defines the amount of bits computed at each cycle. 
----
---- The cicruict captures operands at each cycle 
---- The algorithm needs only one cylcle to calculate the quotient 
---- GRAIN = 2 for that radix 4 divider
---- There are registers at input and outputs 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.mypackage.all;

entity div_r4_comb is
  port (
      A: in STD_LOGIC_VECTOR (XBITS-1 downto 0);
      B: in STD_LOGIC_VECTOR (YBITS-1 downto 0);
      Q: out STD_LOGIC_VECTOR (XBITS-1 downto 0);
      R: out STD_LOGIC_VECTOR (YBITS-1 downto 0)
   );
end div_r4_comb;

architecture simple_arch of div_r4_comb is

  component cond_adder is
      port (
        op_a: in STD_LOGIC_VECTOR (YBITS-1 downto 0);
        op_b: in STD_LOGIC_VECTOR (YBITS-1 downto 0);
        sel: in STD_LOGIC;
        outp: out STD_LOGIC_VECTOR (YBITS-1 downto 0)
       );
  end component;

  component nr_r4_half_cell is
    port (
        op_r: in STD_LOGIC_VECTOR (YBITS downto 0);
        op_y: in STD_LOGIC_VECTOR (YBITS downto 0);
        op_3y: in STD_LOGIC_VECTOR (YBITS+1 downto 0);
        x_1: in STD_LOGIC;
        x_0: in STD_LOGIC;
        n_qneg: out STD_LOGIC_VECTOR (1 downto 0);
        new_r: out STD_LOGIC_VECTOR (YBITS downto 0)
        );
  end component;

type connectionmatrix is array (0 to GRAIN) of STD_LOGIC_VECTOR (YBITS downto 0);
  Signal  iR: STD_LOGIC_VECTOR (YBITS-1 downto 0);
  Signal  op_X: STD_LOGIC_VECTOR (XBITS-1 downto 0);
  Signal  op_Y: STD_LOGIC_VECTOR (YBITS downto 0);
  Signal  op_3Y: STD_LOGIC_VECTOR (YBITS+1 downto 0);
  Signal  iQ, op_Q: STD_LOGIC_VECTOR (XBITS-1 downto 0);

  type matrix_rem is array (0 to XBITS/GRAIN) of STD_LOGIC_VECTOR (YBITS downto 0);
  signal rem_int: matrix_rem;

signal rem_no_adj: STD_LOGIC_VECTOR (YBITS downto 0);

--attribute keep_hierarchy: string;
--attribute keep_hierarchy of low_level_arch: architecture is "yes";
--attribute IOB: string;
--attribute IOB of low_level_arch: architecture is "FALSE";

begin

op_3Y <=  ('0' & B) + ('0' & B & '0');
op_Y <=  ('0' & B);
op_X <= A;
iQ <= not op_Q;

rem_int(0) <= (others => '0');

g1: for i in 0 to XBITS/GRAIN -1 generate
cell: nr_r4_half_cell port map( op_r => rem_int(i),
    op_y =>op_Y, op_3y => op_3Y,
    x_1 => op_X(XBITS-1-i*2), x_0 => op_X(XBITS-2-i*2),
    n_qneg => op_Q(XBITS-1-i*2 downto XBITS-2-i*2),  new_r => rem_int(i+1) );
end generate;

rem_no_adj <= rem_int(XBITS/GRAIN);

final_rem_Adjust: cond_adder port map (op_a => rem_no_adj(YBITS-1 downto 0),
      op_b => op_Y(YBITS-1 downto 0),
      sel => rem_no_adj(YBITS), outp => iR);

Q <= iQ; R <= iR;

end simple_arch;
