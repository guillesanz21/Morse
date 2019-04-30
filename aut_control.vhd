----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:28 11/20/2018 
-- Design Name: 
-- Module Name:    aut_control - Behavioral 
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

entity aut_control is
    Port ( CLK_1ms : in  STD_LOGIC;			-- El CLK de 1 KHz
           VALID : in  STD_LOGIC;			-- entrada de dato valido
           DATO : in  STD_LOGIC;				-- dato (0 o 1)
           C0 : in  STD_LOGIC;				-- resultado comparador de ceros
           C1 : in  STD_LOGIC;				-- resultado comparador de unos
           C2 : in  STD_LOGIC;				-- resultado comparador de ceros para separador
			  BTN : in STD_LOGIC;				-- Boton 3 de la FPGA
           CODIGO : out  STD_LOGIC_VECTOR (7 downto 0);	-- codigo morse obtenido
           VALID_DISP : out  STD_LOGIC;	-- validacion del display
			  LED_FIN : out STD_LOGIC);		-- bit que enciende el led LD1
end aut_control;

architecture Behavioral of aut_control is

type STATE_TYPE is (ESPACIO, RESET, SIMBOLO, ESPERA, SEPARADOR, FIN_MENSAJE);		-- Estados
signal ST : STATE_TYPE := RESET;					-- El automata empieza en el estado RESET

-- Representacion binaria en Morse: s_cod indica la representacion en Morse alineada a 
-- la izquierda(1 es raya, 0 es punto), s_ncod indica cuantos símbolos hay en la representacion
-- Por tanto la representacion binaria de Morse es asi: s_ncod | s_cod

signal s_ncod : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal s_cod  : STD_LOGIC_VECTOR (4 downto 0) := "00000";	
signal n : INTEGER range 0 to 4;		-- Se utilizara para ver la posicion del simbolo en la representacion


begin

process (CLK_1ms)
	begin
	if (CLK_1ms'event and CLK_1ms='1') then
		case ST is
			when SIMBOLO =>			-- Estado SIMBOLO: se coloca el simbolo entrante en la representacion
				s_ncod<=s_ncod+1;		-- Indica que hay un simbolo mas en el CODIGO
				s_cod(n)<=C1;			-- Coloca el simbolo entrante en CODIGO
				n<=n-1;					-- Resta uno para posicionar bien el siguiente simbolo
				ST<=ESPERA;				-- Se va al estado ESPERA (siempre)
					
			when ESPERA =>				-- Estado ESPERA
				if (VALID='0' or (VALID='1' and DATO='0' and C0='0')) then	-- pausa	(si recibe ceros durante 100 ms)
					ST<=ESPERA;
				elsif (VALID='1' and DATO='1' ) then 						-- simbolo (si recibe un uno)
					ST<=SIMBOLO;
				elsif (VALID='1' and DATO='0' and C0='1' and C2 = '0') then			-- espacio	(si recibe ceros durante 300 ms)
					ST<=ESPACIO;
				elsif (VALID='1' and DATO='0' and C2='1') then
					ST<=SEPARADOR;
				end if;
				
			when SEPARADOR =>			-- Estado SEPARADOR
				-- Asigna la letra X, ya que esta no se puede representar
				s_ncod <= "100";		
				s_cod <= "10010";
				if (s_ncod = "011" and s_cod = "10100") then
					ST<=FIN_MENSAJE;
				else
					ST <= ESPACIO;			-- Se va a ESPACIO (siempre)
				end if;
				
			when ESPACIO =>			-- Estado EsPACIO
				ST<=RESET;				-- Se va al estado RESET (siempre)
						
			when FIN_MENSAJE =>
				if (BTN = '0') then		-- vuelve a FIN_MENSAJe si el BTN3 = OFF
					s_ncod <= "100";		-- Asigna la letra X mientras este en este estado
					s_cod <= "10010";
					ST<=FIN_MENSAJE;	
				else							-- si no, se va al estado RESET
					ST<=RESET;
				end if;

			when RESET =>					-- Estado RESET
				n <= 4;						-- Resetea n a 4
				s_ncod<="000";				-- Resetea s_ncod a 0
				s_cod<="00000";			-- Resetea s_cod a 0
				if (VALID='1' and DATO='1') then				-- simbolo (si recibe un uno)
					ST<=SIMBOLO;
				else													-- reset (si recibe un cero)
					ST<=RESET;
				end if;

		end case;
	end if;
end process;

-- PARTE COMBINACIONAL

-- Valida el display cuando entra un espacio (es decir, el codigo esta completo), separador o una k 
VALID_DISP<='1' when (ST=ESPACIO or ST=SEPARADOR or ST=FIN_MENSAJE) else '0';		
-- El CODIGO se compone de: s_ncod | s_cod
CODIGO(4 downto 0)<= s_cod; 
CODIGO(7 downto 5)<= s_ncod; 
LED_FIN <= '1' when (ST=FIN_MENSAJE) else '0';

end Behavioral;

