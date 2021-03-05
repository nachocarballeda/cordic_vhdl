library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
use IEEE.std_logic_ARITH.ALL;

-- The Entity Declarations

entity LED8 is
	PORT 
	(
		-- rst & Clock signal 
		rst: 		in std_logic; 
		clk:		in std_logic;	-- 50 MHz 

		-- LED8 Pin 
		led_out:	out std_logic_vector(7 downto 0);	-- LED Segment 
		digit_select:	out std_logic_vector(3 downto 0);	-- LED Digit
        show_number:    in  std_logic_vector(7 downto 0)
	);
end LED8;

-- The architecture of Entity Declarations 
architecture Behavioral OF LED8 is

    signal Period1uS, Period1mS: std_logic;
    signal LED, LED0, LED1, LED2, LED3:	std_logic_vector(3 downto 0);

    component binary_bcd is
        generic(N: positive);
        port(
            clk, reset: in std_logic;
            binary_in: in std_logic_vector(N-1 downto 0);
            bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
        );
    end component;

begin
	
	-- Clock
	process( rst, clk, Period1uS, Period1mS )
		variable Count  : std_logic_vector(5 downto 0);
		variable Count1 : std_logic_vector(9 downto 0);
	begin
		--Period: 1uS 
		if( rst = '1' ) then 
			Count := "000000";
		elsif( clk'EVENT and clk='1' ) then 
			if( Count>"110000" ) then 	Count := "000000";	--  110000:48  50/50M = 1us
			else                  		Count := Count + 1;
			end if;
			Period1uS <= Count(5);
		end if;
		--Period: 1mS 
		if( Period1uS'EVENT and Period1uS='1' ) then 
			if( Count1>"1111100110" ) then 	Count1 := "0000000000";  -- 1111100110:998  1000*1us = 1ms
			else                  			Count1 := Count1 + 1;
			end if;
			Period1mS <= Count1(9);

		end if;
	end process;
	
	-------------------------------------------------
	-- Encoder 
	-------------------------------------------------
	-- HEX-to-seven-segment decoder 
	-- segment encoding 
	--      0 
	--     ---  
	--  5 |   | 1
	--     --- <------6
	--  4 |   | 2
	--     ---  
	--      3
	process(LED)
	begin
		case LED is
			when "0000"=>led_out<= "11000000";    --'0'
			when "0001"=>led_out<= "11111001";    --'1'
			when "0010"=>led_out<= "10100100";    --'2'
			when "0011"=>led_out<= "10110000";    --'3'
			when "0100"=>led_out<= "10011001";    --'4'
			when "0101"=>led_out<= "10010010";    --'5'
			when "0110"=>led_out<= "10000010";    --'6'
			when "0111"=>led_out<= "11111000";    --'7'
			when "1000"=>led_out<= "10000000";    --'8'
			when "1001"=>led_out<= "10010000";    --'9'
			when "1010"=>led_out<= "10001000";    --'A'
			when "1011"=>led_out<= "10000011";    --'b'
			when "1100"=>led_out<= "11000110";    --'C'
			when "1101"=>led_out<= "10100001";    --'d'
			when "1110"=>led_out<= "10000110";    --'E'
			when "1111"=>led_out<= "10001110";    --'F'
			when others=>led_out<= "XXXXXXXX";    --' '
		end case;
	end process;
	
	-------------------------------------------------
	
    process(rst, Period1mS)
        variable selector: integer range 0 to 3;
        begin
        if(rst='1') then
            selector := 0;
        elsif(Period1mS'EVENT and Period1mS = '1') then
            case selector is
                when 0=>
                     digit_select<= "0001";
                     LED <= LED0;
				when 1=>
                     digit_select<= "0010";
                     LED <= LED1;
				when 2=>
                     digit_select<= "0100";
                     LED <= LED2;
				when 3=>
                     digit_select<= "1000";
                     LED <= LED3;
                when others=>
                     digit_select<= "XXXX";
                     LED <= "0000";
            end case;
            selector := selector +1;
        end if;
    end process;
    
    
	-------------------------------------------------
   	-- Binary to BCD converter
    
	b_to_bcd : binary_bcd  
	generic map (
		N 	=> 8
	)
	port map (
        clk => clk,
        reset => rst,
        binary_in => show_number,
        bcd0 => LED0,
        bcd1 => LED1,
        bcd2 => LED2,
        bcd3 => LED3,
        bcd4 => open
	);
    
end Behavioral;
