library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sampler is
generic (
    FCLKMHZ    : integer := 50;
    PRESCALER  : integer := 16;
    RPRESCALER : integer := 6
);
port (
    rst      : in  std_logic;
    clk      : in  std_logic;

    -- Game
    score_num : out std_logic_vector(4 downto 0);
    score_mul : out std_logic_vector(2 downto 0);
    score_en  : out std_logic;

    -- Dartboard
    scan_in   : in  std_logic_vector(7 downto 0);
    scan_out  : out std_logic_vector(7 downto 0)
);
end entity;

architecture arch of sampler is
    type state_t is (idle, scanning, resting);
    type reg_t is record
        state     : state_t;
        presc     : unsigned(PRESCALER-1 downto 0);
        rpresc    : unsigned(RPRESCALER-1 downto 0);
        score_num : std_logic_vector(4 downto 0);
        score_mul : std_logic_vector(2 downto 0);
        score_en  : std_logic;
        scan_out  : std_logic_vector(7 downto 0);
    end record;
    signal rn, rr: reg_t;

    -- Scan-to-score mapping functions
    function to_score_num(scan_in: std_logic_vector) return std_logic_vector is
        variable score_num: std_logic_vector(4 downto 0);
    begin
        score_num := (others => '0');
        return score_num;
    end function;

    function to_score_mul(scan_in: std_logic_vector) return std_logic_vector is
        variable score_mul: std_logic_vector(2 downto 0);
    begin
        score_mul := (others => '0');
        return score_mul;
    end function;
begin

    reg: process (rst, clk)
    begin
        if rst = '0' then
            rr.state    <= idle;
            rr.score_en <= '0';
        elsif rising_edge(clk) then
            rr <= rn;
        end if;
    end process;

    dp: process (rr, scan_in)
    begin
        -- Default
        rn <= rr;
        rn.score_en <= '0';

        -- Outputs
        score_num <= rr.score_num;
        score_mul <= rr.score_mul;
        score_en  <= rr.score_en;
        scan_out  <= rr.scan_out;

        -- FSM
        case rr.state is
            when idle =>
                rn.state    <= scanning;
                rn.presc    <= (others => '0');
                rn.rpresc   <= (others => '0');
                rn.scan_out <= (0 => '1', others => '0');  -- Load starting output pattern

            when scanning =>
                rn.presc <= rr.presc + 1;

                if rr.presc = to_unsigned(2**(PRESCALER-1), rr.presc'length) then
                    -- Half of scan bit time => sample scan_in
                    if scan_in /= std_logic_vector(to_unsigned(0, scan_in'length)) then
                        -- Sample score if input is not 0
                        rn.score_num <= to_score_num(scan_in);
                        rn.score_mul <= to_score_mul(scan_in);
                        rn.score_en  <= '1';
                        rn.state     <= resting;
                    end if;
                elsif rr.presc = to_unsigned(2**PRESCALER-1, rr.presc'length) then
                    -- End of scan bit time => shift scan_out left
                    rn.scan_out <= rr.scan_out(rr.scan_out'left-1 downto 0) & rr.scan_out(rr.scan_out'left);
                end if;

            when resting =>
                rn.presc <= rr.presc + 1;

                -- Count every scan bit time
                if rr.presc = to_unsigned(2**PRESCALER-1, rr.presc'length) then
                    rn.rpresc <= rr.rpresc + 1;

                    -- Go back after resting
                    if rr.rpresc = to_unsigned(2**RPRESCALER-1, rr.rpresc'length) then
                        rn.state <= scanning;
                    end if;
                end if;

        end case;

    end process;


end architecture;
