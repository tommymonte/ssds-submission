library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMD is
    port(
        clk     : in  std_logic;
        rst   : in  std_logic;
        Go   : in  std_logic;
        -- RAM interface
        N_address : out std_logic_vector(9 downto 0);
        data_in : in  std_logic_vector(15 downto 0);
        WE : out std_logic;
        -- Output
        Average : out std_logic_vector (15 downto 0);
        Finish : out std_logic
        );
end entity FSMD;

architecture beh of FSMD is
    type state_type is (IDLE, S1, S2, S3, S4, S5);
    signal c_state, n_state : state_type;
    signal acc, acc_n : unsigned (24 downto 0); -- accumulator
    signal i, i_n : unsigned(9 downto 0); -- address counter
    
    -- Control signals
    signal ld_acc, ld_i, ld_avg : std_logic;
    signal rst_acc, rst_i, rst_avg : std_logic;
    signal ieq : std_logic; -- i == 1022
    signal finish_set : std_logic;
    signal rd_en : std_logic := '1';

    begin
        WE <= '0'; -- No write operation to RAM, only read
        DP1 : process(clk, rst) begin
            if rising_edge(clk) then
                if rst = '1' then
                    acc <= (others => '0');
                    i <= (others => '0');
                else 
                    acc <= acc_n;
                    i <= i_n;
                end if;
            end if;
        end process DP1;

        DP2 : process(ld_acc, ld_i, data_in, acc, i, rst_acc, rst_i, rst_avg, finish_set) begin
            acc_n <= acc;
            i_n <= i;
            N_address <= std_logic_vector(i);

            if rst_acc = '1' then
                acc_n <= (others => '0');
            elsif ld_acc = '1' then
                acc_n <= acc + unsigned(data_in);
            elsif ld_avg = '1' then
                acc_n <= acc / 512; 
            end if;

            if rst_i = '1' then
                i_n <= (others => '0');
            else 
                if ld_i = '1' then
                    i_n <= i + 2;
                end if;
            end if;

            if i = 1022 then
                ieq <= '1';
            else
                ieq <= '0';
            end if;

            if finish_set = '1' then
                Average <= std_logic_vector(resize(acc, 16));
            else
                Average <= (others => '0');
            end if;

        end process DP2;

        -- State register
        SP : process(clk, rst) begin
            if rising_edge(clk) then
                if rst = '1' then
                    c_state <= IDLE;
                else
                    c_state <= n_state;
                end if;
            end if;
        end process SP;

        NSL : process(c_state, Go, ieq) begin

            -- Default values for control signals
            rst_acc <= '0';
            rst_i <= '0';
            rst_avg <= '0';
            ld_acc <= '0';
            ld_i <= '0';
            ld_avg <= '0';
            Finish <= '0';

            case(c_state) is
                when IDLE =>
                    if Go = '1' then
                        n_state <= S1;
                    else
                        n_state <= IDLE;
                    end if;
                when S1 =>
                    rst_acc <= '1';
                    rst_i <= '1';
                    n_state <= S2;
                when S2 =>
                    n_state <= S3;
                when S3 =>
                    ld_acc <= '1';
                    ld_i <= '1';
                    if ieq = '1' then
                        n_state <= S4;
                    else
                        n_state <= S2;
                    end if;
                when S4 =>
                    ld_avg <= '1';
                    n_state <= S5;
                when S5 =>
                    n_state <= IDLE;
                    Finish <= '1';
                    finish_set <= '1';
                when others =>
                    n_state <= IDLE;
            end case;
        end process NSL;

end architecture beh;
