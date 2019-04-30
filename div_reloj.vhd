----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:21:17 10/30/2018 
-- Design Name: 
-- Module Name:    div_reloj - Behavioral 
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

entity div_reloj is

	Port ( CLK : in STD_LOGIC; 			-- Entrada reloj de la FPGA 50 MHz
		CLK_1ms : out STD_LOGIC); 			-- Salida reloj a 1 KHz
end div_reloj;

architecture a_div_reloj of div_reloj is

signal contador : STD_LOGIC_VECTOR (15 downto 0);	-- Señal que usaremos de contador
signal flag : STD_LOGIC;									-- Señal que usaremos para sacar el clk

begin

process(CLK)
	begin
		if (CLK'event and CLK='1') then		-- Por cada ciclo de reloj sumo 1 el contador	
			contador<=contador+1;				-- Tenemos que para conseguir 1 KHz de 50 MHz, hay que dividir
		if (contador=25000) then				-- entre 25000 para evaluar los ciclos de subida y bajada, que 
			contador<=(others=>'0');			-- son representados con la señal flag (iremos alternando su valor, 
			flag<=not flag;						-- asi representará la forma de un clk)
		end if;	
	end if;
	end process;
	
CLK_1ms<=flag;					-- Asociamos todos los valores de flag al CLK de 1 Khz							

end a_div_reloj;
