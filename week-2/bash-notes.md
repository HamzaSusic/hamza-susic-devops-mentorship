# UNIX KOMANDE

ssh man - za listu komandi

ssh -i "lokacija identity fajla" korisnicko-ime@ipadresa

whoami -provjeriti o korisniku

Ukoliko ne radi ta konekcija na koji nacin troubleshooting???

ssh -i "lokacija identity fajla" korisnicko-ime@ipadresa -vvv -verbouse opcija

citav ispis u terminalu dok se uspostavllja konekcija

pwd -provjerim gdje se ja nalazim na tom serveru

Kako se navigirati dalje?

cd -navigacija kroz direktorije na serveru

cd .. -vratit cu se jedan korak unazad iz foldera u folder

Ako ponavljam doci cu do root foldera!

/ -root directorij

ls - da izlistam sta imam unutar svog direktorija

ls -la -dodatne detalje da li se radi o direktoriju ili fajlu

GDE PRONACI LOG ZAPISE?

Unutar direktorija var/log

Kako vidjeti sadrzaj fajla?

cat imefajla - sadrzaj fajla


sudo su root -komanda

tail -50 imefajla -komanda da ispise zadnjih 50 linija fajla

(ispisuje broj koji mu ja odredim umjesto 50)

touch imefajla.txt -komanda za kreiranje fajla

chmod +x ime-fajla.txt - dodati executable permisije na sve

man chmod - kako da upotrebljavamo tu komandu

chmod -x ime-fajla.txt -oduzmemo mu permisije koje smo dadali

chmod u+x ime-fajla.txt -samo useru das permisije

chmod broj sa kalkulatora -postavi permisije sa kalkulatora

Kako promijeniti grupu kojoj nas fajl pripada?

chown ime-usera:root ime-fajla.txt - a ako nece dodas sudo ispred

sudo chown ime-usera:root ime-fajla.txt

Kako pretrazit fajl po kljucnoj rijeci?

cat ime-fajla | grep "key"

grep "key" ime-fajla

wc -l ime-fajla - da provjerimo koliko fajl ima linija

grep -n "key" ime-fajla -brojeve linija na kojimma ne nalazi key

vi ime-fajla -fajl se otvori i spreman je za edit unutar vi

i - za insert mod

alias (ime-alijasa)="echo ispis necega npr"

Kad zavrsis edit i spasis moras ucitat taj fajl ponovo!

Koristeci komandu

source ime-fajla

source .bashrc

Kopiranje!

cp ime-fajla novi-fajl

mv ime-fajla novi fajl - prethodna verzija ce se izbrisati u ovom slucaju

Za instalaciju alata!

yum - package manager

yum install ime nekog paketa

artifactory -repo za tvoje pakete

wget link-paketa -

cd /etc/yum.repos.d/ - artifaktori repositoriji su konfigurisani ovdje

sudo yum install ime-paketa -y -da odobri install bez pitanja!