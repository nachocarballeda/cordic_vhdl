library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity input_processor is
    generic (
        ANGLE_WIDTH           : integer := 8;
        ANGLE_STEP_INITIAL    : integer := 1
    );
    port ( 
           clk: in std_logic;
           matrix_buttons_col : in  std_logic_vector (3 downto 0);
           matrix_buttons_row : in  std_logic_vector (3 downto 0);
           angle_x : out  signed(ANGLE_WIDTH-1 downto 0);
           angle_y : out  signed(ANGLE_WIDTH-1 downto 0);
           angle_z : out  signed(ANGLE_WIDTH-1 downto 0);
           angle_step: out natural;
           reset_button: out std_logic
           );
end input_processor;

architecture Behavioral of input_processor is

component button_matrix is
    port (
        clk : in std_logic;
        matrix_col : in  std_logic_vector (3 downto 0);
        matrix_row : in  std_logic_vector (3 downto 0);
        reset_button: out std_logic;
        up_x : out  std_logic;
        down_x : out std_logic;
        up_y : out  std_logic;
        down_y : out std_logic;
        up_z : out  std_logic;
        down_z : out std_logic;
        angle_step_up : out  std_logic;
        angle_step_down : out std_logic
    );
end component;

component debounce is
    port (
        clk, reset: in std_logic;
        sw: in std_logic;
        db_level, db_tick: out std_logic
    );
end component;

-- Aux signals for Angles
signal angle_step_sig: natural := ANGLE_STEP_INITIAL;
signal angle_x_sig: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_y_sig: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');
signal angle_z_sig: signed(ANGLE_WIDTH-1 downto 0) := (others => '0');

-- Buttons
signal rst: std_logic :=  '1';
signal up_x_sig: std_logic := '0';
signal down_x_sig: std_logic := '0';
signal up_y_sig: std_logic := '0';
signal down_y_sig: std_logic := '0';
signal up_z_sig: std_logic := '0';
signal down_z_sig: std_logic := '0';
signal angle_step_up_sig: std_logic := '0';
signal angle_step_down_sig: std_logic := '0';

-- Debounced Buttons
signal up_x_debounced: std_logic := '0';
signal down_x_debounced: std_logic := '0';
signal up_y_debounced: std_logic := '0';
signal down_y_debounced: std_logic := '0';
signal up_z_debounced: std_logic := '0';
signal down_z_debounced: std_logic := '0';
signal angle_step_up_debounced: std_logic := '0';
signal angle_step_down_debounced: std_logic := '0';


begin

process(rst, clk,
        up_x_debounced, down_x_debounced,
        up_y_debounced, down_y_debounced,
        up_z_debounced, down_z_debounced,
        angle_step_up_debounced, angle_step_down_debounced)
    begin
        if(rst = '0') then
            angle_x_sig <= (others=>'0');
            angle_y_sig <= (others=>'0');
            angle_z_sig <= (others=>'0');
            angle_step_sig <= ANGLE_STEP_INITIAL;
        elsif(clk'event and clk='1') then 
            if up_x_debounced = '1' then
                angle_x_sig <= angle_x_sig + angle_step_sig;
            end if;
            if down_x_debounced = '1' then
                angle_x_sig <= angle_x_sig - angle_step_sig;
            end if;
            if up_y_debounced = '1' then
                angle_y_sig <= angle_y_sig + angle_step_sig;
            end if;
            if down_y_debounced = '1' then
                angle_y_sig <= angle_y_sig - angle_step_sig;
            end if;
            if up_z_debounced = '1' then
                angle_z_sig <= angle_z_sig + angle_step_sig;
            end if;
            if down_z_debounced = '1' then
                angle_z_sig <= angle_z_sig - angle_step_sig;
            end if;
            if angle_step_up_debounced = '1' then
                angle_step_sig <= angle_step_sig + 1;
            end if;
            if angle_step_down_debounced = '1' then
                if angle_step_sig > 0 then
                    angle_step_sig <= angle_step_sig - 1;
                end if;
            end if;
    end if;
end process;

-- instantiante button_matrix
keyboard: button_matrix
port map(
    clk => clk,
    matrix_col => matrix_buttons_col,
    matrix_row => matrix_buttons_row,
    reset_button => rst,
    up_x => up_x_sig,
    down_x => down_x_sig,
    up_y => up_y_sig,
    down_y => down_y_sig,
    up_z => up_z_sig,
    down_z => down_z_sig,
    angle_step_up => angle_step_up_sig,
    angle_step_down => angle_step_down_sig
);

-- instantiate debouncers
debounce_unit_x_up: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not up_x_sig,
    db_level=>open, db_tick=>up_x_debounced
);
debounce_unit_x_down: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not down_x_sig,
    db_level=>open, db_tick=>down_x_debounced
);
debounce_unit_y_up: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not up_y_sig,
    db_level=>open, db_tick=>up_y_debounced
);
debounce_unit_y_down: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not down_y_sig,
    db_level=>open, db_tick=>down_y_debounced
);
debounce_unit_z_up: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not up_z_sig,
    db_level=>open, db_tick=>up_z_debounced
);
debounce_unit_z_down: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not down_z_sig,
    db_level=>open, db_tick=>down_z_debounced
);
debounce_unit_step_angle_up: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not angle_step_up_sig,
    db_level=>open, db_tick=>angle_step_up_debounced
);
debounce_unit_step_angle_down: debounce
port map(
    clk=>clk, reset=>not rst, sw=>not angle_step_down_sig,
    db_level=>open, db_tick=>angle_step_down_debounced
);

reset_button <= rst;
angle_x <= angle_x_sig;
angle_y <= angle_y_sig;
angle_z <= angle_z_sig;
angle_step <= angle_step_sig;

end Behavioral;

