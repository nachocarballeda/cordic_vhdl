library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity driver is
	port(
		pixel_x_i: in std_logic_vector(9 downto 0);
		pixel_y_i: in std_logic_vector(9 downto 0);
		font_col_o: out std_logic_vector(2 downto 0);
		font_row_o: out std_logic_vector(2 downto 0);
		sel_o: out std_logic_vector(2 downto 0)
		);
end driver;

architecture driver_arq of driver is
--Variables auxiliares para pasar datos a las funciones--
	--posiciones de los pixeles
	signal posicion_row :  std_logic_vector(6 downto 0);
	signal posicion_col : std_logic_vector(6 downto 0);	
---------------------------------------------------------

-----------------Comienzo arquitectura-------------------
begin
-------------------------Process-------------------------
	process(pixel_y_i, pixel_x_i, posicion_col, posicion_row)
	begin
		posicion_col <= pixel_x_i(9 downto 3);
		posicion_row <= pixel_y_i(9 downto 3);
		if posicion_row = "0011110" then
			case posicion_col is
				when "0100101" => sel_o <= "010";
				when "0100110" => sel_o <= "011";
				when "0100111" => sel_o <= "001";
				when "0101000" => sel_o <= "000";
				when "0101001" => sel_o <= "101";
				when others => sel_o <= "100"; --Caracter vacio
			end case;
		else
			sel_o <= "100"; --Caracter vacio
		end if;
		font_row_o <= pixel_y_i(2 downto 0);
		font_col_o <= pixel_x_i(2 downto 0);
	end process;
---------------------------------------------------------

end driver_arq;
---------------------------------------------------------

