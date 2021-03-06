library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity top_level is
    generic (
        -- RAM Single Port (IP Core Generated)
        constant RAM_DATA_WIDTH		: integer := 8;
        constant RAM_ADDRESS_WIDTH	: integer := 15; --32 kBytes de RAM
        constant CYCLES_TO_WAIT		: integer := 4000;
        constant UART_BYTES_TO_RECEIVE	: natural := 32768;
        constant UART_COORDS_WIDTH		: natural := 8;
        -- CORDIC Constants
        constant COORDS_WIDTH: integer := 8;
        constant ANGLE_WIDTH: integer := 10;
        constant CORDIC_STAGES: integer := 8;
        constant CORDIC_WIDTH: integer := 12;
        constant CORDIC_OFFSET: integer := 4;
        constant ANGLE_STEP_INITIAL: natural := 1;  
        constant CYCLES_TO_WAIT_TO_CORDIC_TO_FINISH: natural := 10;
        -- Dual Port RAM
        constant DPRAM_ADDR_BITS: natural 	:= 16; -- 8 KBytes 
        constant DPRAM_DATA_BITS_WIDTH: natural := 1
    );
    port (
        -- VGA signals (16I/OS2 : VGA Module)
        clk_tl  :   in std_logic;
        hs_tl, vs_tl    :   out std_logic;
        red_out_tl  :	out std_logic_vector(2 downto 0);
        grn_out_tl  :   out std_logic_vector(2 downto 0);
        blu_out_tl	:	out std_logic_vector(1 downto 0);
        -- UART pins (8I/OS1 : 2 pins for tx/rx)
        rx_tl	:	in std_logic;
        tx_tl	:	out std_logic;
        -- LEDS (16I/OS1 : 7-SEG-x4 board & Core Leds)
        led_tl: out std_logic_vector(3 downto 0);
        led_out_tl: out std_logic_vector(7 downto 0); -- LED Segment 
        led_select_tl: out std_logic_vector(3 downto 0); -- LED Digit 
        -- BUTTONS (8I/OS2 : 4x4 button Matrix)
        matrix_btn_col_tl: in std_logic_vector(3 downto 0); --ATT! Buttons with a PULLUP resistor
        matrix_btn_row_tl: in std_logic_vector(3 downto 0)
    );
end entity;

architecture top_level_arq of top_level is

-- Prototipos a utilizar
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

component SRAM is
    port(
        clka	:	in std_logic;
        rsta	:	in std_logic;
        wea		:	in std_logic_vector(0 downto 0);
        addra	:	in std_logic_vector(RAM_ADDRESS_WIDTH-1 downto 0);
        dina	:	in std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
        douta	:	out std_logic_vector(RAM_DATA_WIDTH-1 downto 0)
    );
end component;

component uart is
    generic(
        F: natural;
        min_baud: natural;
        num_data_bits: natural
    );
    port (
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
        DPRAM_BITS_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bits
        DPRAM_ADDR_BITS : natural := 16 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS)
    );
    port (
        rst		: in std_logic;
        clk		: in std_logic;
        data_wr : in std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0);
        addr_wr : in std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
        ena_wr 	: in std_logic;
        addr_rd : in std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
        data_rd : out std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0)
    );
end component;

component video_driver is
    generic (
        DPRAM_BITS_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bits
        DPRAM_ADDR_BITS : natural := 16 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS)
        );
        port (
        rst: in std_logic;
        clk: in std_logic;
        red_en_o: out std_logic;
        green_en_o: out std_logic;
        blue_en_o: out std_logic;
        pixel_x: in unsigned(9 downto 0);
        pixel_y: in unsigned(9 downto 0);
        addr_rd : out std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
        data_rd : in std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0)
    );
end component;

component LED8 is
    port (
        -- Reset & Clock Signal 
        rst: 		in std_logic; 
        clk:		in std_logic;	-- 50 MHz 
        -- LED8 PIN 
        led_out:	out	std_logic_vector(7 downto 0);	-- LED Segment 
        digit_select:	out	std_logic_vector(3 downto 0);	-- LED Digit 
        show_number:    in  std_logic_vector(7 downto 0)
    );
end component;

component rotator is
    generic (
        COORDS_WIDTH            : integer := CORDIC_WIDTH;
        ANGLES_INTEGER_WIDTH    : integer := ANGLE_WIDTH;
        STAGES                  : integer := CORDIC_STAGES
        );
        port (
        clk                         :   in std_logic;
        X0, Y0, Z0                  :   in signed(CORDIC_WIDTH-1 downto 0);
        angle_X, angle_Y, angle_Z   :   in signed(ANGLES_INTEGER_WIDTH-1 downto 0);
        X, Y, Z                     :   out signed(CORDIC_WIDTH-1 downto 0)
    );
end component;

component input_processor is
    generic (
        ANGLE_WIDTH           : integer := 10;
        ANGLE_STEP_INITIAL    : integer := 1
    );
    port ( 
           clk: in std_logic;
           matrix_buttons_col : in  std_logic_vector (3 downto 0);
           matrix_buttons_row : in  std_logic_vector (3 downto 0);
           angle_x : out  signed (ANGLE_WIDTH-1 downto 0);
           angle_y : out  signed (ANGLE_WIDTH-1 downto 0);
           angle_z : out  signed (ANGLE_WIDTH-1 downto 0);
           angle_step: out natural;
           reset_button: out std_logic
           );
end component;

signal rst_tl: std_logic := '1';

-- Señales auxiliares para pasar interconexion
signal sig_aux_pixel_x_i: std_logic_vector(9 downto 0) := (others => '0');
signal sig_aux_pixel_y_i: std_logic_vector(9 downto 0) := (others => '0');
signal pixel_x, pixel_y: unsigned(9 downto 0);

-- Utilizada para entender si estamos leyendo un valor de X, Y o Z (de RAM)
signal xyz_selector_current, xyz_selector_next: natural := 0;

-- VGA
signal sig_blue_enable: std_logic 	:= '0';
signal sig_red_enable: std_logic	:= '0';
signal sig_green_enable: std_logic	:= '0';

-- Coordenadas
signal x_coord_current, x_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
signal y_coord_current, y_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
signal z_coord_current, z_coord_next: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');

-- Entradas del rotador
signal X0, Y0, Z0: signed(CORDIC_WIDTH-1 downto 0);
-- Coordenadas rotadas
signal X_coord_rotated: signed(CORDIC_WIDTH-1 downto 0);
signal Y_coord_rotated: signed(CORDIC_WIDTH-1 downto 0);
signal Z_coord_rotated: signed(CORDIC_WIDTH-1 downto 0);
-- Coord rotadas no signaldas
signal X_coord_rotated_unsigned: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
signal Y_coord_rotated_unsigned: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');
signal Z_coord_rotated_unsigned: std_logic_vector(COORDS_WIDTH-1 downto 0) := (others => '0');

-- ángulos (van al cordic)
signal angle_x_tl: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_y_tl: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_z_tl: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
-- Angulos vienen del input processor
signal angle_x_from_input_proc: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_y_from_input_proc: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_z_from_input_proc: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
-- step
signal angle_step_tl: natural := ANGLE_STEP_INITIAL;

-- ángulos (entre 0 y 360)
signal angle360_x_current, angle360_x_next: unsigned(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle360_y_current, angle360_y_next: unsigned(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle360_z_current, angle360_z_next: unsigned(ANGLE_WIDTH-1 downto 0) := (others => '0');

-- LEDS
signal sig_led_aux: std_logic_vector(3 downto 0) := (others => '0');
signal sig_binary_to_bcd: std_logic_vector(7 downto 0) := (others => '0');

-- UART
constant Divisor 			: std_logic_vector := "000000011011"; -- Divisor=27 para 115200 baudios
signal sig_uart_rx_ready	: std_logic;
signal sig_uart_readed_data	: std_logic_vector(7 downto 0);

-- Single Port RAM
signal sig_sram_address	    : std_logic_vector(RAM_ADDRESS_WIDTH-1 downto 0) := (others => '0');
signal sig_sram_data_out	: std_logic_vector(RAM_DATA_WIDTH-1 downto 0);

-- Dual Port RAM (para video)
signal sig_vram_addr_rd	: std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
signal sig_vram_data_rd	: std_logic_vector(DPRAM_DATA_BITS_WIDTH-1 downto 0);

-- Maquina de Estados
type state_t is (state_init, state_waiting_for_uart, state_reading_from_uart,
state_write_sram, state_uart_end_data_reception, state_idle, state_read_from_sram,
state_clean_vram, state_clean_sram, state_process_coords, state_print_coords,
state_reset_device, state_clean_vram_on_first_boot, state_read_from_sram_prev);
signal state_current, state_next : state_t := state_init;
signal sig_sram_address_current, sig_sram_address_next: natural := 0;
signal sig_sram_rw_current, sig_sram_rw_next: std_logic_vector(0 downto 0) := "0";
signal sig_sram_data_in_current, sig_sram_data_in_next: std_logic_vector(RAM_DATA_WIDTH-1 downto 0) := (others => '0');
signal sig_uart_bytes_received_current, sig_uart_bytes_received_next: natural := 0;
signal sig_vram_addr_wr_current, sig_vram_addr_wr_next : std_logic_vector(DPRAM_ADDR_BITS-1 downto 0) := (others => '0');
signal sig_vram_ena_wr_current, sig_vram_ena_wr_next: std_logic := '0';
signal sig_vram_data_wr_current, sig_vram_data_wr_next: std_logic_vector(DPRAM_DATA_BITS_WIDTH-1 downto 0) := "0";
signal sig_vram_addr_wr_pointer_current, sig_vram_addr_wr_pointer_next : integer range 0 to 2**DPRAM_ADDR_BITS-1;
signal cycles_current, cycles_next: natural := CYCLES_TO_WAIT;

-- Aquitectura

begin
-- Actualización de registros
process(clk_tl, rst_tl) -- Agregar RESET     
    begin
    if(rst_tl='0') then --rst_tl pin got a pullup
        state_current <= state_reset_device;
    elsif (clk_tl'event and clk_tl='1') then
        state_current <= state_next;
        sig_sram_address_current <= sig_sram_address_next;
        sig_sram_rw_current <= sig_sram_rw_next;
        sig_sram_data_in_current <= sig_sram_data_in_next;
        cycles_current <= cycles_next;
        sig_uart_bytes_received_current <= sig_uart_bytes_received_next;
        x_coord_current <= x_coord_next;
        y_coord_current <= y_coord_next;
        z_coord_current <= z_coord_next;
        xyz_selector_current <= xyz_selector_next;
        sig_vram_addr_wr_current <= sig_vram_addr_wr_next;
        sig_vram_ena_wr_current <= sig_vram_ena_wr_next;
        sig_vram_data_wr_current <= sig_vram_data_wr_next;
        sig_vram_addr_wr_pointer_current <= sig_vram_addr_wr_pointer_next;
    end if;
end process;

-- Logica del estado siguiente
process(sig_uart_readed_data, sig_sram_address_current, state_current, sig_sram_rw_current, xyz_selector_current,
sig_sram_data_in_current, sig_uart_rx_ready, sig_sram_data_out, sig_sram_address_current, cycles_current, sig_uart_bytes_received_current,
x_coord_current, y_coord_current, z_coord_current, sig_vram_addr_wr_current, sig_vram_ena_wr_current, sig_vram_data_wr_current,
sig_vram_addr_wr_pointer_current, cycles_current, X_coord_rotated_unsigned, Y_coord_rotated_unsigned, Z_coord_rotated_unsigned)
begin
    -- Valores por defecto
    cycles_next <= cycles_current;
    sig_sram_rw_next <= sig_sram_rw_current;
    sig_sram_data_in_next <= sig_sram_data_in_current;
    sig_sram_address_next <= sig_sram_address_current;
    sig_uart_bytes_received_next <= sig_uart_bytes_received_current;
    xyz_selector_next <= xyz_selector_current;
    x_coord_next <= x_coord_current;
    y_coord_next <= y_coord_current;
    z_coord_next <= z_coord_current;
    cycles_next <= cycles_current;
    sig_vram_addr_wr_next <= sig_vram_addr_wr_current;
    sig_vram_ena_wr_next <= sig_vram_ena_wr_current;
    sig_vram_data_wr_next <= sig_vram_data_wr_current;
    sig_vram_addr_wr_pointer_next <= sig_vram_addr_wr_pointer_current;
    sig_led_aux <= "0000";
    case state_current is
        when state_init =>
            sig_uart_bytes_received_next <= 0;
            sig_led_aux <= "0000";
            sig_sram_address_next <= 0;
            if cycles_current = 0 then
                state_next <= state_waiting_for_uart;
            else
                cycles_next <= cycles_current - 1;
                state_next <= state_init;
            end if;
        when state_waiting_for_uart =>
            sig_led_aux <= "0001";
            if sig_uart_rx_ready = '1' then
                state_next <= state_reading_from_uart;
            elsif sig_uart_bytes_received_current = UART_BYTES_TO_RECEIVE then
                state_next <= state_uart_end_data_reception;
            else
            state_next <= state_waiting_for_uart;
            end if;
        when state_reading_from_uart =>
            sig_sram_data_in_next <= sig_uart_readed_data;
            state_next <= state_write_sram;
            sig_uart_bytes_received_next <= sig_uart_bytes_received_current + 1;
        when state_write_sram =>
            sig_sram_address_next <= sig_sram_address_current + 1;
            sig_sram_rw_next <= "1";  -- Necesitamos escribir
            state_next <= state_waiting_for_uart;
        when state_uart_end_data_reception =>
            sig_sram_rw_next <= "0"; 	-- Vamos a necesitar leer
            sig_sram_address_next <= 0;	-- La prox address de RAM que nos interesa es 0
            sig_vram_ena_wr_next <= '0';
            sig_vram_data_wr_next <= "0";
            sig_vram_addr_wr_next <= (others=> '0');
            state_next <= state_read_from_sram;
        when state_idle =>
            sig_led_aux <= "0010";
            state_next <= state_process_coords;
        when state_read_from_sram_prev => --Le da el ciclo de clock que la RAM necesita
            state_next <= state_read_from_sram;
        when state_read_from_sram =>
            sig_led_aux <= "0011";
            if sig_sram_address_current > UART_BYTES_TO_RECEIVE then
                state_next <= state_clean_vram;
                xyz_selector_next <= 0;
                sig_sram_address_next <= 0;
            else
                sig_vram_ena_wr_next <= '0';
                case xyz_selector_current is
                    when 0 =>
                        sig_sram_address_next <= sig_sram_address_current + 1;
                        x_coord_next <= sig_sram_data_out;
                        xyz_selector_next <= xyz_selector_current + 1;
                        state_next <= state_read_from_sram_prev;
                    when 1 =>
                        sig_sram_address_next <= sig_sram_address_current + 1;
                        y_coord_next <= sig_sram_data_out;
                        xyz_selector_next <= xyz_selector_current + 1;
                        state_next <= state_read_from_sram_prev;
                    when 2 =>
                        sig_sram_address_next <= sig_sram_address_current + 1;
                        z_coord_next <= sig_sram_data_out;
                        xyz_selector_next <= 0;
                        cycles_next <= 0;
                        state_next <= state_process_coords;
                    when others =>
                        state_next <= state_idle;
                end case;
            end if;
        when state_process_coords =>
            if cycles_current < CYCLES_TO_WAIT_TO_CORDIC_TO_FINISH then
                cycles_next <= cycles_current + 1;
                sig_vram_ena_wr_next <= '0';
                state_next <= state_process_coords;
            else
                state_next <= state_print_coords;
            end if;
        when state_print_coords =>
            sig_vram_ena_wr_next <= '1';
            sig_vram_data_wr_next <= "1";
            sig_vram_addr_wr_next <= z_coord_rotated_unsigned(7 downto 0) & y_coord_rotated_unsigned(7 downto 0);
            state_next <= state_read_from_sram_prev;
        when state_reset_device =>
            sig_sram_address_next <= 0;
            state_next <= state_clean_sram;
        when state_clean_sram =>
            sig_led_aux <= "1000";
            if sig_sram_address_current < ((2**RAM_ADDRESS_WIDTH)-1) then
                sig_sram_address_next <= sig_sram_address_current + 1;
                sig_sram_rw_next <= "1";
                sig_sram_data_in_next <= "00000000";
                sig_vram_ena_wr_next <= '0';
                state_next <= state_clean_sram;
            else
                sig_sram_rw_next <= "0";
                sig_sram_address_next <= 0;
                sig_sram_data_in_next <= "00000000";
                sig_vram_ena_wr_next <= '1';
                sig_vram_addr_wr_pointer_next <= 0;
                state_next <= state_clean_vram_on_first_boot;
            end if;
        when state_clean_vram_on_first_boot =>
            sig_led_aux <= "0100";
            if sig_vram_addr_wr_pointer_current < ((2**DPRAM_ADDR_BITS)-1) then
                sig_vram_addr_wr_pointer_next <= sig_vram_addr_wr_pointer_current + 1;
                sig_vram_ena_wr_next <= '1';
                sig_vram_data_wr_next <= "0";
                state_next <= state_clean_vram_on_first_boot;
            else
                sig_vram_addr_wr_pointer_next <= 0;
                sig_vram_ena_wr_next <= '0';
                sig_vram_data_wr_next <= "0";
                state_next <= state_init;
            end if;
            sig_vram_addr_wr_next <= std_logic_vector(to_unsigned(sig_vram_addr_wr_pointer_current, DPRAM_ADDR_BITS));
        when state_clean_vram =>
            sig_led_aux <= "0100";
            if sig_vram_addr_wr_pointer_current < ((2**DPRAM_ADDR_BITS)-1) then
                sig_vram_addr_wr_pointer_next <= sig_vram_addr_wr_pointer_current + 1;
                sig_vram_ena_wr_next <= '1';
                sig_vram_data_wr_next <= "0";
                state_next <= state_clean_vram;
            else
                sig_vram_addr_wr_pointer_next <= 0;
                sig_vram_ena_wr_next <= '0';
                sig_vram_data_wr_next <= "0";
                state_next <= state_read_from_sram_prev;
            end if;
            sig_vram_addr_wr_next <= std_logic_vector(to_unsigned(sig_vram_addr_wr_pointer_current, DPRAM_ADDR_BITS));
        when others =>
            state_next <= state_idle;
    end case;
end process;

-- Instanciamos componentes a utilizar
-- VGA	
vga_control : vga_ctrl
port map (
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

-- SINGLE PORT RAM
ram_internal : sram
port map (
    clka => clk_tl,
    wea => sig_sram_rw_current,
    addra => sig_sram_address,
    dina => sig_sram_data_in_current,
    douta => sig_sram_data_out,
    rsta => not rst_tl
);

-- UART
uart_load_data : uart
generic map (
    F 	=> 50000,
    min_baud => 1200,
    num_data_bits => 8
)
port map (
    Rx	=> rx_tl,
    Tx	=> tx_tl,
    Din => (others => '0'),
    StartTx => '0',
    TxBusy => open,
    Dout	=> sig_uart_readed_data,
    RxRdy	=> sig_uart_rx_ready,
    RxErr	=> open,
    Divisor	=> Divisor,
    clk	=> clk_tl,
    rst	=> not rst_tl
);

-- DUAL PORT RAM (VIDEO MEMORY)
dpram_vram : dpram
generic map(
    DPRAM_BITS_WIDTH => DPRAM_DATA_BITS_WIDTH,
    DPRAM_ADDR_BITS => DPRAM_ADDR_BITS
)
port map(
    rst => not rst_tl,
    clk => clk_tl,
    data_wr => sig_vram_data_wr_current,
    addr_wr => sig_vram_addr_wr_current,
    ena_wr  => sig_vram_ena_wr_current,
    data_rd => sig_vram_data_rd,
    addr_rd => sig_vram_addr_rd
);

-- VIDEO DRIVER 
video_driver_1 : video_driver
generic map(
    DPRAM_BITS_WIDTH => DPRAM_DATA_BITS_WIDTH,
    DPRAM_ADDR_BITS => DPRAM_ADDR_BITS
)
port map (
    rst => not rst_tl,
    clk => clk_tl,
    red_en_o => sig_red_enable,
    green_en_o => sig_green_enable,
    blue_en_o => sig_blue_enable,
    pixel_y => pixel_y,
    pixel_x => pixel_x,
    data_rd => sig_vram_data_rd,
    addr_rd => sig_vram_addr_rd
);

seven_segments : LED8
port map 
(
    -- Reset & Clock Signal 
    rst => not rst_tl,
    clk => clk_tl,
    -- LED8 PIN 
    led_out => led_out_tl, 
    digit_select => led_select_tl,
    show_number => sig_binary_to_bcd
);

input_processor_tl : input_processor
generic map (
    ANGLE_WIDTH           => ANGLE_WIDTH,
    ANGLE_STEP_INITIAL    => ANGLE_STEP_INITIAL
)
port map ( 
    clk => clk_tl,
    matrix_buttons_col => matrix_btn_col_tl,
    matrix_buttons_row => matrix_btn_row_tl,
    angle_x => angle_x_from_input_proc,
    angle_y => angle_y_from_input_proc,
    angle_z => angle_z_from_input_proc,
    angle_step => angle_step_tl,
    reset_button => rst_tl
);

pixel_x <= unsigned(sig_aux_pixel_x_i);
pixel_y <= unsigned(sig_aux_pixel_y_i);

x0 <=   signed(std_logic_vector(to_unsigned(0, CORDIC_OFFSET)) & X_coord_current(COORDS_WIDTH-1 downto 0)) when X_coord_current(COORDS_WIDTH-1) = '0' else
        signed(std_logic_vector(to_unsigned((2**CORDIC_OFFSET)-1, CORDIC_OFFSET)) & X_coord_current(COORDS_WIDTH-1 downto 0)) when X_coord_current(COORDS_WIDTH-1) = '1';
y0 <=   signed(std_logic_vector(to_unsigned(0, CORDIC_OFFSET)) & Y_coord_current(COORDS_WIDTH-1 downto 0)) when Y_coord_current(COORDS_WIDTH-1) = '0' else
        signed(std_logic_vector(to_unsigned((2**CORDIC_OFFSET)-1, CORDIC_OFFSET)) & Y_coord_current(COORDS_WIDTH-1 downto 0)) when Y_coord_current(COORDS_WIDTH-1) = '1';
z0 <=   signed(std_logic_vector(to_unsigned(0, CORDIC_OFFSET)) & Z_coord_current(COORDS_WIDTH-1 downto 0)) when Z_coord_current(COORDS_WIDTH-1) = '0' else
        signed(std_logic_vector(to_unsigned((2**CORDIC_OFFSET)-1, CORDIC_OFFSET)) & Z_coord_current(COORDS_WIDTH-1 downto 0)) when Z_coord_current(COORDS_WIDTH-1) = '1';

X_coord_rotated_unsigned <= std_logic_vector(X_coord_rotated(COORDS_WIDTH-1 downto 0) + to_signed(-(2**(COORDS_WIDTH-1)), COORDS_WIDTH));
Y_coord_rotated_unsigned <= std_logic_vector(Y_coord_rotated(COORDS_WIDTH-1 downto 0) + to_signed(-(2**(COORDS_WIDTH-1)), COORDS_WIDTH));
Z_coord_rotated_unsigned <= std_logic_vector(Z_coord_rotated(COORDS_WIDTH-1 downto 0) + to_signed(-(2**(COORDS_WIDTH-1)), COORDS_WIDTH));

angle_x_tl <= -1*(signed(to_signed(360, angle_x_from_input_proc'length) - angle_x_from_input_proc)) when angle_x_from_input_proc > 180 else signed(angle_x_from_input_proc);
angle_y_tl <= -1*(signed(to_signed(360, angle_y_from_input_proc'length) - angle_y_from_input_proc)) when angle_y_from_input_proc > 180 else signed(angle_y_from_input_proc);
angle_z_tl <= -1*(signed(to_signed(360, angle_z_from_input_proc'length) - angle_z_from_input_proc)) when angle_z_from_input_proc > 180 else signed(angle_z_from_input_proc);

--angle_x_tl <= angle_x_from_input_proc;
--angle_y_tl <= angle_y_from_input_proc;
--angle_z_tl <= angle_z_from_input_proc;

cordic_rotator: rotator
generic map (
    COORDS_WIDTH=>CORDIC_WIDTH,
    ANGLES_INTEGER_WIDTH=>ANGLE_WIDTH,
    STAGES=>CORDIC_STAGES
)
port map(
    clk=>clk_tl,
    X0=>X0, Y0=>Y0, Z0=>Z0,
    angle_X=>angle_x_tl, angle_Y=>angle_y_tl, angle_Z=>angle_z_tl,
    X=>X_coord_rotated, Y=>Y_coord_rotated, Z=>Z_coord_rotated
);

sig_binary_to_bcd <= std_logic_vector(angle_x_tl(7 downto 0));
sig_sram_address <= std_logic_vector(to_unsigned(sig_sram_address_current, RAM_ADDRESS_WIDTH));

end top_level_arq;
