# Get Latest Version online and compare with local version - should also work with not installed
(choco search respondusldb -r -s https://choco.aolccbc.com/api/v2).split("|")[1] -eq (choco list respondusldb -r).split('|')[1]

