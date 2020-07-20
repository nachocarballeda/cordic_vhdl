library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity top_level is
	port(
		-- VGA
		clk_tl			:	in std_logic;
		hs_tl, vs_tl	:	out std_logic;
		pixel_row_tl	:	out std_logic_vector(9 downto 0);
		pixel_col_tl	:	out std_logic_vector(9 downto 0);
		red_out_tl	:	out std_logic_vector(2 downto 0);
		grn_out_tl	:	out std_logic_vector(2 downto 0);
		blu_out_tl	:	out std_logic_vector(1 downto 0);
		-- UART
		rx_tl	:	in std_logic;
		tx_tl	:	out std_logic;
		-- LEDS
		led_tl: out std_logic_vector(3 downto 0)
		);
end entity;

architecture top_level_arq of top_level is
	--- Prototipos ---
	component vga_ctrl is
		port(
			mclk, red_i, grn_i, blu_i	: in std_logic;
			hs, vs	: out std_logic;
			red_o	: out std_logic_vector(2 downto 0);
			grn_o	: out std_logic_vector(2 downto 0);
			blu_o	: out std_logic_vector(1 downto 0);
			pixel_row, pixel_col: out std_logic_vector(9 downto 0)
			);
	end component;
	
	component RAM is
		port(
			clka	:	in std_logic;
			wea		:	in std_logic_vector(0 downto 0);
			addra	:	in std_logic_vector(13 downto 0);
			dina	:	in std_logic_vector(7 downto 0);
			douta	:	out std_logic_vector(7 downto 0)
			);
	end component;
	
	component uart is
		generic(F: natural; min_baud: natural; num_data_bits: natural);
		port(
			Rx		:	in std_logic;
			Tx		:	out std_logic;
			Din		:	in std_logic_vector(7 downto 0);
			StartTx	:	in std_logic;
			TxBusy	:	out std_logic;
			Dout	:	out std_logic_vector(7 downto 0);
			RxRdy	:	out std_logic;
			RxErr	:	out std_logic;
			Divisor	:	in std_logic_vector; 
			clk		:	in std_logic;
			rst		:	in std_logic
		);
	end component;
	
	component dpram is
	generic (
		BYTES_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bytes
		ADDR_BITS : natural := 8 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS
	);
	port (
		rst		: in std_logic;
		clk		: in std_logic;
		data_wr : in std_logic_vector(BYTES_WIDTH*8-1 downto 0);
		addr_wr : in std_logic_vector(ADDR_BITS-1 downto 0);
		ena_wr 	: in std_logic;
		addr_rd : in std_logic_vector(ADDR_BITS-1 downto 0);
		data_rd : out std_logic_vector(BYTES_WIDTH*8-1 downto 0)
	);
	end component;
	
---------------------------------------------------------

-- Constantes a utilizar --
	-- RAM Single Port
	constant DATA_WIDTH		: integer := 8;
	constant ADDRESS_WIDTH	: integer := 14;
	constant CYCLES_TO_WAIT	: integer := 4000;
	constant CYCLES_TO_WAIT_WIDTH 	: natural := 12;
	constant LINES_TO_RECEIVE		: natural := 11946;
    constant BYTES_TO_RECEIVE		: natural := 3*LINES_TO_RECEIVE;
	constant COORDS_WIDTH			: natural := 8;
	-- Dual Port RAM
	constant DPRAM_ADDR_BITS: natural 	:= 8;
	constant DPRAM_BYTES_WIDTH: natural := 8;

-- Variables auxiliares para pasar datos a las funciones --

	signal sig_aux_pixel_x_i: std_logic_vector(9 downto 0) := "0000000000";
	signal sig_aux_pixel_y_i: std_logic_vector(9 downto 0) := "0000000000";

    -- Utilizada para entender si estamos leyendo un valor de X, Y o Z (de RAM)
    signal xyz_selector_current, xyz_selector_next: natural := 0;
	
	-- VGA
	signal sig_blue_enable: std_logic;
	signal sig_red_enable: std_logic;
	signal sig_green_enable: std_logic;
	
	-- Coordenadas
    signal x_coord_current, x_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
    signal y_coord_current, y_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
    signal z_coord_current, z_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
	
	-- LEDS
	signal sig_led_aux: std_logic_vector(3 downto 0) := "0000";
	
	-- UART
	constant Divisor 			: std_logic_vector := "000000011011"; -- Divisor=27 para 115200 baudios
	signal sig_uart_data_in		: std_logic_vector(7 downto 0);
	signal sig_uart_data_out	: std_logic_vector(7 downto 0);
	signal sig_uart_rx_error	: std_logic;
	signal sig_uart_rx_ready	: std_logic;
	signal sig_uart_tx_busy		: std_logic;
	signal sig_uart_tx_start	: std_logic;
	signal sig_uart_readed_data	: std_logic_vector(7 downto 0);

    -- RAM
    signal sig_ram_address_in: std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (others => '0');
    signal sig_ram_data_out: std_logic_vector(DATA_WIDTH-1 downto 0);

	-- Dual Port RAM (for video)
	signal sig_vram_rst : std_logic;
	signal sig_vram_data_wr : std_logic_vector(DPRAM_BYTES_WIDTH*8-1 downto 0);
	signal sig_vram_addr_wr : std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
	signal sig_vram_ena_wr : std_logic;
	signal sig_vram_addr_rd : std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
	signal sig_vram_data_rd : std_logic_vector(DPRAM_BYTES_WIDTH*8-1 downto 0);
		
    -- State Machine
    type state_t is (initial_state, waiting_for_uart, waiting_for_sram,
    reading_from_uart, write_sram, uart_end_data_reception, idle, print);
    signal state_current, state_next : state_t := initial_state;
    signal sig_ram_address_current, sig_ram_address_next: natural := 0;
    signal sig_ram_rw_current, sig_ram_rw_next: std_logic_vector(0 downto 0) := "0";
    signal sig_ram_data_in_current, sig_ram_data_in_next: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal cycles_current, cycles_next: natural := CYCLES_TO_WAIT;
    signal sig_uart_bytes_received_current, sig_uart_bytes_received_next: natural := 0;

---------------------------------------------------------

-----------------Comienzo arquitectura--------------------

begin
  -- Update state & data registers
    process(clk_tl)
    begin
    if (clk_tl'event and clk_tl='1') then
        state_current <= state_next;
        sig_ram_address_current <= sig_ram_address_next;
        sig_ram_rw_current <= sig_ram_rw_next;
        sig_ram_data_in_current <= sig_ram_data_in_next;
        cycles_current <= cycles_next;
        sig_uart_bytes_received_current <= sig_uart_bytes_received_next;
		xyz_selector_current <= xyz_selector_next;
    end if;
    end process;

  -- next state logic
    process(sig_uart_readed_data, sig_ram_address_current, state_current, sig_ram_rw_current, xyz_selector_current,
    sig_ram_data_in_current, sig_ram_address_current, cycles_current, sig_uart_bytes_received_current)
    begin
        -- default values
        sig_ram_rw_next <= sig_ram_rw_current;
        sig_ram_data_in_next <= sig_ram_data_in_current;
        sig_ram_address_next <= sig_ram_address_current;
        sig_uart_bytes_received_next <= sig_uart_bytes_received_current;
        case state_current is
            when initial_state =>
				sig_led_aux <= "0000";
                if cycles_current = 0 then
                    state_next <= waiting_for_uart;
                else
                    cycles_next <= cycles_current - 1;
                    state_next <= initial_state;
                end if;
            when waiting_for_uart =>
				sig_led_aux <= "0001";
                if sig_uart_rx_ready = '1' then
                    state_next <= reading_from_uart;
                elsif sig_uart_bytes_received_current = BYTES_TO_RECEIVE then
                    state_next <= uart_end_data_reception;
                else
                    state_next <= waiting_for_uart;
                end if;
            when reading_from_uart =>
				sig_ram_data_in_next <= sig_uart_readed_data;
				state_next <= write_sram;
				sig_uart_bytes_received_next <= sig_uart_bytes_received_current + 1;
            when write_sram =>
				sig_ram_rw_next <= "1";
				state_next <= waiting_for_sram;
            when waiting_for_sram =>
				sig_ram_address_next <= sig_ram_address_current + 1;
				sig_ram_rw_next <= "1";  -- Necesitamos escribir
				state_next <= waiting_for_uart;
            when uart_end_data_reception =>
                state_next <= idle;
				sig_ram_rw_next <= "0"; -- Vamos a necesitar leer
                sig_ram_address_next <= 0; -- La prox address de RAM que nos interesa es 0
			when idle =>
				sig_led_aux <= "0010";
				state_next <= print;
			when print =>
				sig_led_aux <= "0011";
				case xyz_selector_current is
					when 0 =>
						x_coord_next <= sig_ram_data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when 1 =>
						y_coord_next <= sig_ram_data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when 3 =>
						z_coord_next <= sig_ram_data_out;
						xyz_selector_next <= xyz_selector_current + 1;
					when others =>
						xyz_selector_next <= 0;
					end case;
				sig_ram_address_next <= sig_ram_address_current + 1;
				state_next <= print;
        end case;
    end process;
	
---Instancias de las funciones utilizadas en la entity---

	-- VGA	
	vga_control : vga_ctrl
	port map(
			mclk => clk_tl,
			hs => hs_tl,
			vs => vs_tl,
			red_o => red_out_tl,
			grn_o => grn_out_tl,
			blu_o => blu_out_tl,
			red_i => sig_red_enable,
			grn_i => sig_green_enable,
			blu_i => sig_blue_enable,
			pixel_row => sig_aux_pixel_y_i,
			pixel_col => sig_aux_pixel_x_i
			);
	
	
	-- LEDS
	led_tl <= not sig_led_aux;
	
	-- RAM
	ram_internal : RAM
	port map (
		clka => clk_tl,
		wea => sig_ram_rw_current,
		addra => sig_ram_address_in,
		dina => sig_ram_data_in_current,
		douta => sig_ram_data_out
	);
	
	sig_ram_address_in <= std_logic_vector(to_unsigned(sig_ram_address_current, ADDRESS_WIDTH));
	
	-- UART Instanciation :
	uart_load_data : uart
	generic map (
		F 	=> 50000,
		min_baud => 1200,
		num_data_bits => 8
	)
	port map (
		Rx	=> rx_tl,
	 	Tx	=> tx_tl,
	 	Din => sig_uart_data_in,
	 	StartTx => sig_uart_tx_start,
		TxBusy => sig_uart_tx_busy,
		Dout	=> sig_uart_data_out,
		RxRdy	=> sig_uart_rx_ready,
		RxErr	=> sig_uart_rx_error,
		Divisor	=> Divisor,
		clk	=> clk_tl,
		rst	=> '0'
	);
	
	dpram_vram : dpram
	generic map(
		BYTES_WIDTH => DPRAM_BYTES_WIDTH,
		ADDR_BITS => DPRAM_ADDR_BITS
	)
	port map(
		rst => sig_vram_rst,
		clk => clk_tl,
		data_wr => sig_vram_data_wr,
		addr_wr => sig_vram_addr_wr,
		ena_wr  => sig_vram_ena_wr,
		data_rd => sig_vram_data_rd,
		addr_rd => sig_vram_addr_rd
	);
	
end top_level_arq;
