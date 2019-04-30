----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:19:59 11/13/2018 
-- Design Name: 
-- Module Name:    detector_flanco - Behavioral 
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

entity detector_flanco is
    Port ( CLK_1ms : in  STD_LOGIC;		-- Como entrada tiene el CLK de 1 Khz
           LIN : in  STD_LOGIC;			-- Entrada de datos que sale del circuito analógico
           VALOR : out  STD_LOGIC);		-- Indica si se trata de un flanco de subida (1) o bajada (0)
end detector_flanco;

architecture Behavioral of detector_flanco is

constant UMBRAL0 : STD_LOGIC_VECTOR (7 downto 0) := "00000101";  -- 5 umbral para el 0
constant UMBRAL1 : STD_LOGIC_VECTOR (7 downto 0) := "00001111";  -- 15 umbral para el 1

signal reg_desp : STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";	-- señal que usaremos como registro de los últimos 20 valores
signal suma		 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";		-- Señal que usaremos para sumar los valores del registro
signal s_valor	 : STD_LOGIC;				-- señal que indica el tipo de flanco

begin
	
	process (CLK_1ms)
		begin
			if (CLK_1ms'event and CLK_1ms='1') then
			
				-- Suma los valores entrantes de LIN hasta 20, y una vez llegado a 20, 
				-- resta el ultimo valor del registro y suma el nuevo valor entrante de LIN
				
				suma <= suma + LIN - reg_desp(19);		 
																	 
				-- Desplaza los valores del registro para añadir el nuevo valor de LIN. El último valor se elimina
				
				reg_desp(19 downto 1) <= reg_desp(18 downto 0);
				reg_desp(0) <= LIN;
				
				-- A partir del comparador con histeresis:
				
				if (suma < UMBRAL0) then		-- Si la suma de los valores de LIN no supera 5:
					s_valor <= '0';				-- el flanco sera de bajada
				end if;
				if (suma > UMBRAL1) then		-- Si la suma de los valores de LIN supera 15:
					s_valor <= '1';				-- el flanco sera de subida
				end if;
				
			end if;
	end process;

	VALOR <= s_valor;
	
end Behavioral;

