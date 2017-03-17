library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tp1 is
	port (
		clk_clk       : in    std_logic                     := '0';             --       clk.clk
		reset_reset_n : in    std_logic                     := '0';             --     reset.reset_n
		sdram_clk_clk : out   std_logic;                                        -- sdram_clk.clk
		dram_addr     : out   std_logic_vector(11 downto 0);                    --      dram.addr
		dram_ba       : out   std_logic_vector(1 downto 0);                     --          .ba
		dram_cas_n    : out   std_logic;                                        --          .cas_n
		dram_cke      : out   std_logic;                                        --          .cke
		dram_cs_n     : out   std_logic;                                        --          .cs_n
		dram_dq       : inout std_logic_vector(15 downto 0) := (others => '0'); --          .dq
		dram_dqm      : out   std_logic_vector(1 downto 0);                     --          .dqm
		dram_ras_n    : out   std_logic;                                        --          .ras_n
		dram_we_n     : out   std_logic;                                        --          .we_n
		key_export    : in    std_logic_vector(3 downto 0)  := (others => '0'); --       key.export
		sw_export     : in    std_logic_vector(9 downto 0)  := (others => '0'); --        sw.export
		ledg_export   : out   std_logic_vector(7 downto 0);                     --      ledg.export
		ledr_export   : out   std_logic_vector(9 downto 0);                     --      ledr.export
		hex_HEX0      : out   std_logic_vector(6 downto 0);                     --       hex.HEX0
		hex_HEX1      : out   std_logic_vector(6 downto 0);                     --          .HEX1
		hex_HEX2      : out   std_logic_vector(6 downto 0);                     --          .HEX2
		hex_HEX3      : out   std_logic_vector(6 downto 0)                      --          .HEX3
	);
end entity tp1;  



architecture DE1_Basic_Computer_rtl of tp1 is

  component TP1_montre is
        port (
            clk_clk       : in    std_logic                     := 'X';             -- clk
            reset_reset_n : in    std_logic                     := 'X';             -- reset_n
            sdram_clk_clk : out   std_logic;                                        -- clk
            dram_addr     : out   std_logic_vector(11 downto 0);                    -- addr
            dram_ba       : out   std_logic_vector(1 downto 0);                     -- ba
            dram_cas_n    : out   std_logic;                                        -- cas_n
            dram_cke      : out   std_logic;                                        -- cke
            dram_cs_n     : out   std_logic;                                        -- cs_n
            dram_dq       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            dram_dqm      : out   std_logic_vector(1 downto 0);                     -- dqm
            dram_ras_n    : out   std_logic;                                        -- ras_n
            dram_we_n     : out   std_logic;                                        -- we_n
            key_export    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
            sw_export     : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
            ledg_export   : out   std_logic_vector(7 downto 0);                     -- export
            ledr_export   : out   std_logic_vector(9 downto 0);                     -- export
            hex_HEX0      : out   std_logic_vector(6 downto 0);                     -- HEX0
            hex_HEX1      : out   std_logic_vector(6 downto 0);                     -- HEX1
            hex_HEX2      : out   std_logic_vector(6 downto 0);                     -- HEX2
            hex_HEX3      : out   std_logic_vector(6 downto 0)                      -- HEX3
        );
    end component TP1_montre;
	 
	 signal BA : std_logic_vector(1 downto 0);
	 signal DQM : std_logic_vector(1 downto 0);
	 
begin
	 
	 BA(0) <= DRAM_BA_0;
	 BA(1) <= DRAM_BA_1;

	 DQM(1) <= DRAM_UDQM;
	 DQM(0) <= DRAM_LDQM;

    u0 : component TP1_montre
        port map (
            clk_clk       => CLOCK_50,       --       clk.clk
            reset_reset_n => KEY(0), --     reset.reset_n
            sdram_clk_clk => DRAM_CLK, -- sdram_clk.clk
            dram_addr     => DRAM_ADDR,     --      dram.addr
            dram_ba       => BA,       --          .ba
            dram_cas_n    => DRAM_CAS_N,    --          .cas_n
            dram_cke      => DRAM_CKE,      --          .cke
            dram_cs_n     => DRAM_CS_N,     --          .cs_n
            dram_dq       => DRAM_DQ,       --          .dq
            dram_dqm      => DQM, -- CONNECTED_TO_dram_dqm,      --          .dqm
            dram_ras_n    => DRAM_RAS_N,    --          .ras_n
            dram_we_n     => DRAM_WE_N,     --          .we_n
            key_export    => KEY ,    --       key.export
            sw_export     => SW,     --        sw.export
            ledg_export   => LEDG,   --      ledg.export
            ledr_export   => LEDR,   --      ledr.export
            hex_HEX0      => HEX0,      --       hex.HEX0
            hex_HEX1      => HEX1,      --          .HEX1
            hex_HEX2      => HEX2,      --          .HEX2
            hex_HEX3      => HEX3       --          .HEX3
        );
end DE1_Basic_Computer_rtl;