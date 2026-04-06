LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY lights IS
    PORT(
			SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			CLOCK_50 : IN STD_LOGIC;
			LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
			DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
			DRAM_BA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
			DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			DRAM_DQM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		   MTRR_P, MTRR_N, MTRL_P, MTRL_N : OUT STD_LOGIC	
    );
END lights;

ARCHITECTURE structure OF lights IS

   SIGNAL L_INTERM, R_INTERM : STD_LOGIC_VECTOR(13 DOWNTO 0);
    
    component nios_system is
        port (
            clk_clk          : in    std_logic                     := 'X';             -- clk
            reset_reset_n    : in    std_logic                     := 'X';             -- reset_n
            switches_export  : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
            leds_export      : out   std_logic_vector(7 downto 0);                     -- export
            sdram_wire_addr  : out   std_logic_vector(12 downto 0);                    -- addr
            sdram_wire_ba    : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_wire_cas_n : out   std_logic;                                        -- cas_n
            sdram_wire_cke   : out   std_logic;                                        -- cke
            sdram_wire_cs_n  : out   std_logic;                                        -- cs_n
            sdram_wire_dq    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_wire_dqm   : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_wire_ras_n : out   std_logic;                                        -- ras_n
            sdram_wire_we_n  : out   std_logic;                                        -- we_n
            sdram_clk_clk    : out   std_logic;                                        -- clk
            m_right_export   : out   std_logic_vector(13 downto 0);                    -- export
            m_left_export    : out   std_logic_vector(13 downto 0)                     -- export
        );
    end component nios_system;
	 
	     COMPONENT PWM_generation 
    PORT (
        clk, reset_n : IN STD_LOGIC;
        s_writedataR, s_writedataL : IN STD_LOGIC_VECTOR(13 DOWNTO 0);        
        -- Le bit13 : bit de go(1)/stop(0). 
        -- Le bit12: bit de forward(0)/backward(1). 
        -- Les bits 11 à 0: vitesse = durée état haut
        dc_motor_p_R, dc_motor_n_R, dc_motor_p_L, dc_motor_n_L : OUT STD_LOGIC
    );
    END COMPONENT;

BEGIN
    -- Instanciation
    NiosII : nios_system
    PORT MAP(
        clk_clk         => CLOCK_50,
        reset_reset_n   => KEY(0),
		  sdram_clk_clk   => DRAM_CLK ,
        switches_export => SW,    
        leds_export     => LED, 
		  sdram_wire_addr  => dram_ADDR,
        sdram_wire_ba    => dram_BA,
        sdram_wire_cas_n => draM_CAS_N,
        sdram_wire_cke   => draM_CKE,
        sdram_wire_cs_n  => dram_CS_N,
        sdram_wire_dq    => draM_DQ,
        sdram_wire_dqm   => draM_DQM,
        sdram_wire_ras_n => dram_RAS_N,
        sdram_wire_we_n   => draM_WE_N,
		  m_left_export => L_INTERM, 
        m_right_export => R_INTERM
    );
	 
    PMW: PWM_generation
    PORT MAP (
        clk => CLOCK_50,
        reset_n => KEY(0),
        s_writedataL => L_INTERM,  
        s_writedataR => R_INTERM,  
        dc_motor_p_R => MTRR_P,
        dc_motor_n_R => MTRR_N,
        dc_motor_p_L => MTRL_P,
        dc_motor_n_L => MTRL_N
    ); 
END structure;