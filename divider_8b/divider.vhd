----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 10:19:04 PM
-- Design Name: 
-- Module Name: divider - Behavioral
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
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity divider is
    generic(n: integer := 8);
    port(X,Y: in std_logic_vector(n-1 downto 0);
         Q,R: out std_logic_vector(n-1 downto 0)
         );
end divider;

architecture Behavioral of divider is

procedure Divide (signal a,b: in std_logic_vector(n-1 downto 0);
                  signal Quot,Rmdr: out std_logic_vector(n-1 downto 0)) is
                  
    variable Tmp,Avar,Bvar,Tmp3: std_logic_vector(n-1 downto 0);
 
    begin
    Avar := a; Bvar := b;
    y_loop: for i in n-1 downto 0 loop
        Tmp := std_logic_vector(conv_unsigned(unsigned(Avar(n-1 downto i)),n));
        if Tmp >= Bvar then Quot(i) <= '1';
            Tmp3 := Tmp - Bvar;
            if i /= 0 then
                Avar(n-1 downto i) := Tmp3(n-1-i downto 0);
                Avar(i-1) := a(i-1);
            end if;
        else Quot(i) <= '0';
        Tmp3 := Tmp;
        end if;
    end loop;
    Rmdr <= Tmp3;
end procedure;
    
begin

Divide(a => X, b => Y, -- inputs
    Quot => Q,Rmdr => R); -- outputs

end Behavioral;
