----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2021 05:05:33 PM
-- Design Name: 
-- Module Name: multiplier - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
    generic(n: integer:= 8; q: integer:= 2);
    port(
        in_X, in_Y: in std_logic_vector(n-1 downto 0);
        out_R_int: out std_logic_vector(q-1 downto 0);
        out_R_frac: out std_logic_vector(n-q-1 downto 0)
    );
end multiplier;

architecture Behavioral of multiplier is
    procedure Multiply(signal in_X, in_Y: in std_logic_vector(n-1 downto 0);
                       signal out_R_int: out std_logic_vector(q-1 downto 0);
                       signal out_R_frac: out std_logic_vector(n-q-1 downto 0)) is
        variable Xint, Yint, Tint, Rint: std_logic_vector(q-1 downto 0);
        variable Xfrac, Yfrac, Tfrac, Rfrac: std_logic_vector(n-q-1 downto 0);
    begin
    Xint := in_X(n-1 downto n-q);
    Yint := in_Y(n-1 downto n-q);
    Xfrac := in_X(n-q-1 downto 0);
    Yfrac := in_Y(n-q-1 downto 0);
    
    int_loop: for i in q-1 downto 0 loop
        if Xint(i) = '1' then Tint := Yint; else Tint := (others => '0'); end if;
        shift_int_loop: for j in i downto 1 loop
            Tint := Tint(q-2 downto 0) & '0';
            end loop;
        Rint := Rint + Tint;
    end loop;

    frac_loop: for i in n-q-1 downto 0 loop
        if Xfrac(i) = '1' then Tfrac := Yfrac; else Tfrac := (others => '0'); end if;
        shift_frac_loop: for j in n-q downto 1 loop
            Tfrac := '0' & Tfrac(n-q-1 downto 1);
            end loop;
        Rfrac := Rfrac + Tfrac;
    end loop;
    
    out_R_int <= std_logic_vector(Rint);
    out_R_frac <= std_logic_vector(Rfrac);
   
    end procedure;
    
begin

    Multiply(in_X => in_X, in_Y => in_Y, out_R_int => out_R_int, out_R_frac => out_R_frac);

end Behavioral;
