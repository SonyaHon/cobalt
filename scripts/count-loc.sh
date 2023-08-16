#!/opt/homebrew/bin/zsh
echo $(wc -l ./main.odin ./lib/**/*.odin ./shaders/*.glsl | grep "total") lines of code