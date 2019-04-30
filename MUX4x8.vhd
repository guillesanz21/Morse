----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:01 10/30/2018 
-- Design Name: 
-- Module Name:    MUX4x8 - Behavioral 
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

entity MUX4x8 is
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); 	-- Codigo 0
		E1 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 1
		E2 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 2
		E3 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 3
		S : in STD_LOGIC_VECTOR (1 downto 0); 			-- Señal de control (de refresco)
		Y : out STD_LOGIC_VECTOR (7 downto 0)); 		-- Salida (codigo seleccionado)
end MUX4x8;

architecture Behavioral of MUX4x8 is

	begin
	
	with S select Y <=		-- En funcion del selector, escoge un codigo u otro
		E0 when "00",
		E1 when "01",
		E2 when "10",
		E3 when "11",
		(others => '0') when others; 

end Behavioral;

