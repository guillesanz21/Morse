----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:44:07 11/13/2018 
-- Design Name: 
-- Module Name:    aut_duracion - Behavioral 
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

entity aut_duracion is
    Port ( CLK_1ms : in  STD_LOGIC;			-- El CLK de 1 Khz
           ENTRADA : in  STD_LOGIC;			-- Indica el tipo de flanco
           VALID : out  STD_LOGIC;			-- Indica que ya ha calculado la duracion de los 0 o los 1
           DATO : out  STD_LOGIC;			--	Indica si se trata de un 1 o un 0
           DURACION : out  STD_LOGIC_VECTOR (15 downto 0));		-- Indica la duracion de los 0 y los 1
end aut_duracion;

architecture Behavioral of aut_duracion is

type STATE_TYPE is (CERO,ALM_CERO,VALID_CERO,UNO,ALM_UNO,VALID_UNO,VALID_FIN);	-- Estados
signal ST : STATE_TYPE := CERO;										-- El automata empieza en el estado CERO
signal cont : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";		-- El contador inicializa en 0
signal reg : STD_LOGIC_VECTOR (15 downto 0) :="0000000000000000";		-- El registro inicializa en 0

begin

process (CLK_1ms) -- autómata
	begin
	if (CLK_1ms'event and CLK_1ms='1') then
		case ST is
			when CERO =>						-- Estado CERO
				cont<=cont+1;					-- Sumo 1 al contador
				if (cont > 1000) then		-- Si lo cumple se va al estado VALID_FIN
					ST <= VALID_FIN;
				elsif (ENTRADA='0') then	-- Si lo cumple vuelve al estado CERO
					ST<=CERO;	
				else								-- En cualquier otro caso se va a ALM_CERO
					ST<=ALM_CERO;
				end if;
				
			when ALM_CERO =>						-- Estado ALM_CERO
				reg <= cont;						-- El registro toma el valor del contador
				cont <= "0000000000000000";	-- y resetea el contador a 0
				ST<=VALID_CERO;					-- Se va al estado VALID_CERO (siempre)
				
			when VALID_CERO =>				-- Estado VALID_CERO
				ST<= UNO;						-- Se va al estado UNO (siempre)
				
			when UNO =>							-- Estado UNO
				cont <= cont+1;				-- Suma 1 al contador
				if (ENTRADA='1') then		-- Si lo cumple vuelve al estado UNO
					ST<=UNO;						
				else								-- En el resto de casos se va al ESTADO ALM_UNO
					ST<=ALM_UNO;				
				end if;
				
			when ALM_UNO =>						-- Estado ALM_UNO
				reg <= cont;						-- El registro toma el valor del contador
				cont <= "0000000000000000";	-- y resetea el contador a 0
				ST<=VALID_UNO;						-- Se va al estado VALID_UNO (siempre)
				
			when VALID_UNO =>					-- Estado VALID_UNO
				ST<= CERO;						-- Se va al estado CERO (siempre)
					
			when VALID_FIN =>						-- Estado VALID_FIN
				reg <= cont;						-- El registro toma el valor del contador
				cont <= "0000000000000000";	-- y reseta el contador a 0
				ST <= CERO;							-- Se va al estado CERO (siempre)
		end case;
	end if;
end process;

	-- VALID vale 1 cuando se valida un cero, un uno o cuando llegan demasiados ceros
 VALID<='1' when (ST=VALID_CERO or ST=VALID_UNO or ST=VALID_FIN) else '0';		
	-- DATO vale 1 en los estados referentes al calculo de la duracion de unos, 
	-- y vale 0 en los referentes a la duracion de ceros
 DATO <='1' when (ST=UNO or ST=ALM_UNO or ST=VALID_UNO) else '0';			
	-- DURACION toma el valor de la señal reg (registro),	
	-- que esta lo que hace es toma el valor del contador de unos o ceros																				
 DURACION<= reg;				 
									
 
end Behavioral;

