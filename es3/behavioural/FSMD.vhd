library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HLSM is
    port(
        clk     : in  std_logic;
        rst   : in  std_logic;
        Go   : in  std_logic;
        -- RAM interface
        N_address : out std_logic_vector(9 downto 0);
        data_in : in  std_logic_vector(15 downto 0);
        -- Output
        Average : out std_logic_vector (15 downto 0);
        Finish : out std_logic
        );
end entity HLSM;

architecture beh of FSMD is
    type state_type is (IDLE, S1, S2, S3, S4, S5);
    signal c_state, n_state : state_type;
    signal acc, acc_n : unsigned (24 downto 0); -- accumulator
    signal i, i_n : unsigned(9 downto 0); -- address counter
    signal avg, avg_n : unsigned(15 downto 0);
    -- Data path signals
    signal 
    begin
        DP1 : process(clk, rst) begin
            if rising_edge(clk) then
                if rst = '1' then
                    acc <= (others => '0');
                else 
                    acc <= acc_n;
                    i <= i_n;
                end if;
            end if;
        end process DP1;