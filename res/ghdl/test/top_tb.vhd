library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture arch of top_tb is
    constant period : time := 20 ns;

    -- Reset and clk
    signal rst : std_logic;
    signal clk : std_logic := '0';

    -- Sim
    signal sim_stop : boolean := false;

    -- DUT
    component top is
    port (
        rst       : in  std_logic;
        clk       : in  std_logic;

        -- Dartboard
        scan_in   : in  std_logic_vector(7 downto 0);
        scan_out  : out std_logic_vector(7 downto 0)
    );
    end component;

    signal scan_in  : std_logic_vector(7 downto 0);
    signal scan_out : std_logic_vector(7 downto 0);

begin

    -- Reset
    process
    begin
        rst <= '0';
        wait for 5*period/2;
        rst <= '1';
        wait;
    end process;

    -- Clk
    process
    begin
        if sim_stop = false then
            clk <= '1';
            wait for period/2;
            clk <= '0';
            wait for period/2;
        else
            wait;
        end if;
    end process;

    -- DUT signals
    process
    begin
        scan_in <= (others => '0');
        wait for 50*1000*period;
        scan_in <= (4 => '1', others => '0');
        wait for 50*1000*period;
        scan_in <= (others => '0');
        wait for 50*1000*128*period;

        sim_stop <= true;
        wait;
    end process;

    -- DUT: Top-level CAN - MAC controller
    top_0: top
    port map (
        rst => rst,
        clk => clk,

        -- Dartboard
        scan_in  => scan_in,
        scan_out => scan_out
    );

end architecture;
