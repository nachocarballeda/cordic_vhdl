library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Char_ROM is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		char_address: in std_logic_vector(5 downto 0);
		font_row, font_col: in std_logic_vector(M-1 downto 0);
		rom_out: out std_logic
	);
end;

architecture p of Char_ROM is
	subtype tipoLinea is std_logic_vector(0 to W-1);

	type char is array(0 to W-1) of tipoLinea;
	constant num0: char:= (
								"00000000",
								"00111100",
								"01100110",
								"01100110",
								"01100110",
								"01100110",
								"00111100",
								"00000000"
						);
	constant num1: char:= (
								"00000000",
								"00000110",
								"00000110",
								"00000110",
								"00000110",
								"00000110",
								"00000110",
								"00000000"
						);
	constant num2: char:= (
								"00000000",
								"01111100",
								"00000110",
								"00111100",
								"01100000",
								"01100000",
								"01111110",
								"00000000"
						);

	constant num3: char:= (
								"00000000",
								"01111110",
								"00000110",
								"00011110",
								"00000110",
								"00000110",
								"01111110",
								"00000000"
						);

	constant num4: char:= (
								"00000000",
								"01100110",
								"01100110",
								"01100110",
								"01111110",
								"00000110",
								"00000110",
								"00000000"
						);

	constant num5: char:= (
								"00000000",
								"01111110",
								"01100000",
								"01111100",
								"00000110",
								"00000110",
								"01111100",
								"00000000"
						);

	constant num6: char:= (
								"00000000",
								"00111110",
								"01100000",
								"01111100",
								"01100110",
								"01100110",
								"00111100",
								"00000000"
						);

	constant num7: char:= (
								"00000000",
								"01111110",
								"00000110",
								"00000110",
								"00000110",
								"00000110",
								"00000110",
								"00000000"
						);
						
	constant num8: char:= (
								"00000000",
								"00111100",
								"01100110",
								"00011000",
								"00011000",
								"01100110",
								"00111100",
								"00000000"
						);
						
	constant num9: char:= (
								"00000000",
								"00111100",
								"01100110",
								"00111110",
								"00000110",
								"00000110",
								"00000110",
								"00000000"
						);
						
	constant punto: char:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00111100",
								"00111100",
								"00000000"
						);
						
	constant espacio: char:= (
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000",
								"00000000"
						);
						
	constant letra_v: char:= (
								"00000000",
								"01100110",
								"01100110",
								"01100110",
								"01100110",
								"00111100",
								"00011000",
								"00000000"
						);
	constant tipito: char:= (
								"00011000",
								"00011000",
								"01111110",
								"01011010",
								"01011010",
								"00100100",
								"00100100",
								"11100111"
						);							

	type memo is array(0 to 255) of tipoLinea;
	signal RAM: memo:= (
								0 => num0(0), 1 => num0(1), 2 => num0(2), 3 => num0(3), 4 => num0(4), 5 => num0(5), 6 => num0(6), 7 => num0(7),
								8 => num1(0), 9 => num1(1), 10 => num1(2), 11 => num1(3), 12 => num1(4), 13 => num1(5), 14 => num1(6), 15 => num1(7),
								16 => num2(0), 17 => num2(1), 18 => num2(2), 19 => num2(3), 20 => num2(4), 21 => num2(5), 22 => num2(6), 23 => num2(7),
								24 => num3(0), 25 => num3(1), 26 => num3(2), 27 => num3(3), 28 => num3(4), 29 => num3(5), 30 => num3(6), 31 => num3(7),
								32 => num4(0), 33 => num4(1), 34 => num4(2), 35 => num4(3), 36 => num4(4), 37 => num4(5), 38 => num4(6), 39 => num4(7),
								40 => num5(0), 41 => num5(1), 42 => num5(2), 43 => num5(3), 44 => num5(4), 45 => num5(5), 46 => num5(6), 47 => num5(7),
								48 => num6(0), 49 => num6(1), 50 => num6(2), 51 => num6(3), 52 => num6(4), 53 => num6(5), 54 => num6(6), 55 => num6(7),
								56 => num7(0), 57 => num7(1), 58 => num7(2), 59 => num7(3), 60 => num7(4), 61 => num7(5), 62 => num7(6), 63 => num7(7),
								64 => num8(0), 65 => num8(1), 66 => num8(2), 67 => num8(3), 68 => num8(4), 69 => num8(5), 70 => num8(6), 71 => num8(7),
								72 => num9(0), 73 => num9(1), 74 => num9(2), 75 => num9(3), 76 => num9(4), 77 => num9(5), 78 => num9(6), 79 => num9(7),
								80 => punto(0), 81 => punto(1), 82 => punto(2), 83 => punto(3), 84 => punto(4), 85 => punto(5), 86 => punto(6), 87 => punto(7),
								88 => espacio(0),89 => espacio(1),90 => espacio(2),91 => espacio(3),92 => espacio(4),93 => espacio(5), 94=> espacio(6),95 => espacio(7),
								96 => letra_v(0),97 => letra_v(1),98 => letra_v(2),99 => letra_v(3),100 => letra_v(4),101 => letra_v(5),102=> letra_v(6),103 => letra_v(7),
								104 => tipito(0), 105 => tipito(1), 106 => tipito(2), 107 => tipito(3), 108 => tipito(4), 109 => tipito(5), 110 => tipito(6), 111 => tipito(7), 
								112 to 255 => "00000000"
							);

	signal char_addr_aux: std_logic_vector(8 downto 0);
	
begin

	char_addr_aux <= char_address & font_row;
	rom_out <= RAM(conv_integer(char_addr_aux))(conv_integer(font_col));

end;