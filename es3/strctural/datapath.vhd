library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        data_in     : in  std_logic_vector(15 downto 0);
        -- Control signals from controller
        ld_acc      : in  std_logic;
        ld_i        : in  std_logic;
        ld_avg      : in  std_logic;
        rst_acc     : in  std_logic;
        rst_i       : in  std_logic;
        rst_avg     : in  std_logic;
        finish_set  : in  std_logic;
        -- Status signals to controller
        ieq         : out std_logic;
        -- Outputs
        N_address   : out std_logic_vector(9 downto 0);
        Average     : out std_logic_vector(15 downto 0)
    );
end entity datapath;

architecture beh of datapath is
    signal acc, acc_n : unsigned (24 downto 0); -- accumulator
    signal i, i_n     : unsigned(9 downto 0);   -- address counter

begin
    -- Datapath registers
    DP1 : process(clk, rst) begin
        if rising_edge(clk) then
            if rst = '1' then
                acc <= (others => '0');
                i   <= (others => '0');
            else
                acc <= acc_n;
                i   <= i_n;
            end if;
        end if;
    end process DP1;

    -- Datapath combinational logic
    DP2 : process(ld_acc, ld_i, ld_avg, rst_acc, rst_i, rst_avg, finish_set, data_in, acc, i) begin
        acc_n <= acc;
        i_n   <= i;
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
        elsif ld_i = '1' then
            i_n <= i + 2;
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

end architecture beh;