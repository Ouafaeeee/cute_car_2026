library ieee;
use ieee.std_logic_1164.all;

entity testcapteurs is
    port (
        -- Horloge système et Reset (provenant de la carte DE0-Nano)
        clk          : in  std_logic; 
        reset_n      : in  std_logic;
        
        -- Interface SPI vers le composant LTC2308 physique
        ADC_CONVST   : out std_logic;
        ADC_SCK      : out std_logic;
        ADC_SDI      : out std_logic;
        ADC_SDO      : in  std_logic
    );
end testcapteurs;

architecture struct of testcapteurs is

    -- ==========================================
    -- Déclaration des signaux d'interconnexion internes
    -- ==========================================
    signal sig_data0      : std_logic_vector(7 downto 0);
    signal sig_data1      : std_logic_vector(7 downto 0);
    signal sig_data_ready : std_logic;
    
    signal sig_capture    : std_logic;
    signal sig_op_sel     : std_logic_vector(1 downto 0);
    signal sig_result     : std_logic_vector(8 downto 0);

    -- ==========================================
    -- Déclaration du composant Nios II (Généré par Qsys)
    -- ==========================================
    component nios is
        port (
            clk_clk                                 : in  std_logic                    := 'X';             -- clk
            
            -- Les ports de données sont maintenant de simples entrées (Input)
            pio_data0_0_external_connection_export  : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export (data1)
            pio_data0_external_connection_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export (data0)
            
            -- Autres ports (inchangés)
            pio_result_external_connection_export   : in  std_logic_vector(8 downto 0) := (others => 'X'); -- export
            pio_ready_external_connection_export    : in  std_logic                    := 'X';             -- export
            pio_op_sel_external_connection_export   : out std_logic_vector(1 downto 0);                    -- export
            pio_capture_external_connection_export  : out std_logic                                        -- export
        );
    end component nios;

    -- ==========================================
    -- Déclaration du composant Capteurs ADC (Fourni)
    -- ==========================================
    component capteurs_sol
        port (
            clk             : in  std_logic;
            reset_n         : in  std_logic;
            data_capture    : in  std_logic;
            data_readyr     : out std_logic;
            data0r          : out std_logic_vector(7 downto 0);
            data1r          : out std_logic_vector(7 downto 0);
            data2r          : out std_logic_vector(7 downto 0);
            data3r          : out std_logic_vector(7 downto 0);
            data4r          : out std_logic_vector(7 downto 0);
            data5r          : out std_logic_vector(7 downto 0);
            data6r          : out std_logic_vector(7 downto 0);
            ADC_CONVSTr     : out std_logic;
            ADC_SCK         : out std_logic;
            ADC_SDIr        : out std_logic;
            ADC_SDO         : in  std_logic
        );
    end component;

    -- ==========================================
    -- Déclaration du Calculateur Matériel (Celui que vous avez codé)
    -- ==========================================
    component calculateur
        port (
            clk      : in  std_logic;
            reset_n  : in  std_logic;
            op_sel   : in  std_logic_vector(1 downto 0);
            data_A   : in  std_logic_vector(7 downto 0);
            data_B   : in  std_logic_vector(7 downto 0);
            result   : out std_logic_vector(8 downto 0)
        );
    end component;

begin

    -- ==========================================
    -- Instanciation du processeur Nios II
    -- ==========================================
    u0 : component nios
        port map (
            clk_clk                                 => clk,            
            
            -- Câblage de data1 (pio_data0_0 configuré en Input seul)
            pio_data0_0_external_connection_export  => sig_data1,  
            
            -- Câblage de data0 (pio_data0 configuré en Input seul)
            pio_data0_external_connection_export    => sig_data0,  
            
            -- Câblage des résultats et status HW -> SW
            pio_result_external_connection_export   => sig_result,
            pio_ready_external_connection_export    => sig_data_ready,
            
            -- Câblage des commandes SW -> HW
            pio_op_sel_external_connection_export   => sig_op_sel,
            pio_capture_external_connection_export  => sig_capture
        );

    -- ==========================================
    -- Instanciation de l'ADC
    -- ==========================================
    u_adc : capteurs_sol
        port map (
            clk          => clk,
            reset_n      => reset_n,
            data_capture => sig_capture,    -- Impulsion envoyée par le code C
            data_readyr  => sig_data_ready, -- Drapeau lu par le code C
            data0r       => sig_data0,      -- Donnée brute lue par Nios et Calc
            data1r       => sig_data1,      -- Donnée brute lue par Nios et Calc
            data2r       => open,           -- (Les autres canaux ne sont pas utilisés)
            data3r       => open,
            data4r       => open,
            data5r       => open,
            data6r       => open,
            ADC_CONVSTr  => ADC_CONVST,     -- Câblé physiquement aux pins FPGA
            ADC_SCK      => ADC_SCK,
            ADC_SDIr     => ADC_SDI,
            ADC_SDO      => ADC_SDO
        );

    -- ==========================================
    -- Instanciation du Calculateur
    -- ==========================================
    u_calc : calculateur
        port map (
            clk      => clk,
            reset_n  => reset_n,
            op_sel   => sig_op_sel,         -- Mode de calcul choisi par le C
            data_A   => sig_data0,          -- Entrée A = Canal 0
            data_B   => sig_data1,          -- Entrée B = Canal 1
            result   => sig_result          -- Résultat 9 bits lu par le C
        );

end struct;