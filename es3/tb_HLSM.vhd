library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- L'entità del testbench è vuota
entity tb_HLSM is
end entity tb_HLSM;

architecture beh of tb_HLSM is
    
    -- 1. Dichiarazione del componente da testare (DUT)
    component HLSM is
        port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            Go        : in  std_logic;
            N_address : out std_logic_vector(9 downto 0);
            data_in   : in  std_logic_vector(15 downto 0);
            Average   : out std_logic_vector(15 downto 0);
            Finish    : out std_logic
        );
    end component HLSM;

    -- Costanti
    constant CLK_PERIOD      : time    := 10 ns;
    constant EXPECTED_AVG_VAL: integer := 512;

    -- 2. Segnali per connettere il DUT
    signal tb_clk       : std_logic := '0';
    signal tb_rst       : std_logic := '1'; -- Inizializza il reset come attivo
    signal tb_Go        : std_logic := '0';
    signal tb_N_address : std_logic_vector(9 downto 0); -- Questo è un output, non serve inizializzarlo
    signal tb_data_in   : std_logic_vector(15 downto 0) := (others => '0'); -- Inizializza per sicurezza
    signal tb_Average   : std_logic_vector(15 downto 0);
    signal tb_Finish    : std_logic;
    -- 3. Modello della memoria RAM
    type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
    signal ram_memory : ram_type;

begin

    -- 4. Istanza del DUT
    uut: HLSM port map (
        clk       => tb_clk,
        rst       => tb_rst,
        Go        => tb_Go,
        N_address => tb_N_address,
        data_in   => tb_data_in,
        Average   => tb_Average,
        Finish    => tb_Finish
    );

    -- 5. Generatore di Clock
    clk_process: process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_process;

    -- 6. Processo di simulazione della RAM (con 1 ciclo di latenza in lettura)
    ram_process: process (tb_clk)
    begin
        if rising_edge(tb_clk) then
            -- Legge l'indirizzo dal DUT e fornisce il dato corrispondente nel ciclo successivo
            tb_data_in <= ram_memory(to_integer(unsigned(tb_N_address)));
        end if;
    end process ram_process;
    
    -- 7. Processo che genera gli stimoli e verifica i risultati
    stim_proc: process
    begin
        report "Inizio del testbench per HLSM." severity note;
        

        -- Reset pulse
        wait for 50 ns;
        tb_rst <= '0';
        wait for 20 ns;

                -- Inizializzazione della RAM
        report "Inizializzazione della RAM..." severity note;
        for i in 0 to 1023 loop
            ram_memory(i) <= std_logic_vector(to_unsigned(i + 1, 16));
        end loop;
        
        -- Avvio del calcolo con un impulso su 'Go'
        report "Avvio del calcolo con il segnale Go." severity note;
        tb_Go <= '1';
        wait for CLK_PERIOD;
        tb_Go <= '0';
        

        wait until tb_Finish = '1';
        
        -- Attesa di un ulteriore ciclo per la stabilità dell'output
        wait for CLK_PERIOD;
        
        -- Print result => should be 511
        report "Average calculated: " & integer'image(to_integer(unsigned(tb_Average)));
        wait;
        
    end process stim_proc;

end architecture beh;