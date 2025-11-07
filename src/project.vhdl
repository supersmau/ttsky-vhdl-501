library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tt_um_supersmau_501 is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_supersmau_501;

architecture behavioral of tt_um_supersmau_501 is
    component top is
    generic (
        FCLKMHZ   : integer
    );
    port (
        rst       : in  std_logic;
        clk       : in  std_logic;

        -- Dartboard
        scan_in   : in  std_logic_vector(7 downto 0);
        scan_out  : out std_logic_vector(7 downto 0)
    );
    end component;

    constant FCLKMHZ : integer := 50;
begin

    ---
    -- Ports
    uio_out <= "00000000";
    uio_oe  <= "00000000";

    ---
    -- Top-level module
    top_0: top
    generic map (
        FCLKMHZ => FCLKMHZ
    )
    port map (
        rst => rst_n,
        clk => clk,

        -- Dartboard
        scan_in  => ui_in,
        scan_out => uo_out
    );

end behavioral;
