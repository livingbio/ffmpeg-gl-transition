apt-get -y install xvfb
export DISPLAY=:99
Xvfb :99 -ac -screen 0 1920x1080x24 &

cd ..
./concat.sh