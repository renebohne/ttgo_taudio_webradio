#include <Wire.h>
#include <Adafruit_NeoPixel.h>
#include <WM8978.h> /* https://github.com/CelliesProjects/wm8978-esp32 */
#include <Audio.h>  /* https://github.com/schreibfaul1/ESP32-audioI2S */

#define I2S_BCK     33
#define I2S_WS      25
#define I2S_DOUT    26
#define I2S_DIN     27
#define I2S_MCLKPIN  0

//FOR ONBOARD PERIPHERALS
#define SDA_PIN 19
#define SCL_PIN 18

#define LED_PIN    22
#define LED_COUNT 19

#define VOLUME_UP_PIN 34
#define VOLUME_DOWN_PIN 36

#define wifi_ssid "youtube"
#define wifi_password "subscribe!"

WM8978 dac;
Audio audio;

int volume = 20;


WiFiClient espClient;

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);
  delay(100);
  Serial.println("TTGO T9 T-Audio Web-Radio");
  
  strip.begin();           
  strip.show();           
  strip.setBrightness(50); 

  pinMode(VOLUME_UP_PIN, INPUT);
  pinMode(VOLUME_DOWN_PIN, INPUT);

  Wire.begin(SDA_PIN, SCL_PIN);

  setupWifi();
  setupAudio();
}


void loop() {
  audio.loop();
  rainbow(1);

  int volume_up_state = digitalRead(VOLUME_UP_PIN);
  int volume_down_state = digitalRead(VOLUME_DOWN_PIN);

  if(volume_up_state == LOW)
  {
    if(volume<63)
    {
      volume++;
      dac.setSPKvol(volume);
    }
  }
  if(volume_down_state == LOW)
  {
    if(volume >1)
    {
      volume--;
      dac.setSPKvol(volume); 
    }
  }
}

void setupWifi()
{
  WiFi.begin(wifi_ssid, wifi_password);
  while (!WiFi.isConnected()) {
    delay(100);
    Serial.print(".");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  randomSeed(micros());
}

void setupAudio()
{
  if (!dac.begin())
    ESP_LOGE(TAG, "WM8978 setup error!");

  dac.setSPKvol(volume); /* max 63 */
  dac.setHPvol(volume, volume);

  audio.setPinout(I2S_BCK, I2S_WS, I2S_DOUT);
  audio.i2s_mclk_pin_select(I2S_MCLKPIN);

  //audio.connecttospeech("Online Lab Night", "de");
  //audio.connecttohost("http://streams.egofm.de/egoFM-hq");
  audio.connecttohost("http://192.168.100.215:8000/live");

}


unsigned long rainbow_lastMillis = 0;
long firstPixelHue = 0;
// Rainbow cycle along whole strip. Pass delay time (in ms) between frames.
void rainbow(int wait) {
  if ( (rainbow_lastMillis + wait) > millis() )
  {
    return;
  }

  for (int i = 0; i < strip.numPixels(); i++) {
    int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
    strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));
  }
  strip.show(); // Update strip with new contents

  firstPixelHue += 256;
  if (firstPixelHue >= 65536)
  {
    firstPixelHue = 0;
  }

  rainbow_lastMillis = millis();
}
