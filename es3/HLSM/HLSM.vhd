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
    signal acc, acc_n : unsigned (24 downto 0); -- accumulator
    signal i, i_n : unsigned(9 downto 0); -- address counter
    signal avg, avg_n : unsigned(15 downto 0);

    begin
        p1: process (clk, rst) begin
            if rising_edge(clk) then
                if rst = '1' then
                    c_state <= IDLE;
                    acc <= (others => '0');
                else 
                    c_state <= n_state;
                    acc <= acc_n;
                    i <= i_n;
                    avg <= avg_n;
                end if;
            end if;
        end process p1;

        comb_p : process (c_state, Go, acc, i, avg, data_in)
        begin
            acc_n <= acc;
            i_n <= i;
            Finish <= '0';
            N_address <= std_logic_vector(i); -- L'indirizzo segue il contatore di default
            Average  <= (others => '0'); -- Default output
            case c_state is
                when IDLE =>
                    Finish <= '0';
                    if Go = '1' then
                        n_state <= S1;
                    else 
                        n_state <= IDLE;
                    end if;
                when S1 => -- init state
                    acc_n <= to_unsigned(0, 25);
                    i_n <= to_unsigned(0, 10);
                    n_state <= S2;
                when S2 => -- read state
                    n_state <= S3;
                when S3 => -- compute state
                    i_n <= i + 2;
                    acc_n <= acc + unsigned(data_in);
                    if (i = 1022) then
                        n_state <= S4;
                    else
                        n_state <= S2;
                    end if;
                when S4 =>
                    -- acc_n <= shift_right(acc, 9); 
                    acc_n <= acc / 512; -- divide by 512
                    n_state <= S5;
                when S5 =>
                    Average <= std_logic_vector(resize(acc, 16));
                    Finish <= '1';
                    n_state <= IDLE;
                when others =>
                    n_state <= IDLE;
            end case;
        end process comb_p;
end architecture beh;

                    