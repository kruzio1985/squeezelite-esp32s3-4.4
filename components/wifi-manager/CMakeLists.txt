set( WEBPACK_DIR webapp/webpack/dist )

# for the forgetful, REQUIRES cannot use CONFIG_XXX due to parsing order
# driver_bt (A2DP/Classic BT) only available on ESP32, not ESP32-S3 (BLE only)
if(IDF_TARGET STREQUAL "esp32")
    set(target_requires "driver_bt")
endif()

idf_component_register( SRC_DIRS . webapp UML-State-Machine-in-C/src
						INCLUDE_DIRS . webapp UML-State-Machine-in-C/src
						REQUIRES squeezelite-ota json mdns 
						PRIV_REQUIRES esp_eth tools services platform_config esp_common json newlib freertos spi_flash nvs_flash mdns pthread wpa_supplicant platform_console esp_http_server console ${target_requires}
)

include(webapp/webapp.cmake)

