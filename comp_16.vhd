----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:41 11/20/2018 
-- Design Name: 
-- Module Name:    comp_16 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comp_16 is
    Port ( P : in  STD_LOGIC_VECTOR (15 downto 0);		-- P es la duracion de ceros o unos
           Q : in  STD_LOGIC_VECTOR (15 downto 0);		-- Q es el umbral de ceros o unos
           P_GT_Q : out  STD_LOGIC);						-- Indica cual es mayor
end comp_16;

architecture Behavioral of comp_16 is

begin

	P_GT_Q <= '1' when P>Q else '0';			-- Si P es mayor que Q => vale 1, sino, vale 0

end Behavioral;

