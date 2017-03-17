
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TP1_montre_top is

-------------------------------------------------------------------------------
--                             Port Declarations                             --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50             : in std_logic;
	CLOCK_27             : in std_logic;
	KEY                  : in std_logic_vector (3 downto 0);
	SW                   : in std_logic_vector (9 downto 0);

	--  Communication
	UART_RXD             : in std_logic;

	-- Bidirectionals
	GPIO_0               : inout std_logic_vector (35 downto 0);
	GPIO_1               : inout std_logic_vector (35 downto 0);

	-- Memory (SRAM)
	SRAM_DQ              : inout std_logic_vector (15 downto 0);
	
	-- Memory (SDRAM)
	DRAM_DQ				 : inout std_logic_vector (15 downto 0);

	-- Outputs
	--  Simple
	LEDG                 : out std_logic_vector (7 downto 0);
	LEDR                 : out std_logic_vector (9 downto 0);
	HEX0                 : out std_logic_vector (6 downto 0);
	HEX1                 : out std_logic_vector (6 downto 0);
	HEX2                 : out std_logic_vector (6 downto 0);
	HEX3                 : out std_logic_vector (6 downto 0);

	--  Memory (SRAM)
	SRAM_ADDR            : out std_logic_vector (17 downto 0);
	SRAM_CE_N            : out std_logic;
	SRAM_WE_N            : out std_logic;
	SRAM_OE_N            : out std_logic;
	SRAM_UB_N            : out std_logic;
	SRAM_LB_N            : out std_logic;

	--  Communication
	UART_TXD             : out std_logic;
	
	-- Memory (SDRAM)
	DRAM_ADDR			 : out std_logic_vector (11 downto 0);
	DRAM_BA_1			 : buffer std_logic;
	DRAM_BA_0			 : buffer std_logic;
	DRAM_CAS_N			 : out std_logic;
	DRAM_RAS_N			 : out std_logic;
	DRAM_CLK			 : out std_logic;
	DRAM_CKE			 : out std_logic;
	DRAM_CS_N			 : out std_logic;
	DRAM_WE_N			 : out std_logic;
	DRAM_UDQM			 : buffer std_logic;
	DRAM_LDQM			 : buffer std_logic
	);
end TP1_montre_top;


architecture TP1_montre_top_rtl of TP1_montre_top is

-------------------------------------------------------------------------------
--                           Subentity Declarations                          --
-------------------------------------------------------------------------------
	
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
-------------------------------------------------------------------------------
--                           Parameter Declarations                          --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--                 Internal Wires and Registers Declarations                 --
-------------------------------------------------------------------------------
-- Internal Wires
-- Used to connect the Nios 2 system clock to the non-shifted output of the PLL
signal			 system_clock : STD_LOGIC;

-- Used to concatenate some SDRAM control signals
signal			 BA : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal			 DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);

-- Internal Registers

-- State Machine Registers

begin

-------------------------------------------------------------------------------
--                         Finite State Machine(s)                           --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--                             Sequential Logic                              --
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
--                            Combinational Logic                            --
-------------------------------------------------------------------------------

DRAM_BA_1  <= BA(1);
DRAM_BA_0  <= BA(0);
DRAM_UDQM  <= DQM(1);
DRAM_LDQM  <= DQM(0);

GPIO_0( 0) <= 'Z';
GPIO_0( 2) <= 'Z';
GPIO_0(16) <= 'Z';
GPIO_0(18) <= 'Z';
GPIO_1( 0) <= 'Z';
GPIO_1( 2) <= 'Z';
GPIO_1(16) <= 'Z';
GPIO_1(18) <= 'Z';

-------------------------------------------------------------------------------
--                              Internal Modules                             --
-------------------------------------------------------------------------------

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



end TP1_montre_top_rtl;

