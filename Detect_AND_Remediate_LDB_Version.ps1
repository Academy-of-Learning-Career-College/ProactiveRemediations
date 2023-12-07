

if(!((choco search respondusldb -r -s https://choco.aolccbc.com/api/v2).split("|")[1] -eq (choco list respondusldb -r).split('|')[1])){
    choco upgrade -y respondusldb -s "https://choco.aolccbc.com/api/v2"
}