To make it run:

1. bundle install
2. ruby script/region_scraper.rb
3. ruby script/grape_scraper.rb
4. ruby script/wine_scraper.rb
5. ruby script/grape_relations_importer.rb
6. rackup

Notes:

1. problems with nokogri? NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install

# TODO

reverse questions: Che vino viene fatto con queste uve? Docg di questa regione?
quali di queste uve non e' in questo vino?



Target : Vitigno
       In che regione
       In che regione non

       Che vino
       Che vino non

Target : Regione
       Nota: no regioni con i nomi dei vitigni
       Nota: no regioni con i nomi dei vini
       Che vitigno
       Che vitigno non
       10 vitigni

       Che vino
       Che vino non

Target : Vino
       In che regione

       Con che vitigni
       Con che vitigno non