----------------------------------------------------------------------------------
-- Departamento de Ingeniería Electrónica
-- Generación de señal morse
----------------------------------------------------------------------------------
-- A partir de los datos almacenados en la señal SECUENCIA
-- Cada 0 y 1 duran 100 ms
-- un 1 es un PUNTO
-- tres 1s seguidos es una RAYA
-- un 0 es una PAUSA entre símbolos
-- tres 0s seguidos es un ESPACIO entre caracteres
-- siete 000s seguidos en una SEPARACIÓN entre palabras
-- La secuencia se repite indefinidamente
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity generador_morse is
    Port ( CLK : in  STD_LOGIC;
           SEC : out  STD_LOGIC);
end generador_morse;

architecture a_generador_morse  of generador_morse is

signal s_clk: STD_LOGIC:='0';
signal cont,cuenta: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');

---SECUENCIA a transmitir, en hexadecimal

constant long_sec : INTEGER := 264; -- Longitud de la secuencia 
signal secuencia  : STD_LOGIC_VECTOR (long_sec-1 downto 0):=x"1D7445D47177771DDD45DDDC777745DD1745C75D1C51D745C7545C5451D745C75C";
-- Mensaje CELT1819PRACTICABASICAK
 
--constant long_sec : INTEGER := 100; -- Longitud de la secuencia 
--signal secuencia  : STD_LOGIC_VECTOR (long_sec-1 downto 0):=x"02A8EEE2EA2E03BA2B8B8EBB8";


type STATE_TYPE is (UNO,CERO);
signal ST : STATE_TYPE := CERO;

begin


U2 : process(CLK)
  begin
  if (CLK'event and CLK='1') then
    cont<=cont+1;
	 if (cont=25000) then          -- semiperiodo de 500 us
	   cont<=(others=>'0');
		s_clk<=not s_clk;
	 end if;
  end if;
  
  end process;


-- Autómata que genera la secuencia
U5: process (s_clk)

   begin
	if (s_clk'event and s_clk='1') then

    case ST is
	    
		   when UNO =>
			    
				cuenta <= cuenta +1;
				if cuenta >= 99 then 
				   cuenta <= (others =>'0');
					secuencia <= secuencia(long_sec-2 downto 0) & secuencia(long_sec-1);
--					secuencia <= secuencia(long_sec-2 downto 0) & '0';
					if secuencia(long_sec-1)='0' then 
					  ST<=CERO;
					 else
					  ST<=UNO;
					end if;
				 else 
				    ST<=UNO;
				end if;


        when CERO =>
			    
				cuenta <= cuenta +1;
				if cuenta >= 99 then 
				   cuenta <= (others =>'0');
					secuencia <= secuencia(long_sec-2 downto 0) & secuencia(long_sec-1);
--					secuencia <= secuencia(long_sec-2 downto 0) & '0';
					if secuencia(long_sec-1)='0' then 
					  ST<=CERO;
					 else
					  ST <=UNO;
					end if;
				 else 
				    ST <=CERO;
				end if;
				
			when others =>
			     ST<= CERO;
		end case;
		end if;
	end process;
	
	
SEC<='1' when ST=UNO else '0';

	
end a_generador_morse ;





