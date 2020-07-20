library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity mux_ROMtoVGA is
	port(
		char0, char1, char2, char3, char4, char5: in std_logic_vector(3 downto 0);
		sel: in std_logic_vector(2 downto 0);
		char_adress : out std_logic_vector(5 downto 0)
		);
end mux_ROMtoVGA;

architecture mux_ROMtoVGA_arq of mux_ROMtoVGA is 
--Variables auxiliares para pasar datos a las funciones--
	signal aux: std_logic_vector(3 downto 0);
---------------------------------------------------------
begin
-----------------Comienzo arquitectura--------------------
	--cargo aux para seleccionar el address a imprimir
	aux <=	char0 when sel = "000" else 
				char1 when sel = "001" else
				char2 when sel = "010" else
				char3 when sel = "011" else
				char4 when sel = "100" else
				char5;
	--mux para determinar el address a imprimir
	char_adress <= "000000" when aux = "0000" else
						"000001" when aux = "0001" else
						"000010" when aux = "0010" else
						"000011" when aux = "0011" else
						"000100" when aux = "0100" else
						"000101" when aux = "0101" else
						"000110" when aux = "0110" else
						"000111" when aux = "0111" else
						"001000" when aux = "1000" else
						"001001" when aux = "1001" else
						"001010" when aux = "1010" else
						"001011" when aux = "1011" else
						"001100" when aux = "1100" else
						"001101" when aux = "1101" else
						"001110";--caracter error
						
end mux_ROMtoVGA_arq;
---------------------------------------------------------
