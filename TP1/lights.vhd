LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY lights IS
    PORT(
        CLOCK_50 : IN  STD_LOGIC;
        KEY      : IN  STD_LOGIC_VECTOR(3 downto 0); -- Corrigé de 70 à 3 (standard DE-series)
        SW       : IN  STD_LOGIC_VECTOR(7 downto 0);
        LEDG     : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END lights;

ARCHITECTURE lights_rtl OF lights IS
    -- Déclaration du composant (sans le mot-clé SIGNAL)
    COMPONENT nios_system
        PORT(                         
            clk_clk         : in  std_logic;                  
            reset_reset_n   : in  std_logic;                  
            switches_export : in  std_logic_vector(7 downto 0);
            leds_export     : out std_logic_vector(7 downto 0)           
        );
    END COMPONENT;

BEGIN
    -- Instanciation
    NiosII : nios_system
    PORT MAP(
        clk_clk         => CLOCK_50,
        reset_reset_n   => KEY(0),
        switches_export => SW,    -- Simplifié (SW fait déjà 8 bits)
        leds_export     => LEDG   -- CORRIGÉ : On relie à la sortie LEDG
    );
END lights_rtl;