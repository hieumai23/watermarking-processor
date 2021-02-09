----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2021 09:57:38 AM
-- Design Name: 
-- Module Name: fixed_mult_controller - Behavioral
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

entity fixed_mult_controller is
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
end fixed_mult_controller;

architecture Behavioral of fixed_mult_controller is
    type states is (HaltS, InitS, QtempS, AddS, ShiftS);
    signal state:states := HaltS;
    signal counter: integer range 0 to 2**n-1;
begin
    o_done  <= '1' when state = HaltS  else '0';
    o_load  <= '1' when state = InitS  else '0';
    o_add   <= '1' when state = AddS   else '0';
    o_shift <= '1' when state = ShiftS else '0';
    -- Multiplier State Machine
    process(i_clk)
    begin
        if i_clk = '1' and i_clk'event then
            case state is
                when HaltS => if i_start = '1' then state <= InitS; end if;
                when InitS => state <= QtempS;
                when QtempS => if i_Q0 = '1' then state <= AddS; else state <= ShiftS; end if;
                when AddS => state <= ShiftS;
                when ShiftS => if (counter = 2**n-1) then state <= HaltS; else state <= QtempS; end if;
            end case;
        end if;
    end process;
    
    -- Multiplier State Machine
    process(i_clk)
    begin
        if i_clk = '1' and i_clk'event then
            if state = InitS then 
                counter <= 0;
            elsif state = ShiftS then
                counter <= counter + 1;
            end if;
        end if;
    end process;

end Behavioral;
