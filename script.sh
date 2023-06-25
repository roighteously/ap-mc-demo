APMC_HOME=~/Library/Application\ Support/Resources
APMC_DHOME=~/Library/Application\ Support/Resources/data
APMC_SHOME=~/Library/Application\ Support/Resources/server
APMC_JHOME=~/Library/Application\ Support/Resources/data/jdk-18.0.1.1.jdk/Contents/home/bin

rm -rf $APMC_DHOME
rm -rf $APMC_SHOME
rm -rf $APMC_HOME
mkdir $APMC_HOME $APMC_DHOME

mkdir $APMC_DHOME
cd $APMC_DHOME

curl https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_macos-aarch64_bin.tar.gz --output java.tar.gz
curl https://tlauncher.org/jar -L --output mc.zip
unzip mc.zip
tar -xf java.tar.gz -C java

ampi=$(ipconfig getifaddr en0)
vared -p "Host server? (h) " -c apmt
if [[ $apmt = "h" ]] then
    mkdir $APMC_SHOME
		cd $APMC_SHOME
    
    curl https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar --output server.jar
    $APMC_JHOME/java -jar server.jar # start server once to make eula
    rm eula.txt
    echo eula=TRUE >> eula.txt
    sed -i '' 's/online-mode=true/online-mode=false/' server.properties
    sed -i '' 's/motd=A Minecraft Server/motd=Apple Minecraft Demo Server/' server.properties
    screen -dmS mcs ~/Desktop/java/jdk-18.0.1.1.jdk/Contents/Home/bin/java -jar server.jar
    clear
    echo "Downloaded Java18, Minecraft, and the server."
    echo "Server started, launching Minecraft"
fi
cd $APMC_HOME
$APMC_JHOME/java -jar TLauncher*.jar
if [[ $apmt = "h" ]] then
    clear
    echo "Connect to $ampi"
fi
chmod +x ~/Library/Application\ Support/Resources/
xattr -r -d com.apple.quarantine ~/Library/Application\ Support/Resources/mcd/MinecraftDemo.app
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$HOME/Library/Application Support/Resources/mcd/MinecraftDemo.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
killall Dock