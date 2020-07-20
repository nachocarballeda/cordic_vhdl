library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity top_level is
	port(
		-- VGA
		clk, enable, rst:	in std_logic;
		hs_tl, vs_tl:	out std_logic;
		pixel_row_tl:	out std_logic_vector(9 downto 0);
		pixel_col_tl:	out std_logic_vector(9 downto 0);
		red_out_tl:		out std_logic_vector(2 downto 0);
		grn_out_tl:	out std_logic_vector(2 downto 0);
		blu_out_tl:	out std_logic_vector(1 downto 0);
		-- UART
		rx :	in std_logic;
		tx :	out std_logic;
		-- RAM
		wea :	in std_logic_vector(0 downto 0);		-- RAM write enable 
		addra :	in std_logic_vector(13 downto 0); 		-- RAM Address
		dina :	in std_logic_vector(7 downto 0);		-- RAM Data In
		douta :	out std_logic_vector(7 downto 0);		-- RAM Data Oout
		-- CORE LEDS
		led: out std_logic_vector(3 downto 0)
		);
end entity;

architecture top_level_arq of top_level is
	--- Prototipos ---
	component vga_ctrl is
		port(
			mclk, red_i, grn_i, blu_i: in std_logic;
			hs, vs: out std_logic;
			red_o: out std_logic_vector(2 downto 0);
			grn_o: out std_logic_vector(2 downto 0);
			blu_o: out std_logic_vector(1 downto 0);
			pixel_row, pixel_col: out std_logic_vector(9 downto 0)
			);
	end component;
	
	component RAM is
		port(
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(13 downto 0);
			dina : in std_logic_vector(7 downto 0);
			douta : out std_logic_vector(7 downto 0)
			);
	end component;
	
		component uart
		generic(F: natural; min_baud: natural; num_data_bits: natural);
		port(
			Rx: in std_logic;
			Tx: out std_logic;
			Din: in std_logic_vector(7 downto 0);
			StartTx: in std_logic;
			TxBusy: out std_logic;
			Dout: out std_logic_vector(7 downto 0);
			RxRdy: out std_logic;
			RxErr: out std_logic;
			Divisor: in std_logic_vector; 
			clk: in std_logic;
			rst: in std_logic
		);
	end component;

	
---------------------------------------------------------

-- Constantes a utilizar --
	constant DATA_WIDTH: integer := 8;
	constant ADDRESS_WIDTH: integer := 14;
	constant CYCLES_TO_WAIT: integer := 4000;
	constant CYCLES_TO_WAIT_WIDTH : natural := 12;
	constant LINES_TO_RECEIVE: natural := 11946;
    constant BYTES_TO_RECEIVE: natural := 3*LINES_TO_RECEIVE;
	constant COORDS_WIDTH: natural := 8;

-- Variables auxiliares para pasar datos a las funciones --

	signal aux_pixel_x_i: std_logic_vector(9 downto 0) := "0000000000";
	signal aux_pixel_y_i: std_logic_vector(9 downto 0) := "0000000000";
	
	-- para printer villero
	signal red_enable_tl: std_logic := '0';
	signal green_enable_tl: std_logic := '0';
	signal blue_enable_tl: std_logic := '0';

    -- Utilizada para entender si estamos leyendo un valor de X, Y o Z (de RAM)
    signal xyz_selector_current, xyz_selector_next: natural := 0;
	
	-- Coordenadas
    signal x_coord_current, x_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
    signal y_coord_current, y_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
    signal z_coord_current, z_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
	
	-- LEDS del CORE
	signal led_aux: std_logic_vector(3 downto 0) := "0000";
	
	-- UART
	constant Divisor : std_logic_vector := "000000011011"; -- Divisor=27 para 115200 baudios
	signal sig_Din	: std_logic_vector(7 downto 0);
	signal sig_Dout	: std_logic_vector(7 downto 0);
	signal sig_RxErr	: std_logic;
	signal sig_RxRdy	: std_logic;
	signal sig_TxBusy	: std_logic;
	signal sig_StartTx: std_logic;
	signal r_data: std_logic_vector(7 downto 0);

    -- RAM
    signal data_in: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal address_in: std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (others => '0');
    signal data_out: std_logic_vector(DATA_WIDTH-1 downto 0);

    -- State Machine
    type state_t is (initial_state, waiting_for_uart, waiting_for_sram,
    reading_from_uart, write_sram, uart_end_data_reception, idle, print);
    signal state_current, state_next : state_t := initial_state;
    signal address_current, address_next: natural := 0;
    signal rw_current, rw_next: std_logic_vector(0 downto 0) := "0";
    signal data_in_current, data_in_next: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal cycles_current, cycles_next: natural := CYCLES_TO_WAIT;
    signal bytes_received_current, bytes_received_next: natural := 0;

---------------------------------------------------------

-----------------Comienzo arquitectura--------------------

begin
  -- Update state & data registers
    process(clk)
    begin
    if (clk'event and clk='1') then
        state_current <= state_next;
        address_current <= address_next;
        rw_current <= rw_next;
        data_in_current <= data_in_next;
        cycles_current <= cycles_next;
        bytes_received_current <= bytes_received_next;
		xyz_selector_current <= xyz_selector_next;
    end if;
    end process;

  -- next state logic
    process(r_data, address_current, state_current, rw_current, xyz_selector_current,
    data_in_current, address_current, cycles_current, rst, bytes_received_current)
    begin
        -- default values
        rw_next <= rw_current;
        data_in_next <= data_in_current;
        address_next <= address_current;
        bytes_received_next <= bytes_received_current;
        case state_current is
            when initial_state =>
				led_aux <= "0000";
                if cycles_current = 0 then
                    state_next <= waiting_for_uart;
                else
                    cycles_next <= cycles_current - 1;
                    state_next <= initial_state;
                end if;
            when waiting_for_uart =>
				led_aux <= "0001";
                if sig_RxRdy = '1' then
                    state_next <= reading_from_uart;
                elsif bytes_received_current = BYTES_TO_RECEIVE then
                    state_next <= uart_end_data_reception;
                else
                    state_next <= waiting_for_uart;
                end if;
            when reading_from_uart =>
				data_in_next <= r_data;
				state_next <= write_sram;
				bytes_received_next <= bytes_received_current + 1;
            when write_sram =>
				rw_next <= "1";
				state_next <= waiting_for_sram;
            when waiting_for_sram =>
				address_next <= address_current + 1;
				rw_next <= "1";  -- Necesitamos escribir
				state_next <= waiting_for_uart;
            when uart_end_data_reception =>
                state_next <= idle;
				rw_next <= "0"; -- Vamos a necesitar leer
                address_next <= 0; -- La prox address de RAM que nos interesa es 0
			when idle =>
				led_aux <= "0010";
				state_next <= print;
			when print =>
				led_aux <= "0011";
				case xyz_selector_current is
					when 0 =>
						x_coord_next <= data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when 1 =>
						y_coord_next <= data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when 3 =>
						z_coord_next <= data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when others =>
						xyz_selector_next <= 0;
					end case;
				address_next <= address_current + 1;
				state_next <= print;
        end case;
    end process;
	
	-- print villero, agarra coordenadas y manda pixeles donde se le canta
    process(clk)
    begin
		if (aux_pixel_x_i = x_coord_current) then -- esto no va a darse nunca, y si se da es casualidad, por cada coordenada, deberiamos chechear en TODOS los pixeles si es que coincide, debemos hacer un driver para graficar...
			red_enable_tl <= '1';
		else
			red_enable_tl <= '0';
		end if;
	end process;
	
---Instancias de las funciones utilizadas en la entity---

	-- VGA	
	VGA_control : vga_ctrl
	port map(
			mclk => clk,
			hs => hs_tl,
			vs => vs_tl,
			red_o => red_out_tl,
			grn_o => grn_out_tl,
			blu_o => blu_out_tl,
			red_i => red_enable_tl,
			grn_i => green_enable_tl,
			blu_i => blue_enable_tl,
			pixel_row => aux_pixel_y_i,
			pixel_col => aux_pixel_x_i
			);
	
	
	-- LEDS
	led <= not led_aux;
	
	-- RAM
	ram_internal : RAM
	port map (
		clka => clk,
		wea => rw_current,
		addra => address_in,
		dina => data_in_current,
		douta => data_out
	);
	
	address_in <= std_logic_vector(to_unsigned(address_current, ADDRESS_WIDTH));
	
	-- UART Instanciation :
	UUT : uart
	generic map (
		F 	=> 50000,
		min_baud => 1200,
		num_data_bits => 8
	)
	port map (
		Rx	=> rx,
	 	Tx	=> tx,
	 	Din => sig_Din,
	 	StartTx => sig_StartTx,
		TxBusy => sig_TxBusy,
		Dout	=> sig_Dout,
		RxRdy	=> sig_RxRdy,
		RxErr	=> sig_RxErr,
		Divisor	=> Divisor,
		clk	=> clk,
		rst	=> rst
	);

end top_level_arq;
