#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#include <DHT.h>
#include <SPI.h>
#include <MFRC522.h>
#include <ESP32Servo.h>
#include <time.h>
#include <Adafruit_NeoPixel.h>

#define WIFI_SSID "Hai"
#define WIFI_PASSWORD "HaihaI1980"

#define API_KEY "AIzaSyBiEGvNAqDO62GmbuS7U2DD-dng63Xm0Sk"
#define DATABASE_URL "https://flutter-iot-fffd8-default-rtdb.firebaseio.com/"
#define FIREBASE_PROJECT_ID "flutter-iot-fffd8"

#define DHT_SENSOR_PIN 13
#define DHT11_SENSOR_PIN 33
#define DHT_SENSOR_TYPE DHT22
#define DHT11_SENSOR_TYPE DHT11

#define FAN_PIN 4
#define LED1_PIN 12
#define LED2_PIN 32
#define LED_AIR_PIN 14

#define LDR_PIN 36
#define PWMChanel 0

#define BUZZER_PIN 2
#define SS_PIN 5
#define RST_PIN 0
#define PIN_SG90 27
// Cấu hình LED
#define LED_PIN 16  // Chân GPIO kết nối WS2812B
#define NUM_LEDS 8  // Số lượng LED

// Sử dụng email và password của bạn
#define USER_EMAIL "tuyen@gmail.com"
#define USER_PASSWORD "123456"

Adafruit_NeoPixel strip(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);

// NTP Configuration
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 7 * 3600;  // GMT+7
const int daylightOffset_sec = 0;

//Lockdoor
MFRC522 rfid(SS_PIN, RST_PIN);
MFRC522::MIFARE_Key key;
byte nuidPICC[4] = { 0xA2, 0x9A, 0xF6, 0x21 };  //A2 9A F6 21
// byte nuidPICC_1[4] = {0x60, 0x31, 0x48, 0x12};
Servo sg90;
// Initialize variables
String userId;
bool unlockState = false;
// Fan servo
Servo myServo;  // Tạo đối tượng servo


//Home
DHT dht_sensor(DHT_SENSOR_PIN, DHT_SENSOR_TYPE);
DHT dht11_sensor(DHT11_SENSOR_PIN, DHT11_SENSOR_TYPE);

const int freq = 5000;     // tan so 5000
const int resolution = 8;  // do phan giai 8bit 0->255

// FirebaseData fbdo, fbdo_s1, fbdo_s2, fbdo_s3, fbdo_s4;  // tao luong stream cho led_digital va analog
FirebaseData fbdo, fbdo_s1, fbdo_s2, fbdo_s3, fbdo_s4, fbdo_s5;  // tao luong stream cho led_digital va analog
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;
int ldrData = 0;
float voltage = 0.0;

int pwmValue = 0;
bool ledStatus = false;
bool ledAirStatus = false;
bool fanMotor = false;

float humi = 0;
float humi11 = 0;
float temp = 0;
float temp11 = 0;

// Dữ liệu điều khiển
int brightness = 0;                // Độ sáng (0-255)
int numLeds = 0;                   // Số lượng LED
int red = 0, green = 0, blue = 0;  // Giá trị màu RGB (0-255)


void setup() {
    setupNTP();
    SPI.begin();
    rfid.PCD_Init();

    myServo.attach(4);                // quạt vào chân số 4 trên Arduino
    myServo.writeMicroseconds(1500);  // Dừng servo ở trạng thái trung tính

    sg90.setPeriodHertz(50);
    sg90.attach(PIN_SG90, 500, 2400);
    for (byte i = 0; i < 6; i++) {
        key.keyByte[i] = 0xFF;
    }

    pinMode(BUZZER_PIN, OUTPUT);
    pinMode(DHT_SENSOR_PIN, INPUT);
    pinMode(DHT11_SENSOR_PIN, INPUT);
    dht_sensor.begin();
    dht11_sensor.begin();

    pinMode(LDR_PIN, INPUT);
    pinMode(LED2_PIN, OUTPUT); //digital 32
    pinMode(LED_AIR_PIN, OUTPUT);
    pinMode(LED1_PIN, OUTPUT);
    // ledcAttachChannel(LED1_PIN, freq, resolution, PWMChanel); //analog 12

    Serial.begin(115200);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());

    config.api_key = API_KEY;
    config.database_url = DATABASE_URL;

    // Đăng nhập bằng email/password
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
    signupOK = true;

    config.token_status_callback = tokenStatusCallback;  // See addons/TokenHelper.h
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);

    // Stream config
    if (!Firebase.RTDB.beginStream(&fbdo_s1, "/Led/analog")) Serial.printf("Stream 1 begin error, %s\n\n", fbdo_s1.errorReason().c_str());
    if (!Firebase.RTDB.beginStream(&fbdo_s2, "/Led/digital")) Serial.printf("Stream 2 begin error, %s\n\n", fbdo_s2.errorReason().c_str());
    if (!Firebase.RTDB.beginStream(&fbdo_s3, "/RGB")) Serial.printf("Stream 3 begin error, %s\n\n", fbdo_s3.errorReason().c_str());
    if (!Firebase.RTDB.beginStream(&fbdo_s4, "/Led/air")) Serial.printf("Stream 4 begin error, %s\n\n", fbdo_s4.errorReason().c_str());
    if (!Firebase.RTDB.beginStream(&fbdo_s5, "/Sensor/Motor")) Serial.printf("Stream 5 begin error, %s\n\n", fbdo_s5.errorReason().c_str());

    // Khởi tạo LED strip RGB
    setupStrip();
    strip.begin();
    strip.show();  // Bắt đầu với trạng thái tắt
}

void loop() {
    if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0)) {
        sendDataPrevMillis = millis();

        // Đọc dữ liệu từ cảm biến
        humi = dht_sensor.readHumidity();
        temp = dht_sensor.readTemperature();
        humi11 = dht11_sensor.readHumidity();
        temp11 = dht11_sensor.readTemperature();
        ldrData = analogRead(LDR_PIN);
        voltage = (float)analogReadMilliVolts(LDR_PIN) / 1000;  // convert miliVolt to Volt

        // Lưu dữ liệu vào Realtime Database
        sendData();
    }

    //----READ data from a RTDB onDataChange-----
    readDataOnChange();
    sendRFID();
}

void sendData() {
    if (Firebase.RTDB.setInt(&fbdo, "Sensor/light_sensor/ldr_data", ldrData)) {
        Serial.println("ldrData: " + String(ldrData));
    } else {
        // Serial.println("FAILED: " + fbdo.errorReason());
        Serial.println("FAILED");
    }

    if (Firebase.RTDB.setFloat(&fbdo, "Sensor/light_sensor/voltage", voltage)) {
        Serial.println("voltage: " + String(voltage));
    } else {
        // Serial.println("FAILED: " + fbdo.errorReason());
        Serial.println("FAILED");
    }

    if (isnan(humi) || isnan(temp) || isnan(humi11) || isnan(temp11)) {

        Serial.println("Failed to read from DHT sensor!");
    } else {
        if (Firebase.RTDB.setFloat(&fbdo, "Sensor/DHT/humi", humi)) {
            Serial.println();
            Serial.println("DHT22 Humi: " + String(humi));
        } else {
            // Serial.println("FAILED: " + fbdo.errorReason());
            Serial.println("FAILED");
        }

        if (Firebase.RTDB.setFloat(&fbdo, "Sensor/DHT/temp", temp)) {
            Serial.println("DHT22 Temp: " + String(temp));
        } else {
            // Serial.println("FAILED: " + fbdo.errorReason());
            Serial.println("FAILED");
        }

        if (Firebase.RTDB.setFloat(&fbdo, "Sensor/DHT11/humi", humi11)) {
            Serial.println("DHT11 Humi: " + String(humi11));
        } else {
            // Serial.println("FAILED: " + fbdo.errorReason());
            Serial.println("FAILED");
        }

        if (Firebase.RTDB.setFloat(&fbdo, "Sensor/DHT11/temp", temp11)) {
            Serial.println("DHT11 Temp: " + String(temp11));
        } else {
            // Serial.println("FAILED: " + fbdo.errorReason());
            Serial.println("FAILED");
        }
    }
}

void readDataOnChange() {
    if (Firebase.ready() && signupOK) {
        //----READ data from a RTDB onDataChange-----
        if (!Firebase.RTDB.readStream(&fbdo_s1))
            Serial.printf("Stream 1 READ error, %s\n\n", fbdo_s1.errorReason().c_str());
        if (fbdo_s1.streamAvailable()) {
            if (fbdo_s1.dataType() == "int") {
                pwmValue = fbdo_s1.intData();
                Serial.println("LED Analog: " + String(pwmValue));
                // ledcWrite(LED1_PIN, pwmValue);
                analogWrite(LED1_PIN, pwmValue);
            }
        }

        if (!Firebase.RTDB.readStream(&fbdo_s2))
            Serial.printf("Stream 2 READ error, %s\n\n", fbdo_s2.errorReason().c_str());
        if (fbdo_s2.streamAvailable()) {
            if (fbdo_s2.dataType() == "boolean") {
                ledStatus = fbdo_s2.boolData();
                Serial.println("LED Digital: " + String(ledStatus));
                digitalWrite(LED2_PIN, ledStatus);
            }
        }

        if (!Firebase.RTDB.readStream(&fbdo_s3))
            Serial.printf("Stream 3 READ error, %s\n\n", fbdo_s3.errorReason().c_str());
        if (fbdo_s3.streamAvailable()) {
            Serial.println("Stream 3 RGB data received:");
            // Khi bất kỳ trường nào thay đổi, đọc lại toàn bộ dữ liệu từ Firebase
            setupStrip();
        }

        if (!Firebase.RTDB.readStream(&fbdo_s4))
            Serial.printf("Stream 4 READ error, %s\n\n", fbdo_s4.errorReason().c_str());
        if (fbdo_s4.streamAvailable()) {
            if (fbdo_s4.dataType() == "boolean") {
                ledAirStatus = fbdo_s4.boolData();
                Serial.println("LED Air: " + String(ledAirStatus));
                digitalWrite(LED_AIR_PIN, ledAirStatus);
            }
        }

        if (!Firebase.RTDB.readStream(&fbdo_s5))
            Serial.printf("Stream 5 READ error, %s\n\n", fbdo_s5.errorReason().c_str());
        if (fbdo_s5.streamAvailable()) {
            if (fbdo_s5.dataType() == "boolean") {
                fanMotor = fbdo_s5.boolData();
                Serial.println("Fan Motor: " + String(fanMotor));
                if (fanMotor == true) {
                    myServo.writeMicroseconds(1800);  // Tăng xung để quay thuận
                } else {
                    myServo.writeMicroseconds(1500);  ///trung tính
                }
            }
        }
    }
}


void sendRFID() {
    if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
        return;
    }

    Serial.print(F("PICC type: "));
    MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);

    Serial.println(rfid.PICC_GetTypeName(piccType));

    if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI && piccType != MFRC522::PICC_TYPE_MIFARE_1K && piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
        Serial.println(F("Your tag is not of type MIFARE Classic."));
        return;
    }

    if (rfid.uid.uidByte[0] == nuidPICC[0] && rfid.uid.uidByte[1] == nuidPICC[1] && rfid.uid.uidByte[2] == nuidPICC[2] && rfid.uid.uidByte[3] == nuidPICC[3]) {
        Serial.println(F("Open the door."));
        Serial.print(F("The NUID tag is:"));
        printHex(rfid.uid.uidByte, rfid.uid.size);
        Serial.println();

        sg90.write(90);
        // Get the UID of the card
        userId = "";
        for (byte i = 0; i < rfid.uid.size; i++) {
            userId += String(rfid.uid.uidByte[i], HEX);
        }
        userId.toUpperCase();
        Serial.printf("Card detected: %s\n", userId.c_str());
        unlockState = true;
        Serial.println("Door unlocked");
        sendUnlockData(userId, unlockState);

        delay(3000);
        unlockState = false;
        Serial.println("Door locked");

        sg90.write(180);

    } else {
        userId = "";
        for (byte i = 0; i < rfid.uid.size; i++) {
            userId += String(rfid.uid.uidByte[i], HEX);
        }
        userId.toUpperCase();
        Serial.println(F("Can't open the door"));
        digitalWrite(BUZZER_PIN, HIGH);
        delay(1000);
        digitalWrite(BUZZER_PIN, LOW);
        sendUnlockData(userId, unlockState);
    }

    rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
}

void sendUnlockData(String id, bool state) {
    if (!Firebase.ready()) {
        Serial.println("Firebase not ready. Skipping data upload.");
        return;
    }

    String documentPath = "lockdoor";
    String currentTime = getCurrentTime();  // Lấy thời gian thực

    FirebaseJson content;
    content.set("fields/tags/stringValue", id.c_str());
    content.set("fields/unlock_time/stringValue", currentTime.c_str());
    content.set("fields/unlock_state/booleanValue", state);

    if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw())) {
        Serial.println("Data uploaded successfully");
    } else {
        Serial.printf("Error: %s\n", fbdo.errorReason().c_str());
    }
}

void printHex(byte* buffer, byte bufferSize) {
    for (byte i = 0; i < bufferSize; i++) {
        Serial.print(buffer[i] < 0x10 ? " 0" : " ");
        Serial.print(buffer[i], HEX);
    }
}

void setupNTP() {
    configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
    Serial.println("NTP server configured, syncing time...");
}

void setupStrip() {
    // Đọc dữ liệu ban đầu từ RTDB
    if (Firebase.RTDB.getInt(&fbdo, "RGB/brightness")) {
        brightness = fbdo.intData();
    } else {
        Serial.printf("Failed to get brightness, %s\n", fbdo.errorReason().c_str());
    }

    if (Firebase.RTDB.getInt(&fbdo, "RGB/numLeds")) {
        numLeds = fbdo.intData();
        if (numLeds > NUM_LEDS) numLeds = NUM_LEDS;
    } else {
        Serial.printf("Failed to get numLeds, %s\n", fbdo.errorReason().c_str());
    }

    if (Firebase.RTDB.getInt(&fbdo, "RGB/red")) {
        red = fbdo.intData();
    } else {
        Serial.printf("Failed to get red, %s\n", fbdo.errorReason().c_str());
    }

    if (Firebase.RTDB.getInt(&fbdo, "RGB/green")) {
        green = fbdo.intData();
    } else {
        Serial.printf("Failed to get green, %s\n", fbdo.errorReason().c_str());
    }

    if (Firebase.RTDB.getInt(&fbdo, "RGB/blue")) {
        blue = fbdo.intData();
    } else {
        Serial.printf("Failed to get blue, %s\n", fbdo.errorReason().c_str());
    }

    // Cập nhật LED theo dữ liệu ban đầu
    strip.setBrightness(brightness);
    for (int i = 0; i < numLeds; i++) {
        strip.setPixelColor(i, strip.Color(red, green, blue));
    }
    // Tắt các LED không sử dụng
    for (int i = numLeds; i < NUM_LEDS; i++) {
        strip.setPixelColor(i, strip.Color(0, 0, 0));  // Tắt LED
    }
    Serial.println("brightness: " + String(brightness) + ", numLeds: " + String(numLeds) + ", red: " + String(red) + ", green: " + String(green) + ", blue: " + String(blue));
    strip.show();
}

String getCurrentTime() {
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) {
        Serial.println("Failed to obtain time");
        return "N/A";
    }
    char buffer[30];
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", &timeinfo);
    return String(buffer);
}
