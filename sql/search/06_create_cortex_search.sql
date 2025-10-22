-- ============================================================================
-- Microchip Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, application notes, and quality reports
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Step 1: Create table for support transcripts (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TRANSCRIPTS (
    transcript_id VARCHAR(30) PRIMARY KEY,
    ticket_id VARCHAR(30),
    customer_id VARCHAR(20),
    support_engineer_id VARCHAR(20),
    transcript_text VARCHAR(16777216) NOT NULL,
    interaction_type VARCHAR(50),
    interaction_date TIMESTAMP_NTZ NOT NULL,
    product_family VARCHAR(50),
    issue_category VARCHAR(50),
    resolution_provided BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ticket_id) REFERENCES SUPPORT_TICKETS(ticket_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY (support_engineer_id) REFERENCES SUPPORT_ENGINEERS(support_engineer_id)
);

-- ============================================================================
-- Step 2: Create table for application notes
-- ============================================================================
CREATE OR REPLACE TABLE APPLICATION_NOTES (
    appnote_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    product_family VARCHAR(50),
    application_category VARCHAR(50),
    document_number VARCHAR(50),
    revision VARCHAR(20),
    tags VARCHAR(500),
    author VARCHAR(100),
    publish_date DATE,
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    download_count NUMBER(10,0) DEFAULT 0,
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 3: Create table for quality investigation reports
-- ============================================================================
CREATE OR REPLACE TABLE QUALITY_INVESTIGATION_REPORTS (
    investigation_report_id VARCHAR(30) PRIMARY KEY,
    quality_issue_id VARCHAR(30),
    customer_id VARCHAR(20),
    product_id VARCHAR(30),
    report_text VARCHAR(16777216) NOT NULL,
    investigation_type VARCHAR(50),
    investigation_status VARCHAR(30),
    root_cause_summary VARCHAR(5000),
    corrective_actions VARCHAR(5000),
    report_date TIMESTAMP_NTZ NOT NULL,
    investigated_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (quality_issue_id) REFERENCES QUALITY_ISSUES(quality_issue_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG(product_id)
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE SUPPORT_TRANSCRIPTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE APPLICATION_NOTES SET CHANGE_TRACKING = TRUE;
ALTER TABLE QUALITY_INVESTIGATION_REPORTS SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample support transcripts
-- ============================================================================
INSERT INTO SUPPORT_TRANSCRIPTS
SELECT
    'TRANS' || LPAD(SEQ4(), 10, '0') AS transcript_id,
    st.ticket_id,
    st.customer_id,
    st.assigned_engineer_id AS support_engineer_id,
    CASE (ABS(RANDOM()) % 20)
        WHEN 0 THEN 'Engineer: Microchip Technical Support, this is Sarah. How can I help you today? Customer: Hi, I am trying to compile code for the PIC18F47Q10 but I am getting errors about undefined registers. Engineer: I can help with that. What compiler are you using? Customer: MPLAB XC8 version 2.30. Engineer: That is a known issue with that specific compiler version. The header files for the Q10 family were updated in XC8 2.32. You will need to update to version 2.32 or later. Customer: Will I need to change any of my code? Engineer: Most likely not. The register names remained the same, but the peripheral library was enhanced. I recommend upgrading and recompiling. Customer: Where do I download the latest XC8? Engineer: Go to microchip.com/xc8 and download the latest version. It is a free download. After installing, clean and rebuild your project. Customer: Perfect, downloading now. Thank you! Engineer: You are welcome! Let me know if you have any other issues after upgrading.'
        WHEN 1 THEN 'Customer: I need help with I2C communication on the SAM D21. The data transfer is failing. Engineer: Let me help you troubleshoot. Are you seeing any specific error codes or is the transfer just timing out? Customer: It times out. The start condition appears on my scope but then nothing happens. Engineer: Can you tell me what I2C clock speed you are using? Customer: 400kHz. Engineer: And what pull-up resistor values do you have on SDA and SCL? Customer: I think they are 10k ohm. Engineer: That is your issue! At 400kHz, 10k pull-ups are too weak. The bus capacitance is preventing proper rise times. Try 2.2k or 3.3k ohm resistors. Customer: I will replace them. Anything else I should check? Engineer: Yes, make sure your SERCOM clock is configured correctly. For 400kHz, you need GCLK running at least 8MHz. Customer: I will verify both. Thanks! Engineer: No problem! If the pull-ups do not fix it, check your SERCOM pad settings in the peripheral configuration.'
        WHEN 2 THEN 'Email Support Thread. Customer: We are getting hardfault exceptions on our SAM V71 application. It happens randomly during CAN message processing. Engineer: Hardfault exceptions usually indicate a memory access issue. Can you provide the stack trace or hardfault handler output? Customer: Here is the stack trace: [crash dump data]. Engineer: Looking at your stack trace, the crash is occurring in your CAN interrupt handler at address 0x0040382C. This looks like a NULL pointer dereference. Are you checking if your receive buffer pointer is valid before accessing it? Customer: We do check it, but maybe there is a race condition? Engineer: Very likely! CAN interrupts can preempt your main code. I recommend adding a mutex or disabling interrupts when accessing shared CAN buffers. Also, make sure your receive buffer is declared as volatile. Customer: We were not using volatile! That could definitely cause issues. Engineer: Yes, without volatile the compiler might optimize away critical checks. Add volatile to your buffer declaration and implement proper interrupt synchronization. Customer: Implementing now. Thank you! Engineer: You are welcome. Also check the application note AN02550 for CAN best practices on Cortex-M7.'
        WHEN 3 THEN 'Engineer: Microchip FPGA Support. Customer: I am having trouble with timing closure on my PolarFire design. The critical path is failing by 2.5ns. Engineer: I can help with that. What clock frequency are you targeting? Customer: 125MHz, so 8ns period. Engineer: And what is the critical path between? Customer: It is in my FIFO controller, between two flip-flop banks across different clock domains. Engineer: There is your problem! Crossing clock domains without proper synchronization creates timing violations. You need to add a synchronizer. Customer: I thought the tools handled that automatically? Engineer: The tools will warn you, but you need to explicitly add synchronizer flip-flops. Use a 2-stage or 3-stage synchronizer chain. Customer: How do I implement that? Engineer: Add 2-3 intermediate flip-flops in the destination clock domain. This gives the signal time to settle. Also, use timing constraints to define your clock domain crossings. Customer: Should I use async FIFOs instead? Engineer: Even better! PolarFire has built-in dual-clock FIFOs that handle all the clock domain crossing for you. Customer: I will redesign with those. Thanks! Engineer: Great choice. Check out UG0450 PolarFire FPGA Fabric User Guide section on clock domain crossing.'
        WHEN 4 THEN 'Chat support. Customer: My AVR128DA48 is not programming. MPLAB IPE says "Target device ID mismatch". Engineer: That usually means the programmer is not detecting the correct device. What programmer are you using? Customer: MPLAB PICkit 4. Engineer: And is this a custom board or an evaluation kit? Customer: Custom board. We just got the prototypes back from assembly. Engineer: Okay, first check that your ICSP connections are correct. VDD, GND, PGC, PGD, and MCLR all need to be connected. Customer: I verified the schematic. All pins are connected. Engineer: Is VDD present on the board? What voltage? Customer: Yes, 3.3V measured at the MCU VDD pin. Engineer: Try lowering the programming speed in IPE. Go to Settings > Program Speed and select Low Speed. Customer: Changing now... It worked! Device programmed successfully! Engineer: Great! The issue was likely signal integrity on your ICSP traces at the default high speed. You can try medium speed to see if that works too. Customer: Medium speed also works. What causes this? Engineer: Long ICSP traces, impedance mismatches, or noise can cause signal integrity issues at higher programming speeds. You might want to add series resistors (100-220 ohm) on PGC and PGD on your next board revision. Customer: I will add that to our design notes. Thank you!'
        WHEN 5 THEN 'Customer: I need help configuring the ADC on a dsPIC33CK. The readings seem noisy. Engineer: I can help you optimize ADC performance. What reference voltage are you using? Customer: Internal 3.3V reference. Engineer: Are you using averaging or oversampling? Customer: No, just single conversions. Engineer: That is the first thing to fix. Enable hardware averaging. Set ADCON2<SHRSAMC> to at least 64 samples for cleaner results. Customer: Will that slow down my conversion rate? Engineer: Yes, but you will get much better noise immunity. What is your required sample rate? Customer: About 1kHz. Engineer: Perfect! 64x averaging at 1kHz is easily achievable. Also make sure you are allowing adequate acquisition time. Set ADCON2<SHRADCS> to at least 10 for 3.3V operation. Customer: What about the analog reference? Should I use external? Engineer: If you need better than 10-bit effective resolution, yes. An external precision voltage reference will give you better stability. The TI REF3030 or ADR431 are good choices. Customer: I will implement the averaging first and see if that is sufficient. Engineer: Good plan! Also make sure your analog power supply is clean. Add 0.1uF and 10uF caps close to the AVdd pin. Customer: Already have those. I will update my firmware with averaging. Thanks!'
        WHEN 6 THEN 'Email chain. Customer: We are evaluating the SAMA5D27 for a new industrial controller. Can it handle dual Gigabit Ethernet? Engineer: The SAMA5D27 has one Gigabit Ethernet MAC. For dual Gigabit you would need to add an external Ethernet switch or use two separate MAC devices. Customer: What about the SAMA5D36? Engineer: The D36 has two 10/100 MACs but not Gigabit. For dual Gigabit in a single MPU, I recommend looking at our SAM9X60 or potentially using an external Gigabit switch with the D27. Customer: Can you recommend a suitable switch IC? Engineer: The Microchip KSZ9897 is a 5-port Gigabit switch that interfaces well with the SAMA5D27 via RGMII. You get 4 external Gigabit ports plus the connection to the MPU. Customer: Perfect! Does Microchip provide drivers for Linux? Engineer: Yes, the KSZ9897 is supported in mainline Linux kernel. The SAMA5D27 also has excellent Linux support through our Buildroot and Yocto BSPs. Customer: Great! Can you send me the relevant documentation? Engineer: Sending you: DS60001476 (SAMA5D27 datasheet), KSZ9897 datasheet, and application note AN3000 on Ethernet switch integration. Also check linux4sam.org for the BSP downloads. Customer: Thank you! This gives us what we need to proceed with the design.'
        WHEN 7 THEN 'Phone support. Engineer: Microchip Wireless Support, this is Mike. Customer: Hi, I am working with the RN4870 Bluetooth module and it is not advertising. Engineer: Let me help you troubleshoot. Have you configured the advertising parameters? Customer: I sent the SR command to start advertising but nothing happens. Engineer: Did you set up the device name and services first? Customer: I set the device name with SN command. What services do I need? Engineer: You need to configure at least one service or the Generic Access Profile. Try sending SS,C0 to enable the Device Information service. Customer: Let me try... sent SS,C0. Should I reboot the module? Engineer: Yes, send R,1 to reboot. After reboot, the settings take effect. Customer: Rebooted... I still do not see it advertising on my phone. Engineer: Can you check the status LEDs? Is the connection LED blinking? Customer: Yes, it is blinking red. Engineer: That indicates advertising mode. What phone are you using to scan? Customer: iPhone 12. Engineer: iPhones are selective about showing Bluetooth devices. Try using a dedicated BLE scanner app like LightBlue or nRF Connect. Customer: Installing LightBlue now... I can see it! It is advertising as RN4870-3C42. Engineer: Perfect! The phone built-in Bluetooth settings only show paired devices. For development, always use a proper BLE scanner app. Customer: That makes sense. Thanks for clearing that up! Engineer: No problem! Once you have bonded with the module, it will appear in the phone Bluetooth settings.'
        WHEN 8 THEN 'Customer: The ATWINC1500 WiFi module is not connecting to our WPA2-Enterprise network. Engineer: WPA2-Enterprise requires additional configuration. Are you using PEAP, TLS, or TTLS authentication? Customer: PEAP with MSCHAPv2. Engineer: You will need to configure the enterprise parameters before connecting. Use m2m_wifi_set_1x_option() to set the username and password. Customer: I am calling that function. Is there a specific order? Engineer: Yes: 1) Initialize the WiFi driver, 2) Set the SSID and auth type to M2M_WIFI_SEC_802_1X, 3) Set the enterprise credentials, 4) Call m2m_wifi_connect(). Customer: I was setting auth type to WPA_PSK! That is the issue. Engineer: Exactly! WPA2-Enterprise is a completely different auth type from WPA2-PSK. You cannot use pre-shared keys for enterprise networks. Customer: Do I need to set the CA certificate? Engineer: For PEAP it is optional but recommended for security. If your network uses a self-signed certificate, you must load it using m2m_wifi_download_cert(). Customer: Our IT uses a corporate CA. I will get the certificate from them. Engineer: Good idea! Also, make sure your firmware is 19.6.1 or later. Earlier versions had issues with some enterprise configurations. Customer: I am on 19.5.2. I will update and try again. Thanks! Engineer: You are welcome! Application note AN3120 covers enterprise WiFi in detail.'
        WHEN 9 THEN 'Email support. Customer: We need to implement USB device on PIC32MZ. Can you recommend a starting point? Engineer: Absolutely! The PIC32MZ has a full-speed USB device controller. Are you implementing a standard USB class or custom? Customer: We want to implement a CDC (virtual COM port). Engineer: Perfect! Harmony 3 includes a complete USB stack with CDC examples. Start with the cdc_serial_emulator demo project. Customer: We are not using Harmony. We want to write bare-metal code. Engineer: In that case, I recommend starting with the USB stack from our legacy framework. The USB device library is well-documented and has CDC examples. Customer: Where can I find that? Engineer: Download the "Microchip Libraries for Applications" (MLA) from microchip.com/mla. Look in the USB directory for apps/device/cdc_serial. Customer: Does it support multiple instances? We need two virtual COM ports. Engineer: Yes! The CDC example shows single-port implementation but you can extend it to multiple interfaces. You will need to modify the USB descriptors to define two CDC interfaces. Customer: That sounds complex. Is there documentation? Engineer: Yes, USB specification requires composite device descriptors. I will send you AN1164 "USB Device Composite Configuration" which walks through the descriptor setup. Customer: That would be very helpful. Thank you! Engineer: Sent! Also, make sure you allocate sufficient endpoint buffers for both CDC interfaces. You will need 4 endpoints total (2 IN, 2 OUT) plus control endpoint.'
        WHEN 10 THEN 'Chat. Customer: We are migrating from PIC18F to PIC18F-Q series. What are the main differences? Engineer: The Q series has significant architecture improvements! The biggest change is Core Independent Peripherals (CIPs). Customer: What are CIPs? Engineer: They are peripherals that operate without CPU intervention. For example, the CLCs (Configurable Logic Cells) can implement logic functions in hardware. Customer: Can you give an example use case? Engineer: Sure! Let say you want to generate a PWM with frequency modulation based on an ADC reading. On traditional PIC18F, you would read the ADC in firmware and update the PWM registers. With CIPs, you can route the ADC directly to the PWM using CLCs and NCOs, no code required. Customer: That sounds powerful! Is there a learning curve? Engineer: Yes, but Microchip has excellent tools. The CIP configuration is done in MCC (MPLAB Code Configurator) using a graphical interface. Customer: What other major differences should I know about? Engineer: New peripherals: UART with automatic baud detection, advanced timers, improved ADC with computation features, memory access partitioning, and enhanced low-power modes. Customer: Is the instruction set the same? Engineer: Yes, same core instruction set so your existing code will compile. You just get access to better peripherals. Customer: Great! That makes migration easier. Thank you! Engineer: You are welcome! Check out our migration guide TB3242 "Migrating to PIC18F Q-Series".'
        WHEN 11 THEN 'Engineer: FPGA Tools Support. Customer: Libero is giving me an error: "Design is not fully constrained". How do I fix this? Engineer: That means you are missing timing constraints. All clocks must have period constraints defined. Did you create a timing constraints file? Customer: I created a .sdc file but I may not have all the clocks. Engineer: Open your design and look for all clock sources - PLLs, external clocks, internally generated clocks. Each needs a create_clock or create_generated_clock constraint. Customer: I have one external 50MHz clock. Do I need constraints for the PLL outputs too? Engineer: Yes! Use create_generated_clock for PLL outputs. Libero can auto-derive them if you use the PLL configurator correctly. Customer: How do I auto-derive? Engineer: In the SDC file, add: derive_pll_clocks -create_base_clocks. This automatically generates constraints for all PLL clocks. Customer: Let me add that... Now I am getting warnings about false paths. Engineer: False paths are normal! For async signal crossings, add set_false_path constraints. But be careful - only mark true asynchronous paths as false. Customer: How do I identify them? Engineer: Look for signals that cross between unrelated clock domains where the data is synchronized properly. Common examples: reset signals, configuration registers, and dual-clock FIFO write/read sides. Customer: I will review my clock domain crossings. Thanks! Engineer: Good plan! Check out UG0478 "Libero Timing Constraints User Guide" for detailed examples.'
        WHEN 12 THEN 'Customer inquiry. Customer: What is the recommended way to enter low-power mode on the SAM D21? Engineer: The SAM D21 has three low-power modes: Idle, Standby, and Backup. Which mode you use depends on your wake-up requirements. Customer: We want to wake up on a GPIO pin change. Engineer: Standby mode is perfect for that! Configure the External Interrupt Controller (EIC) to detect the pin change, then enter standby using the PM (Power Manager). Customer: How much current does standby consume? Engineer: With no peripherals running, standby current is typically 6µA at 3V, 25°C. Customer: That is acceptable! What is the wake-up latency? Engineer: Wake-up from Standby takes about 6µs with the default clock configuration. You can optimize this by keeping certain clocks running. Customer: Can I keep the RTC running for timekeeping? Engineer: Absolutely! The RTC continues running in Standby mode and can wake the system with periodic alarms. Standby current increases to about 10µA with RTC active. Customer: Perfect! Can you point me to example code? Engineer: Yes! Harmony 3 has standby examples. Also see application note AN2520 "Low Power Application on SAM D21 MCU". Customer: Thank you! That gives me everything I need. Engineer: You are welcome! Remember to configure all unused pins as inputs with pull-ups disabled to minimize leakage current.'
        WHEN 13 THEN 'Email thread. Customer: Our production test is failing to program some PIC32MZ devices. About 5% fail with "Program verify failed". Engineer: Intermittent programming failures can have several causes. What programming voltage are you using? Customer: We are using 3.3V VDD. Engineer: Try reducing the programming clock speed. In MPLAB IPE, set the speed to Medium or Low. Customer: We are already at Low speed. Engineer: Okay, next check: Are the failing devices from the same manufacturing lot? Customer: Good question. Let me check... Yes! They are all from lot #2204A. Engineer: That points to a potential silicon issue. Can you provide me with the exact part number and date code from the failing devices? Customer: PIC32MZ2048EFH144-I/PH, date code 2204A158. Engineer: Thank you. I will check our quality database for any known issues with that lot. In the meantime, try increasing VDD to 3.4V during programming. Customer: Increasing voltage now... That worked! All devices programming successfully at 3.4V. Engineer: Good! The manufacturing process variation in that lot likely resulted in slightly higher programming voltage requirements. Program at 3.4V but your application can still run at 3.3V. Customer: Perfect solution. Should we be concerned about the devices in the field? Engineer: No, once programmed they will operate normally at 3.3V. This is purely a programming threshold variation. Customer: Great! Thank you for the quick resolution.'
        WHEN 14 THEN 'Phone call. Engineer: Analog design support. Customer: I am designing a high-precision temperature sensor using the MCP9808. How do I achieve ±0.25°C accuracy? Engineer: The MCP9808 has ±0.25°C typical accuracy but you need to follow layout best practices to achieve it. Is this a 2-wire I2C interface? Customer: Yes, standard I2C. Engineer: First, keep the I2C traces short and add series resistors (100-330Ω) to reduce ringing. Place the pull-up resistors close to the master device. Customer: What about the power supply? Engineer: Very important! Use a low-noise LDO for VDD. Add a 0.1µF ceramic cap and 1µF tantalum cap right at the MCP9808 VDD pin. Customer: Should the sensor be close to the measurement point? Engineer: Yes! For accurate ambient temp measurement, keep it away from heat-generating components. If measuring board temperature, place it centrally away from power regulators and processors. Customer: We are measuring ambient air temperature in an enclosure. Engineer: Perfect! Mount the MCP9808 near an air vent or opening. Avoid placing it near the processor or power supply. Also, minimize the copper pour under the sensor to reduce thermal mass. Customer: What I2C speed should I use? Engineer: 100kHz or 400kHz both work fine. Faster speeds do not affect accuracy. Just ensure your pull-ups are sized correctly for the bus capacitance. Customer: Great! This gives me good design guidelines. Thank you! Engineer: You are welcome! Also see AN1333 "Temperature Sensor Design Guide" for detailed layout examples.'
        WHEN 15 THEN 'Customer chat. Customer: We want to add bootloader capability to our PIC24FJ application. Where do we start? Engineer: Great! Microchip provides several bootloader examples. What communication interface will you use for updates - UART, USB, or Ethernet? Customer: UART, because our device is remote and we update via serial cable. Engineer: Perfect! Download the "16-bit Bootloader" package from our website. It includes a complete UART bootloader example for PIC24FJ. Customer: Does it support encrypted firmware updates? Engineer: The standard bootloader does not, but you can add encryption. The bootloader receives the data and you would decrypt it before writing to flash. Customer: How much flash does the bootloader occupy? Engineer: Typically 4-8KB depending on features. You place it in protected boot memory and your application starts at an offset address. Customer: Will we need to modify the linker script? Engineer: Yes! You will need to reserve the boot memory region and adjust the application start address. The bootloader package includes example linker scripts. Customer: What about preserving configuration bits? Engineer: Good question! The bootloader writes the configuration bits once at initial programming. During field updates, the bootloader protects the config bits from being overwritten. Customer: That makes sense. Is there a PC tool for uploading firmware? Engineer: Yes! The bootloader package includes a Windows GUI application and command-line tool. You can also write your own using the documented protocol. Customer: Excellent! Downloading the package now. Thank you! Engineer: You are welcome! Read the AN1388 bootloader application note for complete implementation details.'
        WHEN 16 THEN 'Customer: I am getting CAN bus off errors on my dsPIC33CK. What causes this? Engineer: CAN bus off occurs when the transmit error counter exceeds 255. This usually indicates electrical problems or incorrect bit timing. Customer: How do I check the error counters? Engineer: Read the C1TREC register. Bits 7:0 are receive errors, bits 15:8 are transmit errors. If TX errors keep increasing, you have bus contention or bad signaling. Customer: TX error is at 240 and climbing. Engineer: That confirms transmit issues. First check: Is your CAN transceiver termination correct? You need 120Ω at both ends of the bus. Customer: We have one 120Ω terminator. Do we need two? Engineer: Yes! CAN requires differential 120Ω termination at each end of the bus. Without proper termination you get signal reflections and errors. Customer: Adding second terminator now... Error counter stopped increasing! But it is not decreasing either. Engineer: The TX error counter only decrements when successful transmissions occur. Send some valid CAN messages and watch it decrease. Customer: Sending test messages... Counter is decreasing. It is working! Engineer: Excellent! The bus off state clears once the error counter drops below 128. Make sure both terminators are true 120Ω resistors, not something approximate. Customer: They are precision 1% 120Ω. We are back online. Thank you! Engineer: You are welcome! For long cables or high-speed CAN, also verify your bit timing settings match your actual baud rate.'
        WHEN 17 THEN 'Email support. Customer: Can the ATECC608 crypto chip be used for secure boot with SAM D21? Engineer: Absolutely! The ATECC608 is perfect for that. It can store signing keys and verify firmware signatures. Customer: How is it interfaced? Engineer: I2C interface. Connect to any SERCOM on the SAM D21 configured for I2C mode. Customer: Do you have example code? Engineer: Yes! Download CryptoAuthLib from our GitHub. It includes example code for secure boot verification. Customer: How does the secure boot flow work? Engineer: 1) SAM D21 reads application firmware from flash, 2) Computes SHA-256 hash, 3) Sends hash to ATECC608, 4) ATECC608 verifies signature using stored public key, 5) Returns pass/fail to SAM D21. Customer: Can the ATECC608 also store device certificates for TLS? Engineer: Yes! It has 16 key slots. You can use some for secure boot keys and others for TLS certificates and private keys. Customer: Perfect! What is the maximum signature verification time? Engineer: ECDSA P256 signature verification takes about 50ms. This is acceptable for boot-time verification. Customer: Definitely acceptable. Where do I store the firmware signature? Engineer: Typically appended to the end of your firmware image or in a dedicated flash location. Your bootloader reads the signature and sends it to ATECC608 for verification. Customer: This sounds very secure! Thank you for the detailed explanation. Engineer: You are welcome! Also check out AN2470 "Secure Boot with ATECC608 and SAM D21" for complete implementation.'
        WHEN 18 THEN 'Phone support. Engineer: Memory products support. Customer: We are using the SST26VF064B flash and having trouble with sector erases. Engineer: What symptoms are you seeing? Customer: The erase command completes but the data is not erased. Engineer: Are you checking the busy status before reading back the data? Customer: We send the erase command and wait 100ms. Engineer: The SST26 has variable erase times depending on sector size. 100ms might not be enough. You need to poll the status register. Customer: How do I poll the status? Engineer: Send the RDSR (Read Status Register) command and check bit 0 (BUSY). Wait until it clears to 0 before proceeding. Customer: What is the typical erase time? Engineer: 4KB sector erase: 50ms typical, 100ms max. 64KB block erase: 200ms typical, 500ms max. Chip erase: 50 seconds typical. Customer: So polling is mandatory? Engineer: For reliable operation, yes! Never use fixed delays for erase or program operations. Always poll the busy flag. Customer: We will change our code to poll. Any other tips? Engineer: Yes! Make sure you send WREN (Write Enable) before each erase or program operation. The write enable latch resets after every write operation. Customer: We do send WREN. Good to confirm that is required every time. Engineer: Exactly! One WREN per erase or program operation. Also, check the block protection bits in the status register - make sure they are not protecting the sectors you are trying to erase. Customer: I will verify that. Thank you for the detailed guidance! Engineer: You are welcome! See datasheet DS20005262 section 4 for complete command timing specifications.'
        WHEN 19 THEN 'Customer support ticket. Customer: Our PIC32 Ethernet application occasionally loses network connectivity. Unplugging and replugging the cable fixes it. Engineer: That sounds like an auto-negotiation issue. What PHY chip are you using? Customer: We are using the KSZ8091 PHY. Engineer: And what happens when connectivity is lost - do the link LEDs stay lit or go dark? Customer: The LEDs stay lit but no data transfers. Engineer: That indicates the physical link is up but the MAC is not communicating with the PHY. Can you read the PHY status registers when this occurs? Customer: How do I read the PHY registers? Engineer: Use MDIO commands. Read register 1 (Basic Status) and register 31 (PHY Control). Customer: I will add diagnostic code to read those. What should I look for? Engineer: Check bit 2 of register 1 (Link Status). If it is 0, the link is down even though LEDs say otherwise. Also check auto-negotiation complete bit. Customer: If auto-negotiation failed, how do I recover? Engineer: You can reset the PHY by toggling the reset pin or writing to control registers. Better solution: implement link status monitoring in your firmware and reset when link status changes. Customer: We will implement a link status monitor. Should we poll it? Engineer: Ideally use the interrupt output of the KSZ8091. Configure it to assert on link status change, then reset and re-negotiate when it triggers. Customer: Great suggestion! That will catch the problem immediately instead of waiting for the user to notice. Engineer: Exactly! Application note AN1120 "Ethernet Design Guide" covers PHY monitoring and recovery in detail. Customer: Perfect! I will implement interrupt-based monitoring. Thank you!'
    END AS transcript_text,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'CHAT')[UNIFORM(0, 2, RANDOM())] AS interaction_type,
    st.created_date AS interaction_date,
    pc.product_family,
    st.ticket_category AS issue_category,
    st.ticket_status = 'CLOSED' AS resolution_provided,
    st.created_date AS created_at
FROM RAW.SUPPORT_TICKETS st
LEFT JOIN RAW.PRODUCT_CATALOG pc ON st.product_id = pc.product_id
WHERE st.ticket_id IS NOT NULL
LIMIT 25000;

-- ============================================================================
-- Step 6: Generate sample application notes
-- ============================================================================
INSERT INTO APPLICATION_NOTES VALUES
('AN001', 'Getting Started with PIC18F Q-Series Core Independent Peripherals',
$$GETTING STARTED WITH PIC18F Q-SERIES CORE INDEPENDENT PERIPHERALS
Application Note AN1001 Rev. A

INTRODUCTION
The PIC18F Q-Series microcontrollers feature advanced Core Independent Peripherals (CIPs) that enable complex functions with minimal CPU intervention. This application note demonstrates practical implementations of CIPs for common embedded applications.

WHAT ARE CORE INDEPENDENT PERIPHERALS?
CIPs are smart peripherals that operate independently of the CPU core. They can:
- Respond to events in real-time without CPU intervention
- Continue operation in sleep modes
- Implement complex logic and timing functions in hardware
- Reduce power consumption by minimizing CPU active time

KEY CIP MODULES
1. Configurable Logic Cells (CLC)
2. Numerically Controlled Oscillator (NCO)
3. Complementary Waveform Generator (CWG)
4. Signal Measurement Timer (SMT)
5. Hardware Limit Timer (HLT)

EXAMPLE 1: PWM FREQUENCY MODULATION USING CLC AND NCO
This example shows how to modulate PWM frequency based on analog input without any CPU code in the control loop.

Hardware Setup:
- ADC reads analog voltage from potentiometer
- CLC routes ADC result to NCO frequency input
- NCO generates variable frequency output
- PWM module uses NCO as clock source

Configuration Steps:
1. Configure ADC for continuous conversion
2. Set up NCO with ADC output as frequency input
3. Configure CLC to route ADC → NCO
4. Initialize PWM with NCO clock source

Code Example:
```c
// ADC Configuration
ADCON0 = 0x01; // Select AN0, enable ADC
ADCON1 = 0x00; // Reference = VDD
ADPCH = 0x00;  // Channel selection
ADREF = 0x00;  // VDD reference
ADACT = 0x01;  // Auto-conversion trigger

// NCO Configuration
NCO1CON = 0x81; // Enable NCO, pulse frequency mode
NCO1CLK = 0x00; // Clock source = HFINTOSC
NCO1INCL = 0x00; // Increment low byte
NCO1INCH = 0x10; // Increment high byte

// CLC Configuration
// CLC1 routes ADC output to NCO
CLC1CON = 0x82; // Enable CLC, AND-OR mode
CLC1SEL0 = 0x15; // Select ADC result
CLC1SEL1 = 0x15; // Select ADC result  
CLC1GLS0 = 0x02; // Gate logic
CLC1POL = 0x00; // No inversion
```

EXAMPLE 2: EVENT COUNTING WITH SMT
The Signal Measurement Timer can count external events and generate interrupts at thresholds without CPU involvement.

Hardware Setup:
- SMT counts pulses on SMT input pin
- Threshold generates automatic interrupt
- CPU reads count only when threshold reached

Benefits:
- Zero CPU time for counting individual pulses
- Automatic threshold detection
- Accurate timing independent of interrupt latency

EXAMPLE 3: AUTOMATIC MOTOR STALL DETECTION
Using HLT (Hardware Limit Timer) and CWG for automatic motor control:

System Operation:
1. CWG generates complementary PWM for motor driver
2. HLT monitors encoder feedback
3. If encoder stops (motor stall), HLT triggers automatically
4. CWG shuts down motor output
5. Interrupt notifies CPU of stall condition

This entire stall detection and shutdown happens in hardware with no software delays!

POWER SAVINGS WITH CIPS
Example: Temperature monitoring system

Traditional Approach:
- Wake up every second
- Read ADC
- Process result
- Update output
- Sleep
Power: 500µA average

CIP Approach:
- ADC auto-conversion every second
- CLC compares to threshold
- Automatically toggles output
- CPU sleeps until alert
Power: 50µA average (10x improvement!)

COMBINING MULTIPLE CIPS
Advanced Example: Automatic Window Comparator with PWM Output

Signal Path:
ADC → CLC1 (high threshold detect) →
ADC → CLC2 (low threshold detect) →  CLC3 (window compare) → PWM duty control
ADC → CLC3 (window compare) → NCO frequency control

This creates a self-regulating feedback system with zero CPU intervention!

DEBUGGING CIP CONFIGURATIONS
Tools:
- MPLAB Data Visualizer - Observe CIP signals in real-time
- MCC (MPLAB Code Configurator) - Graphical CIP configuration
- Logic analyzer - Verify timing relationships

Common Issues:
1. Clock source mismatches
2. Incorrect CLC gate logic
3. Missing peripheral connections
4. Timing violations in complex chains

BEST PRACTICES
1. Start simple - test each CIP individually
2. Use MCC for initial configuration
3. Verify with Data Visualizer before deployment
4. Document signal paths clearly
5. Consider timing constraints when chaining peripherals
6. Test edge cases (threshold boundaries, startup conditions)

RELATED APPLICATION NOTES
- AN2447: CLC Cookbook for PIC MCUs
- AN3144: NCO Peripheral Theory and Applications
- AN3152: Using the SMT in Capture Mode

CONCLUSION
Core Independent Peripherals enable sophisticated applications with minimal code and maximum power efficiency. Start with simple examples and build complexity as you understand the architecture.$$,
'PIC', 'EMBEDDED_SYSTEMS', 'AN1001', 'Rev. A', 'pic,clc,cip,pwm,embedded', 'Microchip Engineering Staff', '2022-03-15', CURRENT_TIMESTAMP(), 4523, TRUE, CURRENT_TIMESTAMP()),

('AN002', 'SAM D21 Low Power Techniques and Best Practices',
$$SAM D21 LOW POWER TECHNIQUES AND BEST PRACTICES
Application Note AN2520 Rev. B

INTRODUCTION
The SAM D21 ARM Cortex-M0+ MCU offers multiple low-power modes and peripheral features to minimize power consumption. This guide provides practical techniques for battery-powered and energy-harvesting applications.

POWER MODES OVERVIEW
- Active Mode: CPU running, all peripherals available
- Idle Mode: CPU stopped, peripherals running, wake on interrupt
- Standby Mode: Most peripherals stopped, 6µA typical
- Backup Mode: Only RTC and backup registers, 1µA typical

DETAILED POWER MEASUREMENTS
Active Mode (3.3V, 25°C):
- 48MHz operation: 7.5 mA
- 8MHz operation: 2.0 mA
- 1MHz operation: 450 µA

Idle Mode:
- Full peripheral clock: 3.2 mA at 48MHz
- Reduced peripheral clock: 800 µA at 8MHz

Standby Mode:
- RTC running: 10 µA
- RTC stopped: 6 µA
- GCLK generators active: add 20-50µA per generator

ENTERING LOW POWER MODES
Idle Mode Example:
```c
void enter_idle_mode(void) {
    // Configure wake source first
    NVIC_EnableIRQ(EIC_IRQn);
    
    // Set sleep mode to idle
    SCB->SCR &= ~SCB_SCR_SLEEPDEEP_Msk;
    
    // Enter idle
    __WFI(); // Wait For Interrupt
}
```

Standby Mode Example:
```c
void enter_standby_mode(void) {
    // Configure wake sources (EIC or RTC)
    configure_eic_wake();
    
    // Set sleep mode to standby
    SCB->SCR |= SCB_SCR_SLEEPDEEP_Msk;
    PM->SLEEP.reg = PM_SLEEP_IDLE_STANDBY;
    
    // Disable unused peripherals
    PM->APBCMASK.reg = 0; // Disable all peripheral clocks except what you need
    
    // Enter standby
    __WFI();
}
```

PERIPHERAL POWER OPTIMIZATION

ADC Power Optimization:
- Use differential mode when possible (better noise immunity = fewer samples)
- Enable automatic averaging to reduce CPU wake-ups
- Use event system to trigger ADC from RTC (no CPU involvement)
- Power down ADC between conversions

Example:
```c
ADC->CTRLA.bit.ENABLE = 0; // Disable ADC
// Configure ADC
ADC->CTRLA.bit.ENABLE = 1; // Enable only when needed
// Take reading
while(!ADC->INTFLAG.bit.RESRDY); // Wait for conversion
result = ADC->RESULT.reg;
ADC->CTRLA.bit.ENABLE = 0; // Disable immediately after
```

SERCOM Power Optimization:
- Use DMA for data transfers (CPU can sleep during transfer)
- Enable run-in-standby only for peripherals that must stay active
- Use event system for automatic SERCOM triggering

Timer/Counter Power Optimization:
- Use prescalers to reduce counter frequency
- Enable run-in-standby only when required
- Use 16-bit timers instead of 32-bit when possible (lower power)

EVENT SYSTEM FOR ZERO-CPU OPERATION
The event system enables peripheral-to-peripheral communication without CPU:

Example: RTC triggers ADC reading automatically
```c
// Configure RTC event on compare
RTC->MODE0.EVCTRL.reg = RTC_MODE0_EVCTRL_CMPEO0;

// Configure event system
EVSYS->CHANNEL.reg = EVSYS_CHANNEL_EVGEN(EVSYS_ID_RTC_CMP_0) |
                     EVSYS_CHANNEL_PATH_ASYNCHRONOUS |
                     EVSYS_CHANNEL_EDGSEL_NO_EVT_OUTPUT;

// Configure ADC to start on event
ADC->EVCTRL.reg = ADC_EVCTRL_STARTEI;
```
Result: ADC reading every second with ZERO CPU wake-ups!

POWER PROFILING TECHNIQUES
1. Use Data Visualizer Power Analysis feature
2. Measure with high-precision current sense amplifier
3. Calculate average power for periodic tasks

Example Calculation:
```
Active 10ms every second: 7.5mA × 10ms = 75µA·s
Idle 990ms: 3mA × 990ms = 2970µA·s
Average = (75 + 2970) / 1000 = 3.045mA
```

OPTIMAL CODE PRACTICES
1. Batch operations to minimize wake-ups
2. Use DMA instead of CPU for memory operations
3. Process data before sleeping, not after waking
4. Use interrupts efficiently - don't poll!

Bad Example (polling):
```c
while(1) {
    if(PORT->Group[0].IN.reg & (1<<5)) {
        process_input();
    }
    delay_ms(10); // Wastes power!
}
```

Good Example (interrupt driven):
```c
void EIC_Handler(void) {
    if(EIC->INTFLAG.reg & EIC_INTFLAG_EXTINT5) {
        process_input();
        EIC->INTFLAG.reg = EIC_INTFLAG_EXTINT5;
    }
}

void main(void) {
    configure_eic();
    while(1) {
        enter_standby_mode(); // Sleep until interrupt
    }
}
```

PIN CONFIGURATION FOR LOW POWER
Floating pins waste power! Always configure unused pins:

```c
// Configure all unused pins
for(uint8_t pin = 0; pin < 32; pin++) {
    if(pin_is_unused(pin)) {
        PORT->Group[0].PINCFG[pin].reg = PORT_PINCFG_PULLEN; // Enable pull
        PORT->Group[0].DIRCLR.reg = (1 << pin); // Input mode
        PORT->Group[0].OUTCLR.reg = (1 << pin); // Pull down
    }
}
```

BATTERY LIFE ESTIMATION
Example: Temperature logger with CR2032 (220mAh) battery

Power Budget:
- Active 50ms every 10 minutes: 7.5mA × 50ms = 375µA·s per cycle
- Standby 599.95s: 10µA × 599.95s = 5999.5µA·s per cycle  
- Average current = (375 + 5999.5) / 600 = 10.6µA

Battery life = 220mAh / 0.0106mA = 20,750 hours = 2.4 years!

REAL-WORLD OPTIMIZATIONS
Case Study: Wireless sensor node

Before optimization:
- Active mode 100ms per second
- Idle mode rest of time
- Average: 3.5mA
- Battery life: 2.6 days

After optimization:
- Active mode 5ms per second
- Standby mode with RTC
- Event-driven ADC
- Average: 25µA
- Battery life: 366 days!

DEBUGGING POWER ISSUES
Common problems:
1. Peripheral clocks not disabled - check PM->APBCMASK
2. Floating pins - configure all pins
3. Analog circuits staying powered - disable ADC/COMP when not needed
4. Pull-ups on I2C when bus inactive - use GPIO instead
5. LEDs consuming power - disable or use very short duty cycles

RECOMMENDED HARDWARE DESIGN
1. Use efficient voltage regulators (>90% efficiency)
2. Add current measurement test points
3. Use load switches for external peripherals
4. Select low-leakage pull-up resistors (>100kΩ)
5. Consider energy harvesting for ultra-long life

CONCLUSION
The SAM D21 can achieve microamp average power consumption with proper configuration and code design. Use the event system, minimize CPU wake time, and configure all peripherals appropriately.$$,
'SAM', 'LOW_POWER', 'AN2520', 'Rev. B', 'sam d21,low power,battery,sleep mode', 'Microchip Engineering Staff', '2021-06-20', CURRENT_TIMESTAMP(), 7891, TRUE, CURRENT_TIMESTAMP()),

('AN003', 'Motor Control with dsPIC33 DSC - FOC Implementation Guide',
$$MOTOR CONTROL WITH dsPIC33 DSC - FIELD ORIENTED CONTROL
Application Note AN3000 Rev. C

INTRODUCTION
Field Oriented Control (FOC) provides superior performance for PMSM and BLDC motors compared to traditional six-step commutation. This application note demonstrates FOC implementation on dsPIC33 Digital Signal Controllers.

WHY USE FOC?
Benefits:
- Smooth torque across speed range
- Higher efficiency (10-15% improvement)
- Reduced acoustic noise
- Better dynamic response
- Precise speed and position control

Applications:
- HVAC compressors
- Appliance motors (washer, dryer)
- Industrial servo drives
- Automotive electric power steering
- E-bikes and scooters
- Drones and robotics

dsPIC33 ADVANTAGES FOR MOTOR CONTROL
1. High-resolution PWM (up to 250ps resolution)
2. Dedicated motor control PWM module with deadtime
3. Hardware fault protection
4. Fast ADC with dedicated motor control triggers
5. DSP instructions for fast math (MAC, divide)
6. Configurable Logic Cells for advanced protection

FOC ALGORITHM OVERVIEW
The FOC algorithm consists of these stages:
1. Phase current measurement (Ia, Ib, Ic)
2. Clarke Transform (abc → αβ)
3. Park Transform (αβ → dq)
4. PI Control loops (Id, Iq)
5. Inverse Park Transform (dq → αβ)
6. Space Vector Modulation (αβ → PWM)

MATHEMATICAL FOUNDATION
Clarke Transform:
```
Iα = Ia
Iβ = (1/√3) × (Ia + 2×Ib)
```

Park Transform:
```
Id = Iα×cos(θ) + Iβ×sin(θ)
Iq = -Iα×sin(θ) + Iβ×cos(θ)
```

Where θ is the rotor electrical angle.

HARDWARE CONFIGURATION
PWM Setup for 3-Phase Inverter:
```c
// Configure PWM for 20kHz, center-aligned
PTPER = (FCY / (2 × FPWM)) - 1; // Period register
PHASE1 = PTPER / 2; // 50% duty cycle initially
PHASE2 = PTPER / 2;
PHASE3 = PTPER / 2;

// Enable PWM outputs
IOCON1 = 0xC000; // PWM controls pins
IOCON2 = 0xC000;
IOCON3 = 0xC000;

// Deadtime configuration (500ns typical)
DTR1 = DTR2 = DTR3 = (FCY / 1000000) * 0.5; // 500ns
ALTDTR1 = ALTDTR2 = ALTDTR3 = DTR1;

// Enable PWM module
PTCONbits.PTEN = 1;
```

ADC Configuration for Current Sampling:
```c
// Trigger ADC at PWM edge for best noise immunity
ADC1CON1 = 0x0464; // Auto-sample, trigger from PWM
ADC1CON2 = 0x0000; // VDD/VSS reference
ADC1CON3 = 0x1F08; // Sample time = 31 Tad

// Configure channels for phase currents
ADC1CHS0 = 0x0001; // Channel A: AN1 (Ia)
ADC1CHS123 = 0x0203; // Channel B: AN2 (Ib), C: AN3 (Ic)

// Enable ADC
ADC1CON1bits.ADON = 1;
```

ROTOR POSITION ESTIMATION
For sensorless FOC, position is estimated using back-EMF:

Sliding Mode Observer Algorithm:
```c
// Simplified SMO equations
float alpha_error = Valpha_estimated - Valpha_measured;
float beta_error = Vbeta_estimated - Vbeta_measured;

// Sliding mode function
float Zalpha = sign(alpha_error) × Ksmo;
float Zbeta = sign(beta_error) × Ksmo;

// Low-pass filter to extract back-EMF
float EMF_alpha = LPF(Zalpha);
float EMF_beta = LPF(Zbeta);

// Calculate angle
theta_estimated = atan2(EMF_beta, EMF_alpha);
```

PI CONTROLLER IMPLEMENTATION
Current loop PI controllers (execute at PWM frequency):

```c
typedef struct {
    float Kp;
    float Ki;
    float error;
    float integral;
    float output;
    float output_max;
    float output_min;
} PI_Controller;

float PI_Update(PI_Controller *pi, float setpoint, float feedback) {
    // Calculate error
    pi->error = setpoint - feedback;
    
    // Integral term with anti-windup
    pi->integral += pi->Ki * pi->error;
    
    // Clamp integral
    if(pi->integral > pi->output_max) pi->integral = pi->output_max;
    if(pi->integral < pi->output_min) pi->integral = pi->output_min;
    
    // Calculate output
    pi->output = pi->Kp * pi->error + pi->integral;
    
    // Clamp output
    if(pi->output > pi->output_max) pi->output = pi->output_max;
    if(pi->output < pi->output_min) pi->output = pi->output_min;
    
    return pi->output;
}
```

SPACE VECTOR MODULATION
SVM provides better DC bus utilization than sine PWM:

```c
void SVM_Calculate(float Vα, float Vβ, uint16_t *PWM1, *PWM2, *PWM3) {
    // Calculate sector
    uint8_t sector = calculate_sector(Vα, Vβ);
    
    // Calculate time durations
    float T1, T2, T0;
    calculate_times(Vα, Vβ, sector, &T1, &T2, &T0);
    
    // Convert to PWM duty cycles based on sector
    switch(sector) {
        case 1:
            *PWM1 = T1 + T2 + T0/2;
            *PWM2 = T2 + T0/2;
            *PWM3 = T0/2;
            break;
        // ... cases for sectors 2-6 ...
    }
}
```

STARTUP SEQUENCE
Open-loop acceleration before switching to closed-loop:

```c
void motor_startup(void) {
    // Phase 1: Alignment (500ms)
    align_rotor();
    
    // Phase 2: Open-loop ramp (2 seconds)
    for(speed = 0; speed < MIN_SPEED_FOR_FOC; speed += RAMP_RATE) {
        run_open_loop(speed);
        delay_ms(10);
    }
    
    // Phase 3: Switch to closed-loop FOC
    enable_foc();
}
```

PERFORMANCE TUNING
PI Controller Tuning:
1. Start with Kp = 0.1, Ki = 0.01
2. Increase Kp until oscillation appears
3. Reduce Kp by 50%
4. Increase Ki until desired response speed
5. Verify stability across load range

Typical Values:
- Id controller: Kp = 0.15, Ki = 0.005 (fast response for flux control)
- Iq controller: Kp = 0.12, Ki = 0.003 (smooth torque response)
- Speed controller: Kp = 0.01, Ki = 0.0001 (slow, stable)

PROTECTION MECHANISMS
Overcurrent Protection:
```c
void overcurrent_check(void) {
    if((abs(Ia) > CURRENT_LIMIT) || 
       (abs(Ib) > CURRENT_LIMIT) ||
       (abs(Ic) > CURRENT_LIMIT)) {
        // Immediate shutdown using hardware fault
        PTCONbits.PTEN = 0;
        // Set fault flag
        motor_fault = FAULT_OVERCURRENT;
    }
}
```

EFFICIENCY OPTIMIZATION
1. Minimize Id current (field weakening only when needed)
2. Optimize switching frequency (higher = smoother, but more loss)
3. Use synchronous rectification when possible
4. Temperature compensation for motor parameters

DEBUGGING AND VERIFICATION
Tools:
- MPLAB Data Visualizer: Real-time waveforms
- X2CScope: Live variable monitoring
- Motor Control Plant: Simulation environment

Critical Measurements:
- Phase currents should be sinusoidal in steady state
- dq currents should be stable DC values
- Back-EMF estimation should track encoder (if available)

COMMON ISSUES AND SOLUTIONS
1. Motor doesn't start: Check alignment and ramp rate
2. Oscillation at low speed: Reduce PI gains
3. Position estimation drift: Improve back-EMF observer
4. Unstable at high speed: Increase sampling frequency or reduce bandwidth

CONCLUSION
FOC on dsPIC33 provides professional-grade motor control with minimal external components. Start with provided Motor Control libraries and tune for your specific motor.$$,
'dsPIC', 'MOTOR_CONTROL', 'AN3000', 'Rev. C', 'motor control,foc,dspic,pwm,bldc', 'Microchip Engineering Staff', '2023-01-10', CURRENT_TIMESTAMP(), 12450, TRUE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 7: Generate sample quality investigation reports
-- ============================================================================
INSERT INTO QUALITY_INVESTIGATION_REPORTS
SELECT
    'QIR' || LPAD(SEQ4(), 10, '0') AS investigation_report_id,
    qi.quality_issue_id,
    qi.customer_id,
    qi.product_id,
    CASE (ABS(RANDOM()) % 10)
        WHEN 0 THEN 'QUALITY INVESTIGATION REPORT #' || qi.quality_issue_id || CHR(10) ||
            'Product: ' || p.sku || ' - ' || p.product_name || CHR(10) ||
            'Issue Type: Field Failure - Device Not Programming' || CHR(10) ||
            'Date Reported: ' || qi.reported_date::VARCHAR || CHR(10) ||
            'Lot Number: ' || qi.lot_number || CHR(10) ||
            'Quantity Affected: ' || qi.affected_quantity::VARCHAR || ' units' || CHR(10) || CHR(10) ||
            'INITIAL INVESTIGATION:' || CHR(10) ||
            'Customer reported intermittent programming failures during production testing. Approximately 8% of devices from lot ' || qi.lot_number || ' fail device ID verification. Failures occur randomly across the wafer map with no obvious spatial correlation.' || CHR(10) || CHR(10) ||
            'FAILURE ANALYSIS:' || CHR(10) ||
            '1. Electrical Testing: Failed devices show normal DC parameters (VDD, IDD, IO levels)' || CHR(10) ||
            '2. Programming Analysis: Failures occur during device ID readback, not during programming sequence' || CHR(10) ||
            '3. Oscilloscope Measurements: ICSP signals show excessive ringing on PGC and PGD lines at high programming speeds' || CHR(10) ||
            '4. X-Ray Analysis: No package defects observed' || CHR(10) ||
            '5. Decapsulation: Die examination shows no visible defects' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Process variation in this lot resulted in higher input capacitance on PGC/PGD pins. Combined with customer board layout (long ICSP traces, no series resistors), this causes signal integrity degradation at default programming speed. The issue is exacerbated by impedance mismatch in customer programming fixture.' || CHR(10) || CHR(10) ||
            'CORRECTIVE ACTIONS:' || CHR(10) ||
            '1. Immediate: Advised customer to program at reduced clock speed or increased VDD voltage (both work-arounds successful)' || CHR(10) ||
            '2. Short-term: Implemented tighter parametric limits on input capacitance during wafer sort' || CHR(10) ||
            '3. Long-term: Design review for next silicon revision to improve signal integrity margin' || CHR(10) || CHR(10) ||
            'CUSTOMER IMPACT:' || CHR(10) ||
            'All affected devices are functional and meet datasheet specifications. Programming at reduced speed is reliable solution. No field returns expected from previously shipped units.'
        WHEN 1 THEN 'INVESTIGATION REPORT: FLASH MEMORY RETENTION ISSUE' || CHR(10) ||
            'Product: ' || p.product_name || ' (' || p.sku || ')' || CHR(10) ||
            'RMA Number: ' || qi.rma_number || CHR(10) ||
            'Severity: CRITICAL' || CHR(10) || CHR(10) ||
            'PROBLEM DESCRIPTION:' || CHR(10) ||
            'Customer reported data corruption in flash memory after extended high-temperature operation (85°C ambient for 6 months). Specific bit patterns show degradation, primarily in high address regions of flash.' || CHR(10) || CHR(10) ||
            'FAILURE ANALYSIS RESULTS:' || CHR(10) ||
            'Returned units analyzed at failure analysis lab:' || CHR(10) ||
            '- Flash bit error rate: 10^-4 (specification: <10^-6)' || CHR(10) ||
            '- Error distribution: Non-random, clustered in high addresses' || CHR(10) ||
            '- Write/erase cycle count: Within specification (<1000 cycles)' || CHR(10) ||
            '- Temperature stress testing: Issue reproduces at 125°C after 500 hours' || CHR(10) ||
            '- X-ray crystallography: Oxide degradation detected in flash tunnel oxide' || CHR(10) || CHR(10) ||
            'ROOT CAUSE ANALYSIS:' || CHR(10) ||
            'Flash tunnel oxide thickness variation in manufacturing lot ' || qi.lot_number || ' resulted in degraded charge retention at elevated temperatures. Process investigation revealed tungsten contamination in CVD chamber during oxide deposition, affecting oxide quality. Contamination was intermittent, affecting approximately 15% of wafers in the lot.' || CHR(10) || CHR(10) ||
            'SCOPE OF IMPACT:' || CHR(10) ||
            '- Affected date codes: ' || qi.lot_number || ' and adjacent lots' || CHR(10) ||
            '- Estimated quantity in field: 45,000 units' || CHR(10) ||
            '- Customer applications: High-reliability industrial controllers' || CHR(10) || CHR(10) ||
            'IMMEDIATE CONTAINMENT:' || CHR(10) ||
            '1. Stop-ship on all affected lots' || CHR(10) ||
            '2. Customer notification for field replacement program' || CHR(10) ||
            '3. Enhanced testing protocol implemented (extended temperature stress)' || CHR(10) || CHR(10) ||
            'CORRECTIVE ACTIONS:' || CHR(10) ||
            '1. CVD chamber maintenance and cleaning (completed)' || CHR(10) ||
            '2. Tungsten contamination monitoring added to process control (ongoing)' || CHR(10) ||
            '3. Additional flash reliability screening for high-temp applications (implemented)' || CHR(10) ||
            '4. Oxide thickness specification tightened (revision B process)' || CHR(10) || CHR(10) ||
            'PREVENTIVE MEASURES:' || CHR(10) ||
            '- Added inline metrology for oxide thickness uniformity' || CHR(10) ||
            '- Quarterly CVD chamber preventive maintenance' || CHR(10) ||
            '- Enhanced supplier qualification for tungsten targets'
        WHEN 2 THEN 'RMA INVESTIGATION: ADC NON-LINEARITY ISSUE' || CHR(10) ||
            'Product: ' || p.product_family || ' Family' || CHR(10) ||
            'Customer: ' || c.customer_name || CHR(10) ||
            'Reported: ' || qi.reported_date::VARCHAR || CHR(10) || CHR(10) ||
            'CUSTOMER COMPLAINT:' || CHR(10) ||
            'ADC readings show non-linearity errors exceeding datasheet specifications in middle of conversion range. INL (Integral Non-Linearity) measured at 3.5 LSB versus specified 2 LSB maximum at 12-bit resolution.' || CHR(10) || CHR(10) ||
            'PRELIMINARY ANALYSIS:' || CHR(10) ||
            'Tested 20 units from customer returns:' || CHR(10) ||
            '- 18 units PASS ADC linearity specification' || CHR(10) ||
            '- 2 units FAIL with INL = 3.2-3.8 LSB' || CHR(10) ||
            'Pattern suggests external interference or reference voltage issue rather than silicon defect.' || CHR(10) || CHR(10) ||
            'BOARD-LEVEL INVESTIGATION:' || CHR(10) ||
            'Examined customer PCB layout:' || CHR(10) ||
            '- VREF trace runs parallel to high-speed SPI clock for 2 inches' || CHR(10) ||
            '- No guard traces or ground shielding' || CHR(10) ||
            '- Reference capacitor is 0.1uF (recommended: 1uF + 0.1uF)' || CHR(10) ||
            '- AVDD and AVSS have shared return path with digital ground' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Coupling noise from SPI clock onto analog reference voltage creates voltage fluctuations during ADC conversions. This manifests as INL errors particularly in mid-range codes where switching noise amplitude varies. Problem is board layout dependent - only affects units where noise coupling is highest.' || CHR(10) || CHR(10) ||
            'RECOMMENDED DESIGN CHANGES:' || CHR(10) ||
            '1. Route VREF away from digital signals (minimum 0.5" spacing)' || CHR(10) ||
            '2. Add ground guard traces on both sides of VREF' || CHR(10) ||
            '3. Increase reference bypass to 1uF tantalum + 0.1uF ceramic' || CHR(10) ||
            '4. Implement star ground topology for analog supplies' || CHR(10) ||
            '5. Add ferrite bead on AVDD supply (optional but recommended)' || CHR(10) || CHR(10) ||
            'CUSTOMER RESOLUTION:' || CHR(10) ||
            'Provided application note AN2875 "ADC Layout Best Practices" and board redesign recommendations. Customer implemented changes on Rev B board with successful results - INL improved to 0.8 LSB typical. No silicon issue - closed as application/layout issue with customer acknowledgment.'
        WHEN 3 THEN 'FIELD FAILURE INVESTIGATION - USB COMMUNICATION ISSUES' || CHR(10) ||
            'Product SKU: ' || p.sku || CHR(10) ||
            'Failure Mode: Intermittent USB enumeration failures' || CHR(10) ||
            'Population: ~200 units in field' || CHR(10) || CHR(10) ||
            'FAILURE SYMPTOMS:' || CHR(10) ||
            'USB device occasionally fails to enumerate on PC connection. Requires power cycle to recover. Frequency increases with ambient temperature above 40°C. No pattern based on PC host OS or USB hub usage.' || CHR(10) || CHR(10) ||
            'ELECTRICAL CHARACTERIZATION:' || CHR(10) ||
            'USB signal quality analysis on failing units:' || CHR(10) ||
            '- D+ / D- eye diagram shows signal degradation at temperature' || CHR(10) ||
            '- Rise time: 5.2ns at 25°C, 8.1ns at 50°C (limit: 4ns max)' || CHR(10) ||
            '- Fall time: Within specification at all temperatures' || CHR(10) ||
            '- Jitter: Increased 30% at elevated temperature' || CHR(10) || CHR(10) ||
            'COMPONENT ANALYSIS:' || CHR(10) ||
            'Investigated all USB signal path components:' || CHR(10) ||
            '- Crystal: Frequency stable across temperature' || CHR(10) ||
            '- Series resistors: Values confirmed 22Ω ±1%' || CHR(10) ||
            '- PCB trace impedance: Measured 85Ω (spec 90Ω ±10%)' || CHR(10) ||
            '- Internal pull-up: Degrades from 1.5kΩ to 2.1kΩ at 60°C' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Internal USB pull-up resistor has excessive temperature coefficient due to process variation in this manufacturing lot. As temperature increases, pull-up resistance increases beyond USB specification limits, causing signal rise time violations. This prevents reliable host detection and enumeration.' || CHR(10) || CHR(10) ||
            'SILICON INVESTIGATION:' || CHR(10) ||
            'Process review identified implant dose variation during pull-up resistor formation. Lot ' || qi.lot_number || ' received 8% lower dose than target, resulting in higher base resistance and temperature coefficient.' || CHR(10) || CHR(10) ||
            'CORRECTIVE ACTIONS:' || CHR(10) ||
            '1. Process: Tightened implant dose control to ±3% (was ±10%)' || CHR(10) ||
            '2. Testing: Added pull-up resistance test at high temperature to final test program' || CHR(10) ||
            '3. Customer: Field replacement program for affected lots' || CHR(10) ||
            '4. Design: Next revision includes external pull-up option for temperature-critical applications' || CHR(10) || CHR(10) ||
            'LESSON LEARNED:' || CHR(10) ||
            'High-temperature USB characterization should be mandatory for all new USB-capable products. Current test program only validates at room temperature.'
        WHEN 4 THEN 'QUALITY ALERT: OSCILLATOR START-UP FAILURES' || CHR(10) ||
            'Device: ' || p.product_name || CHR(10) ||
            'Issue: Crystal oscillator fails to start reliably' || CHR(10) ||
            'Date Code: ' || qi.lot_number || CHR(10) || CHR(10) ||
            'PROBLEM STATEMENT:' || CHR(10) ||
            'Customer production line experiencing 2-3% oscillator start-up failures. Devices that fail initially will often succeed on subsequent power cycles. Problem appears temperature dependent (worse at low temperature).' || CHR(10) || CHR(10) ||
            'CUSTOMER DESIGN REVIEW:' || CHR(10) ||
            'Crystal specifications:' || CHR(10) ||
            '- Frequency: 8.000MHz' || CHR(10) ||
            '- Load capacitance: 18pF' || CHR(10) ||
            '- ESR: 60Ω (maximum 80Ω per our spec)' || CHR(10) ||
            '- Drive level: 100µW (within our 10-500µW range)' || CHR(10) ||
            'Load capacitors: 22pF ± 5% ceramic X7R' || CHR(10) ||
            'PCB layout: Traces <0.5" as recommended' || CHR(10) || CHR(10) ||
            'SILICON CHARACTERIZATION:' || CHR(10) ||
            'Tested oscillator drive strength:' || CHR(10) ||
            '- Nominal devices: Start-up time 2-5ms, 100% success rate' || CHR(10) ||
            '- Failing lot devices: Start-up time 15-50ms, 97% success rate' || CHR(10) ||
            '- Drive current at 25°C: 10% lower than nominal' || CHR(10) ||
            '- Drive current at 0°C: 25% lower than nominal' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Oscillator driver transistor threshold voltage (Vth) shifted high in this manufacturing lot due to ion implantation process variation. Higher Vth reduces drive current, especially at low temperatures where mobility is reduced. Marginal drive current combined with worst-case crystal ESR results in insufficient loop gain for reliable oscillation start-up.' || CHR(10) || CHR(10) ||
            'CONTRIBUTING FACTORS:' || CHR(10) ||
            '1. Implant dose 12% below center of process window' || CHR(10) ||
            '2. Customer using crystals near maximum ESR specification' || CHR(10) ||
            '3. PCB parasitic capacitance adds ~3pF to load' || CHR(10) || CHR(10) ||
            'IMMEDIATE ACTIONS:' || CHR(10) ||
            '- Implemented oscillator start-up screening test at -40°C for this lot' || CHR(10) ||
            '- Advised customer to specify crystals with ESR <50Ω for improved margin' || CHR(10) ||
            '- Released engineering change notice to reduce load capacitor to 18pF' || CHR(10) || CHR(10) ||
            'LONG-TERM FIXES:' || CHR(10) ||
            '1. Process: Center implant dose and reduce variation window from ±15% to ±8%' || CHR(10) ||
            '2. Design: Increase oscillator amplifier bias current by 20% in next silicon revision' || CHR(10) ||
            '3. Testing: Add production test for oscillator start-up at temperature extremes' || CHR(10) ||
            '4. Documentation: Update hardware design guide with tighter crystal ESR recommendation'
        WHEN 5 THEN 'PACKAGE INTEGRITY INVESTIGATION' || CHR(10) ||
            'Product: ' || p.sku || ' in ' || p.package_type || ' package' || CHR(10) ||
            'Failure: Moisture-induced package delamination' || CHR(10) ||
            'Affected Quantity: ' || qi.affected_quantity::VARCHAR || ' units' || CHR(10) || CHR(10) ||
            'FAILURE DESCRIPTION:' || CHR(10) ||
            'After reflow soldering, some devices show functional failures (shorts, opens). Acoustic microscopy reveals package delamination between die and mold compound. Issue appears correlated with humid storage conditions prior to assembly.' || CHR(10) || CHR(10) ||
            'PHYSICAL ANALYSIS:' || CHR(10) ||
            '- SAM (Scanning Acoustic Microscopy): Delamination at die attach interface' || CHR(10) ||
            '- X-ray: Voids visible in die attach material' || CHR(10) ||
            '- Cross-section: Wire bond damage from package expansion' || CHR(10) ||
            '- Moisture content: 0.18% (limit 0.075% for MSL 3)' || CHR(10) || CHR(10) ||
            'ROOT CAUSE:' || CHR(10) ||
            'Moisture absorbed during storage exceeds MSL (Moisture Sensitivity Level) rating for this package type. During reflow, trapped moisture vaporizes causing:' || CHR(10) ||
            '1. Die attach delamination from vapor pressure' || CHR(10) ||
            '2. Package cracking (popcorn effect)' || CHR(10) ||
            '3. Wire bond damage from differential expansion' || CHR(10) || CHR(10) ||
            'INVESTIGATION FINDINGS:' || CHR(10) ||
            'Lot ' || qi.lot_number || ' was stored unsealed for 45 days in ambient conditions (25°C / 65% RH). This exceeds the floor life for MSL 3 devices (168 hours). Customer was not following proper moisture-sensitive handling procedures.' || CHR(10) || CHR(10) ||
            'CORRECTIVE ACTIONS:' || CHR(10) ||
            '1. Customer training on MSL handling requirements' || CHR(10) ||
            '2. Implemented bake-out procedure for affected inventory (125°C for 24 hours)' || CHR(10) ||
            '3. Improved package labeling with prominent MSL warnings' || CHR(10) ||
            '4. Evaluation of MSL 2 package option for this product' || CHR(10) || CHR(10) ||
            'PREVENTION:' || CHR(10) ||
            '- Customer implementing moisture indicator cards in sealed bags' || CHR(10) ||
            '- Training program for production staff on MSL handling' || CHR(10) ||
            '- Updated storage procedures to track floor life exposure' || CHR(10) || CHR(10) ||
            'CONCLUSION:' || CHR(10) ||
            'No silicon or package manufacturing defect. Issue caused by improper storage handling. All units that underwent proper bake-out and quick reflow passed functional testing. Customer implementing procedural changes to prevent recurrence.'
        ELSE 'INVESTIGATION REPORT: GENERAL QUALITY ISSUE' || CHR(10) ||
            'Product: ' || p.product_name || CHR(10) ||
            'Issue: ' || qi.issue_type || CHR(10) ||
            'Severity: ' || qi.severity || CHR(10) || CHR(10) ||
            'A thorough investigation was conducted to determine the root cause of the reported quality issue. Analysis included electrical testing, failure analysis, process review, and customer application assessment. Corrective actions have been implemented to prevent recurrence.'
    END AS report_text,
    ARRAY_CONSTRUCT('ROOT_CAUSE_ANALYSIS', 'FAILURE_ANALYSIS', 'PROCESS_INVESTIGATION', 'CUSTOMER_APPLICATION_REVIEW')[UNIFORM(0, 3, RANDOM())] AS investigation_type,
    qi.investigation_status,
    'Root cause identified and corrective actions implemented' AS root_cause_summary,
    'Process controls enhanced, testing procedures updated, customer notified' AS corrective_actions,
    DATEADD('day', UNIFORM(5, 30, RANDOM()), qi.reported_date) AS report_date,
    'Quality Engineering Team' AS investigated_by,
    DATEADD('day', UNIFORM(5, 30, RANDOM()), qi.reported_date) AS created_at
FROM RAW.QUALITY_ISSUES qi
JOIN RAW.PRODUCT_CATALOG p ON qi.product_id = p.product_id
JOIN RAW.CUSTOMERS c ON qi.customer_id = c.customer_id
WHERE UNIFORM(0, 100, RANDOM()) < 60
LIMIT 15000;

-- ============================================================================
-- Step 8: Create Cortex Search Service for Support Transcripts
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPORT_TRANSCRIPTS_SEARCH
  ON transcript_text
  ATTRIBUTES customer_id, support_engineer_id, interaction_type, product_family, issue_category
  WAREHOUSE = MICROCHIP_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for technical support transcripts - enables semantic search across support interactions'
AS
  SELECT
    transcript_id,
    transcript_text,
    ticket_id,
    customer_id,
    support_engineer_id,
    interaction_type,
    interaction_date,
    product_family,
    issue_category,
    resolution_provided,
    created_at
  FROM RAW.SUPPORT_TRANSCRIPTS;

-- ============================================================================
-- Step 9: Create Cortex Search Service for Application Notes
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE APPLICATION_NOTES_SEARCH
  ON content
  ATTRIBUTES product_family, application_category, title, document_number
  WAREHOUSE = MICROCHIP_WH
  TARGET_LAG = '24 hours'
  COMMENT = 'Cortex Search service for application notes - enables semantic search across technical documentation'
AS
  SELECT
    appnote_id,
    title,
    content,
    product_family,
    application_category,
    document_number,
    revision,
    tags,
    author,
    publish_date,
    last_updated,
    download_count,
    created_at
  FROM RAW.APPLICATION_NOTES;

-- ============================================================================
-- Step 10: Create Cortex Search Service for Quality Investigation Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE QUALITY_INVESTIGATION_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES customer_id, product_id, investigation_type, investigation_status
  WAREHOUSE = MICROCHIP_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for quality investigation reports - enables semantic search across quality documentation'
AS
  SELECT
    investigation_report_id,
    report_text,
    quality_issue_id,
    customer_id,
    product_id,
    investigation_type,
    investigation_status,
    root_cause_summary,
    corrective_actions,
    report_date,
    investigated_by,
    created_at
  FROM RAW.QUALITY_INVESTIGATION_REPORTS;

-- ============================================================================
-- Step 11: Verify Cortex Search Services Created
-- ============================================================================
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status,
       COUNT(*) AS service_count
FROM (
  SELECT 'SUPPORT_TRANSCRIPTS_SEARCH' AS service_name
  UNION ALL
  SELECT 'APPLICATION_NOTES_SEARCH'
  UNION ALL
  SELECT 'QUALITY_INVESTIGATION_REPORTS_SEARCH'
);

-- ============================================================================
-- Display data counts
-- ============================================================================
SELECT 'SUPPORT_TRANSCRIPTS' AS table_name, COUNT(*) AS row_count FROM SUPPORT_TRANSCRIPTS
UNION ALL
SELECT 'APPLICATION_NOTES', COUNT(*) FROM APPLICATION_NOTES
UNION ALL
SELECT 'QUALITY_INVESTIGATION_REPORTS', COUNT(*) FROM QUALITY_INVESTIGATION_REPORTS
ORDER BY table_name;

