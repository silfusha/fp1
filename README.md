
cabal install --enable-tests
cabal build
cabal test

./dist/build/fcm/fcm -l -c 3 -i tasks/irises.txt


## Опции

  -h --header         
  -f --first          
  -l --last           
  -e --euclid         
  -m --hammin         
  -c --cluster INT    
  -r --random         
  -p --eps DOUBLE     
  -i --input STRING   
