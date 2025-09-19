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

architecture beh of HLSM is
    type state_type is (IDLE, S1, S2, S3, S4, S5);
    signal c_state, n_state : state_type;
    signal acc, acc_n : unsigned (24 downto 0);
    signal i, i_n : unsigned(9 downto 0);
    signal avg, avg_n : unsigned(15 downto 0);

    begin
        p1: process (clk, rst) begin
            if rising_edge(clk) then
                if rst = '1' then
                    c_state <= IDLE;
                    acc <= (others => '0');
                    avg <= (others => '0');
                    i <= (others => '0');
                else 
                    c_state <= n_state;
                    acc <= acc_n;
                    avg <= avg_n;
                    i <= i_n;
                end if;
            end if;
        end process p1;

        comb_p : process (c_state, Go, acc, i, avg, data_in)
        begin
            acc_n <= acc;
            i_n <= i;
            Finish <= '0';
            avg_n <= avg;
            N_address <= std_logic_vector(i); -- L'indirizzo segue il contatore di default
            Average   <= std_logic_vector(avg);
            case c_state is
                when IDLE =>
                    i_n <= (others => '0');
                    acc_n <= (others => '0');
                    avg_n <= (others => '0');
                    if Go = '1' then
                        n_state <= S1;
                    else 
                        n_state <= IDLE;
                    end if;
                when S1 => -- init state
                    acc_n <= (others => '0');
                    i_n <= (others => '0');
                    n_state <= S2;
                when S2 => -- read state
                    n_state <= S3;
                when S3 => -- compute state
                    acc_n <= acc + unsigned(data_in);
                    i_n <= i + 2;
                    if (i = 1022) then
                        n_state <= S4;
                    else
                        n_state <= S2;
                    end if;
                when S4 =>
                    avg_n <= acc / 512;
                    n_state <= S5;
                when S5 =>
                    Average <= std_logic_vector(resize(avg, 16));
                    Finish <= '1';
                    n_state <= IDLE;
                when others =>
                    n_state <= IDLE;
            end case;
        end process comb_p;
end architecture beh;

                    